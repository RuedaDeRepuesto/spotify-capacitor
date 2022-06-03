export interface SpotifyPluginPlugin {
    playSong(song: SpotifySong): Promise<void>;
    pause(): Promise<void>;
    resume(): Promise<void>;
    skipPrev(): Promise<void>;
    skipNext(): Promise<void>;
    getPlayerState(): Promise<SpotifyPlayerStatus>;
    authorize(song: SpotifySong): Promise<void>;
    setup(options: SpotifyOptions): Promise<void>;
}
export interface SpotifyOptions {
    clientId: string;
    redirectUri: string;
}
export interface SpotifySong {
    url: string;
}
export interface SpotifyPlayerStatus {
    paused?: boolean;
    podcast?: boolean;
    songId?: string;
    songName?: string;
    albumName?: string;
    artistName?: string;
    position?: number;
    duration?: number;
    title?: string;
    coverImageBase64?: string;
}
export interface SpotifySDKStatus {
    connected: boolean;
    error?: boolean;
    message?: string;
}
