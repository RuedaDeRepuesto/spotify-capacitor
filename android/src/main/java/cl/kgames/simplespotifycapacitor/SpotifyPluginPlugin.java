package cl.kgames.simplespotifycapacitor;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.spotify.android.appremote.api.ConnectionParams;
import com.spotify.android.appremote.api.Connector;
import com.spotify.android.appremote.api.SpotifyAppRemote;

import com.spotify.protocol.client.Subscription;
import com.spotify.protocol.types.PlayerState;
import com.spotify.protocol.types.Track;


@CapacitorPlugin(name = "SpotifyPlugin")
public class SpotifyPluginPlugin extends Plugin {

    private static String CLIENT_ID = "";
    private static String REDIRECT_URI = "";

    private final String spotifyStateChangedCallback = "OnSpotifyStateChanged";
    private final String playerStateChangedCallback = "OnSpotifyPlayerStateChanged";

    private SpotifyAppRemote appRemote;
    private Track currentTrack;

    public void connected(PluginCall call, String url){
        call.resolve();
        appRemote.getPlayerApi()
                .subscribeToPlayerState()
                .setEventCallback(this::appRemotePlayerStateChanged);

        bridge.triggerWindowJSEvent(spotifyStateChangedCallback,spotifyEvent("Connected",false,true));
        appRemote.getPlayerApi().play(url);
    }


    public static String spotifyEvent(String message, boolean error, boolean conn){
        JSObject obj = new JSObject();
        try {
            obj.put("connected",conn);
            obj.put("message",message);
            obj.put("error",error);
            return obj.toString();
        } catch (Exception e) {
            return "{}";
        }
    }

    private void appRemotePlayerStateChanged(PlayerState playerState){
        if(appRemote.isConnected()) {
            bridge.triggerWindowJSEvent(playerStateChangedCallback,playerToJSON(playerState));
            currentTrack = playerState.track;
        }
        else{
            bridge.triggerWindowJSEvent(spotifyStateChangedCallback,spotifyEvent("Disconnected",false,false));
        }
    }

    public static String playerToJSON(PlayerState playerState)
    {
        JSObject obj = new JSObject();
        try {
            obj.put("songName",playerState.track.name);
            obj.put("songId",playerState.track.uri);
            obj.put("songImage",playerState.track.imageUri);
            obj.put("paused",playerState.isPaused);
            obj.put("albumName",playerState.track.album.name);
            obj.put("artistName",playerState.track.artist.name);
            obj.put("position",playerState.playbackPosition);
            obj.put("duration",playerState.track.duration);
            return obj.toString();
        } catch (Exception e) {
            return "{}";
        }
    }

    /*
    *
    * Metodos del plugin
    * */

    @PluginMethod()
    public void setup(PluginCall call){
        CLIENT_ID = call.getString("clientId");
        REDIRECT_URI = call.getString("redirectUri");
        call.resolve();
    }

    @PluginMethod()
    public void authorize(PluginCall call){
        String url = call.getString("url");
        if(url.isEmpty()){
            call.reject("Not url provided");
            return;
        }

        System.out.println("SpotifyPlugin: Autorizando!");
        //Logic
        ConnectionParams connectionParams =
                new ConnectionParams.Builder(CLIENT_ID)
                        .setRedirectUri(REDIRECT_URI)
                        .showAuthView(true)
                        .build();
        SpotifyAppRemote.connect(this.bridge.getContext(), connectionParams,
                new Connector.ConnectionListener() {

                    @Override
                    public void onConnected(SpotifyAppRemote spotifyAppRemote) {
                        appRemote = spotifyAppRemote;
                        connected(call, url);
                    }

                    @Override
                    public void onFailure(Throwable throwable) {
                        System.out.println("SpotifyPlugin: "+throwable.getMessage());
                        call.reject(throwable.getMessage());
                        bridge.triggerWindowJSEvent(spotifyStateChangedCallback,spotifyEvent(throwable.getMessage(),true,false));
                    }
                });
    }

    @PluginMethod()
    public void pause(PluginCall call){
        try{
            if(appRemote == null){
                call.reject("Not connected");
            }
            if(!appRemote.isConnected()){
                call.reject("Not connected");
            }

            appRemote.getPlayerApi().pause();
            call.resolve();
        }
        catch (Exception ex){
            call.reject("Not connected");
        }

    }

    @PluginMethod()
    public void resume(PluginCall call){
        try{
            if(appRemote == null){
                call.reject("Not connected");
            }
            if(!appRemote.isConnected()){
                call.reject("Not connected");
            }

            appRemote.getPlayerApi().resume();
            call.resolve();
        }
        catch(Exception ex) {
            call.reject("Not connected");
        }
    }


    @PluginMethod()
    public void skipNext(PluginCall call){
        if(appRemote == null){
            call.reject("Not connected");
        }
        if(!appRemote.isConnected()){
            call.reject("Not connected");
        }

        appRemote.getPlayerApi().skipNext();
        call.success();
    }

    @PluginMethod()
    public void skipPrev(PluginCall call){
        if(appRemote == null){
            call.reject("Not connected");
        }
        if(!appRemote.isConnected()){
            call.reject("Not connected");
        }

        appRemote.getPlayerApi().skipPrevious();
        call.success();
    }

    @PluginMethod()
    public void playSong(PluginCall call){
        try{
            String url = call.getString("url");
            if(url.isEmpty()){
                call.reject("Not url provided");
                return;
            }

            if(appRemote == null){
                call.reject("Not connected");
            }
            if(!appRemote.isConnected()){
                call.reject("Not connected");
            }

            appRemote.getPlayerApi().play(url);
            call.resolve();
        }
        catch(Exception ex) {
            call.reject("Not connected");
        }
    }


}
