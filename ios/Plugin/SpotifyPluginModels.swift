//
//  SpotifyPluginModels.swift
//  SimpleSpotifyCapacitor
//
//  Created by Jorge Videla on 02-04-22.
//

import Foundation
import SpotifyiOS


struct SpotifyStateChangedEvent: Codable {
    var message: String
    var connected: Bool
    var error: Bool
    
    public func toJSON() -> String{
        do
        {
            let jsonData = try JSONEncoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        }
        catch{
            return "{}"
        }
        
    }
}


extension SPTAppRemotePlayerState {
    
    // Get State as dictionary
    public func toDictionary() -> [String : Any]{
        let obj:[String : Any] = [
            "paused":self.isPaused,
            "podcast":self.track.isPodcast,
            "songId":self.track.uri,
            "songName":self.track.name,
            "albumName":self.track.album.name,
            "artistName":self.track.artist.name,
            "position":self.playbackPosition,
            "duration": self.track.duration,
            "title": self.contextTitle
        ]
        return obj
    }
    
    
    // Stringfy
    public func toJSON() -> String{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self.toDictionary(),
            options: []) {
            let theJSONText = String(data: theJSONData,
                                       encoding: .ascii)
            return theJSONText!
        }
        
        return "{}"
    }
}
