#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(SpotifyPluginPlugin, "SpotifyPlugin",
           CAP_PLUGIN_METHOD(setup, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(authorize, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(pause, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(resume, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(skipNext, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(skipPrev, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getPlayerState, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(playSong, CAPPluginReturnPromise);
)
