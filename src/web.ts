import { WebPlugin } from '@capacitor/core';

import type { SpotifyOptions, SpotifyPlayerStatus, SpotifyPluginPlugin, SpotifySong } from './definitions';

export class SpotifyPluginWeb extends WebPlugin implements SpotifyPluginPlugin {
  setup(options: SpotifyOptions): Promise<void> {
    throw new Error('Method not implemented.'+options.redirectUri);
  }
  playSong(song: SpotifySong): Promise<void> {
    throw new Error('Method not implemented.' +song.url);
  }
  pause(): Promise<void> {
    throw new Error('Method not implemented.');
  }
  resume(): Promise<void> {
    throw new Error('Method not implemented.');
  }
  skipPrev(): Promise<void> {
    throw new Error('Method not implemented.');
  }
  skipNext(): Promise<void> {
    throw new Error('Method not implemented.');
  }
  getPlayerState(): Promise<SpotifyPlayerStatus> {
    throw new Error('Method not implemented.');
  }
  authorize(song: SpotifySong): Promise<void> {
    throw new Error('Method not implemented.'+song.url);
  }
  disconnect(): Promise<void> {
    throw new Error('Method not implemented.');
  }
}
