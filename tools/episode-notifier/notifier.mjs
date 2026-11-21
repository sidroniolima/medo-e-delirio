// Pure logic, kept apart from I/O so it can be tested and later moved
// into a Cloud Function as is.

export const SHOW_ID = 4711842;

export const latestEpisodeUrl = (showId = SHOW_ID) =>
  `https://api.spreaker.com/v2/shows/${showId}/episodes?limit=1&sorting=newest`;

/** Picks the fields we use from a Spreaker episodes response. */
export function parseLatestEpisode(response) {
  const episode = response?.response?.items?.[0];
  if (!episode?.episode_id || !episode?.title) {
    throw new Error('Spreaker response has no episode');
  }

  return {
    id: String(episode.episode_id),
    title: episode.title,
    url: episode.site_url,
    image: episode.image_original_url ?? episode.image_url,
    publishedAt: episode.published_at,
  };
}

/**
 * What to do with the latest episode given the saved state.
 * - bootstrap: first run, only remember it, so an old episode isn't sent.
 * - skip: already notified.
 * - notify: a new episode came out.
 */
export function decide(state, episode) {
  if (!state?.lastEpisodeId) return 'bootstrap';
  if (state.lastEpisodeId === episode.id) return 'skip';
  return 'notify';
}

/** The FCM message for a new episode. */
export function buildMessage(episode, topic) {
  return {
    topic,
    notification: {
      title: 'Episódio novo no ar!',
      body: episode.title,
      ...(episode.image ? { imageUrl: episode.image } : {}),
    },
    data: {
      kind: 'new_episode',
      episodeId: episode.id,
      ...(episode.url ? { url: episode.url } : {}),
    },
    android: {
      notification: { color: '#243119' },
    },
  };
}

export const stateFor = (episode) => ({
  lastEpisodeId: episode.id,
  lastEpisodeTitle: episode.title,
  updatedAt: new Date().toISOString(),
});
