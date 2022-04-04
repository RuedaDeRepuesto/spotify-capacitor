import { registerPlugin } from '@capacitor/core';
const SpotifyPlugin = registerPlugin('SpotifyPlugin', {
    web: () => import('./web').then(m => new m.SpotifyPluginWeb()),
});
export * from './definitions';
export { SpotifyPlugin };
//# sourceMappingURL=index.js.map