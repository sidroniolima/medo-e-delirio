import assert from 'node:assert/strict';
import { test } from 'node:test';

import { buildMessage, decide, parseLatestEpisode } from './notifier.mjs';

const spreaker = {
  response: {
    items: [
      {
        episode_id: 76472984,
        title: 'II - 2026.80 - O dólar e o divã',
        site_url: 'https://www.spreaker.com/episode/x--76472984',
        image_url: 'https://img/160.jpg',
        image_original_url: 'https://img/original.jpg',
        published_at: '2026-11-19 23:53:51',
      },
    ],
  },
};

test('parses the latest episode', () => {
  const episode = parseLatestEpisode(spreaker);
  assert.equal(episode.id, '76472984');
  assert.equal(episode.title, 'II - 2026.80 - O dólar e o divã');
  assert.equal(episode.image, 'https://img/original.jpg');
});

test('fails on an empty response', () => {
  assert.throws(() => parseLatestEpisode({ response: { items: [] } }));
});

test('first run only remembers the episode', () => {
  assert.equal(decide(null, { id: '1' }), 'bootstrap');
});

test('skips an episode already notified', () => {
  assert.equal(decide({ lastEpisodeId: '1' }, { id: '1' }), 'skip');
});

test('notifies a new episode', () => {
  assert.equal(decide({ lastEpisodeId: '1' }, { id: '2' }), 'notify');
});

test('builds the message for the topic, with string-only data', () => {
  const message = buildMessage(parseLatestEpisode(spreaker), 'debug');
  assert.equal(message.topic, 'debug');
  assert.equal(message.notification.body, 'II - 2026.80 - O dólar e o divã');
  assert.equal(message.notification.imageUrl, 'https://img/original.jpg');
  for (const value of Object.values(message.data)) {
    assert.equal(typeof value, 'string');
  }
});
