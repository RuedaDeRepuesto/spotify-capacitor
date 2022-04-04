import { WebPlugin } from '@capacitor/core';
export class SpotifyPluginWeb extends WebPlugin {
    setup(options) {
        throw new Error('Method not implemented.' + options.redirectUri);
    }
    playSong(song) {
        throw new Error('Method not implemented.' + song.url);
    }
    pause() {
        throw new Error('Method not implemented.');
    }
    resume() {
        throw new Error('Method not implemented.');
    }
    skipPrev() {
        throw new Error('Method not implemented.');
    }
    skipNext() {
        throw new Error('Method not implemented.');
    }
    getPlayerState() {
        throw new Error('Method not implemented.');
    }
    authorize(song) {
        throw new Error('Method not implemented.' + song.url);
    }
    disconnect() {
        throw new Error('Method not implemented.');
    }
}
//# sourceMappingURL=web.js.map