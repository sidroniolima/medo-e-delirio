// Checks Spreaker for a new episode and pushes it through FCM.
//
// Env:
//   STATE_FILE                 JSON file with the last notified episode.
//   PUSH_TOPIC                 FCM topic, "debug" by default.
//   DRY_RUN                    "true" logs the message instead of sending it.
//   FORCE                      "true" sends the latest episode even if already sent.
//   GOOGLE_APPLICATION_CREDENTIALS  service account JSON (not needed on dry run).

import { readFile, writeFile } from 'node:fs/promises';

import {
  buildMessage,
  decide,
  latestEpisodeUrl,
  parseLatestEpisode,
  stateFor,
} from './notifier.mjs';

const stateFile = process.env.STATE_FILE ?? 'state.json';
const topic = process.env.PUSH_TOPIC || 'debug';
const dryRun = process.env.DRY_RUN === 'true';
const force = process.env.FORCE === 'true';

async function readState() {
  try {
    return JSON.parse(await readFile(stateFile, 'utf8'));
  } catch (error) {
    if (error.code === 'ENOENT') return null;
    throw error;
  }
}

const saveState = (episode) =>
  writeFile(stateFile, JSON.stringify(stateFor(episode), null, 2) + '\n');

async function send(message) {
  if (dryRun) {
    console.log('DRY_RUN, would send:', JSON.stringify(message, null, 2));
    return;
  }

  // Loaded lazily so a dry run needs no credentials.
  const { initializeApp, applicationDefault } = await import('firebase-admin/app');
  const { getMessaging } = await import('firebase-admin/messaging');

  initializeApp({ credential: applicationDefault() });
  const id = await getMessaging().send(message);
  console.log(`Sent to topic "${message.topic}": ${id}`);
}

const response = await fetch(latestEpisodeUrl());
if (!response.ok) throw new Error(`Spreaker answered ${response.status}`);

const episode = parseLatestEpisode(await response.json());
const action = force ? 'notify' : decide(await readState(), episode);
console.log(`Latest: ${episode.id} "${episode.title}" -> ${action}`);

if (action === 'notify') await send(buildMessage(episode, topic));

// Saved only after a successful send, so a failure is retried next run.
// A dry run never moves the state forward.
if (action !== 'skip' && !dryRun) await saveState(episode);
