import { registerPlugin } from '@capacitor/core';

import type { SpotifyPluginPlugin } from './definitions';

const SpotifyPlugin = registerPlugin<SpotifyPluginPlugin>('SpotifyPlugin', {
  web: () => import('./web').then(m => new m.SpotifyPluginWeb()),
});

export * from './definitions';
export { SpotifyPlugin };
