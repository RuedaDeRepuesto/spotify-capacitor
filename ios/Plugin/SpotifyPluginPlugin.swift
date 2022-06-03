import Foundation
import Capacitor
import SpotifyiOS

@objc(SpotifyPluginPlugin)
public class SpotifyPluginPlugin: CAPPlugin, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    
    
    
    // Window JS Events
    let playerStateChangedEventName = "OnSpotifyPlayerStateChanged"
    let spotifyStateChangedEventName = "OnSpotifyStateChanged"
    
    var accessToken:String = ""
    
    var configuration = SPTConfiguration(
      clientID: "",
      redirectURL: URL(string:"app://empty")!
    )
    
    var appRemote: SPTAppRemote?;
    
    
    @objc override public func load() {
        print("Spotify plugin carga3");
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUrlOpened(notification:)), name: Notification.Name.capacitorOpenURL, object: nil)
    }
    
    
    @objc func authorize(_ call: CAPPluginCall){
        
        guard let url = call.getString("url") else{
            call.reject("Url no ingresada")
            return
        }
        
        guard let remote = self.appRemote else{
            call.reject("Spotify no init")
            return
        }
        
        print("ClientId:"+configuration.clientID)
        
        DispatchQueue.main.async {
            remote.authorizeAndPlayURI(url)
            call.resolve()
        }
    }
    
    
    //Metodos del plugin!
    
    @objc func setup(_ call: CAPPluginCall) {
        let client = call.getString("clientId") ?? ""
        let rUrl = call.getString("redirectUri") ?? ""
        
        configuration = SPTConfiguration(
                clientID: client,
                redirectURL: URL(string:rUrl)!
        )
        
        appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote?.connectionParameters.accessToken = self.accessToken
        appRemote?.delegate = self

        
        call.resolve()
    }
    
    @objc func pause(_ call: CAPPluginCall){
        guard let player = self.appRemote?.playerAPI else{
            call.reject("No player active")
            return
        }
        
        DispatchQueue.main.async {
            player.pause()
            call.resolve()
        }
        
    }
    
    @objc func resume(_ call:CAPPluginCall){
        
        guard let player = self.appRemote?.playerAPI else{
            call.reject("No player active")
            return
        }
        
        DispatchQueue.main.async {
            player.resume(nil)
            call.resolve()
        }
    }
    
    
    @objc func skipNext(_ call: CAPPluginCall)
    {
        guard let player = self.appRemote?.playerAPI else{
            call.reject("No player active")
            return
        }
        
        DispatchQueue.main.async {
            player.skip(toNext: nil)
            call.resolve()
        }
        
    }
    
    
    @objc func skipPrev(_ call: CAPPluginCall){
        guard let player = self.appRemote?.playerAPI else{
            call.reject("No player active")
            return
        }
        DispatchQueue.main.async {
            player.skip(toPrevious: nil)
            call.resolve()
        }
    }
    
    @objc func getPlayerState(_ call: CAPPluginCall){
        guard let player = self.appRemote?.playerAPI else{
            call.reject("No player active")
            return
        }
        
        DispatchQueue.main.async {
            player.getPlayerState { (result, error) -> Void in
                guard error == nil else {
                    call.reject("Error geting playerState")
                    return
                }

                let playerState = result as! SPTAppRemotePlayerState
                call.resolve(playerState.toDictionary())
            }
        }
    }
    
    @objc func playSong(_ call: CAPPluginCall){
            
        guard let url = call.getString("url") else{
            call.reject("Url no ingresada")
            return
        }
                
        guard let player = self.appRemote?.playerAPI else{
            call.reject("No player active")
            return
        }
        
        DispatchQueue.main.async {
            player.play(url)
            call.resolve()
        }
    }
    
    //callbacks
    
    @objc func handleUrlOpened(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?] else {
            return
        }
        
        guard let url = object["url"] as? NSURL else {
            return
        }

        guard let absUrl = url.absoluteURL else{
            return
        }
        
        handleCallback(url: absUrl)
    }
    
    public func handleCallback(url:URL)
    {
        guard let remote = self.appRemote else{
            return
        }
        let parameters = remote.authorizationParameters(from: url);

        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            remote.connectionParameters.accessToken = access_token
            remote.connect()
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Show the error
            print(error_description)
        }
    }
    
    
    
    /// Delagate Methods
    ///
    public func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("")
        print("******CONEXION*******")
        
        guard let remote = self.appRemote else{
            return
        }
        
        remote.playerAPI?.delegate = self
        remote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                let event = SpotifyStateChangedEvent(message:error.localizedDescription, connected: false, error: true)
                self.bridge?.triggerWindowJSEvent(eventName: self.spotifyStateChangedEventName, data: event.toJSON())
                return
            }
            let event = SpotifyStateChangedEvent(message: "Conexion establecida", connected: true, error: false)
            self.bridge?.triggerWindowJSEvent(eventName: self.spotifyStateChangedEventName, data: event.toJSON())
        })
    }
    
    public func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        let event = SpotifyStateChangedEvent(message: "Conexion perdida: \(String(describing: error?.localizedDescription))", connected: false, error: true)
        self.bridge?.triggerWindowJSEvent(eventName: self.spotifyStateChangedEventName, data: event.toJSON())
        
    }
    
    public func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        let event = SpotifyStateChangedEvent(message: "Conexion perdida: \(String(describing: error?.localizedDescription))", connected: false, error: true)
        self.bridge?.triggerWindowJSEvent(eventName: self.spotifyStateChangedEventName, data: event.toJSON())
    }
    
    public func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.bridge?.triggerWindowJSEvent(eventName: playerStateChangedEventName, data: playerState.toJSON(nil))

        //generamos un segundo evento que tenga la imagen, en teoria fetch image es async por lo cual tendria que pasar despues, en teoria...
        guard let image = self.appRemote.imageAPI{
            guard let track = playerState.track{
                DispatchQueue.main.async {
                        image.fetchImage(forItem: track, with:CGSize(width: 128, height: 128), callback: { (image, error) -> Void in
                        guard error == nil {
                            let image = image as! UIImage
                            let imageString = image.toBase64()
                            self.bridge?.triggerWindowJSEvent(eventName: playerStateChangedEventName, data: playerState.toJSON(imageString))
                        }
                    })
                }
            }
        }
    }
    
    
}
