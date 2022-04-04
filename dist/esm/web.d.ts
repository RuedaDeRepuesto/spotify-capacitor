import { WebPlugin } from '@capacitor/core';
import type { SpotifyOptions, SpotifyPlayerStatus, SpotifyPluginPlugin, SpotifySong } from './definitions';
export declare class SpotifyPluginWeb extends WebPlugin implements SpotifyPluginPlugin {
    setup(options: SpotifyOptions): Promise<void>;
    playSong(song: SpotifySong): Promise<void>;
    pause(): Promise<void>;
    resume(): Promise<void>;
    skipPrev(): Promise<void>;
    skipNext(): Promise<void>;
    getPlayerState(): Promise<SpotifyPlayerStatus>;
    authorize(song: SpotifySong): Promise<void>;
    disconnect(): Promise<void>;
}
