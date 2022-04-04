'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const SpotifyPlugin = core.registerPlugin('SpotifyPlugin', {
    web: () => Promise.resolve().then(function () { return web; }).then(m => new m.SpotifyPluginWeb()),
});

class SpotifyPluginWeb extends core.WebPlugin {
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

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    SpotifyPluginWeb: SpotifyPluginWeb
});

exports.SpotifyPlugin = SpotifyPlugin;
//# sourceMappingURL=plugin.cjs.js.map
