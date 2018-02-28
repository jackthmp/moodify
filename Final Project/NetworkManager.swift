//
//  NetworkManager.swift
//  
//
//  Created by Jack Thompson on 12/2/17.
//

import Foundation

import SwiftyJSON
import Alamofire
import SpotifyLogin


let hostURL = "https://api.spotify.com"

class NetworkManager{
    static var user:User!
    
    static func getPlaylists(completion: @escaping ([Playlist]) -> Void){
        guard let url = URL(string: hostURL + "/v1/me/playlists") else { return }
        let parameters:[String: Any] = ["limit": 50]
        
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + code!])
                    .validate().responseJSON{ response in
                        switch response.result {
                        case .success(let data):
                            let json = JSON(data)
                            var playlists:[Playlist] = []
                            let dispatchGroup = DispatchGroup()
                            
                            DispatchQueue.main.async {
                                for playlist in json["items"].arrayValue {
                                    if playlist["tracks"]["total"].intValue > 0 {
                                        dispatchGroup.enter()
                                        let currentPlaylist = Playlist(json:playlist)
                                        playlists.append(currentPlaylist)
                                        completion(playlists)
                                    }
                                }
                                
                            }
                        case .failure (let error):
                            print(error)
                        }
                }
            }
        }
    }
    
    static func getTracks(userID: String, playlistID: String, completion: @escaping ([Track]) -> Void){
        guard let url = URL(string: hostURL + "/v1/users/" + userID + "/playlists/" + playlistID) else { return }
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + code!]).validate().responseJSON{ response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        var tracks:[Track] = []
                        //print(json["tracks"]["items"])
                        for track in json["tracks"]["items"].arrayValue {
                            tracks.append(Track(json: track["track"]))
                        }
                        completion(tracks)
                    case .failure (let error):
                        print(error)
                        completion([])
                    }
                }
            }
        }
        
    }
    
    
    
    static func getUser(completion: @escaping (User) -> Void){
        guard let url = URL(string: hostURL + "/v1/me") else { return }
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + code!])
                    .validate().responseJSON { response in
                        switch response.result {
                        case .success(let data):
                            let json = JSON(data)
                            let user = User(json: json)
                            self.user = user
                            completion(user)
                        case .failure (let error):
                            print(error)
                        }
                        
                }
            }
            else { print(error!) }
        }
    }
    
    static func getImage(url: String, completion: @escaping (UIImage) -> Void){
        if let imageURL = URL(string: url) {
            Alamofire.request(imageURL).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data){
                        completion(image)
                    }
                    else {
                        print("Unable to convert data to image")
                        completion(#imageLiteral(resourceName: "Music-icon"))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(#imageLiteral(resourceName: "Music-icon"))
                }
            }
        }
        else { completion(#imageLiteral(resourceName: "Music-icon")) }
    }
    
    static func getTopTracks(userid: String, timeRange: String, limit: Int, completion: @escaping ([Track]) -> Void){
        guard let url = URL(string: hostURL + "/v1/me/top/tracks") else { return }
        let parameters:[String: Any] = ["time_range": timeRange,
                                        "limit" : limit]
        var topTracks:[Track] = []
        
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + code!]).validate().responseData { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        for track in json["items"].arrayValue{
                            topTracks.append(Track(json: track))
                        }
                    case .failure(let error):
                        print(error)
                    }
                    completion(topTracks)
                }
            }
        }
    }
    
    static func analyzeTracks(tracks:[Track], completion: @escaping ([String: Float]) -> Void){
        var danceability:Float = 0.0
        var energy:Float = 0.0
        var instrumentalness:Float = 0.0
        var valence:Float = 0.0
        var acousticness:Float = 0.0
        var trackList = ""
        for track in tracks{
            trackList += track.id + ","
        }
        guard let url = URL(string: hostURL + "/v1/audio-features") else { return }
        let parameters:[String: Any] = ["ids": trackList]
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + code!]).validate().responseData { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        for track in json["audio_features"].arrayValue{
                            danceability += track["danceability"].floatValue
                            energy += track["energy"].floatValue
                            instrumentalness += track["instrumentalness"].floatValue
                            valence += track["valence"].floatValue
                            acousticness += track["acousticness"].floatValue
                        }
                        danceability = danceability / Float(json["audio_features"].arrayValue.count)
                        energy = energy / Float(json["audio_features"].arrayValue.count)
                        instrumentalness = instrumentalness / Float(json["audio_features"].arrayValue.count)
                        valence = valence / Float(json["audio_features"].arrayValue.count)
                        acousticness = acousticness / Float(json["audio_features"].arrayValue.count)
                        completion(["danceability" : danceability,
                                    "energy" : energy,
                                    "instrumentalness" : instrumentalness,
                                    "valence" : valence,
                                    "acousticness" : acousticness])
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                }
                
            }
        }
    }
    
    static func getSavedTracks(offset: Int, completion: @escaping ([Track]) -> Void){
        guard let url = URL(string: hostURL + "/v1/me/tracks/") else { return }
        let parameters:[String: Any] = ["offset" : offset, "limit" : 50]
        var alltracks: [Track] = []
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: parameters, headers: ["Authorization": "Bearer " + code!]).validate().responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        for track in json["items"].arrayValue {
                            alltracks.append(Track(json: track["track"]))
                        }
                        if json["next"] == JSON.null {
                            completion(alltracks)
                        }
                        else {
                            completion(alltracks)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    static func createPlaylist(name: String, completion: @escaping (Playlist) -> Void){
        guard let url = URL(string: hostURL + "/v1/users/" + user.id + "/playlists/") else { return }
        let parameters:[String: Any] = ["description" : "A playlist created by Moodify.", "public" : true, "name" : name]
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer " + code!]).validate().responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        let playlist = Playlist(json: json)
                        completion(playlist)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    static func addTracksToPlaylist(playlistid: String, tracks: [Track], completion: @escaping ([Track]) -> Void){
        guard let url = URL(string: hostURL + "/v1/users/" + user.id + "/playlists/" + playlistid + "/tracks") else { return }
        var uris: String = ""
        for track in tracks {
            uris += "\(track.uri!),"
        }
        let parameters:[String : Any] = ["uris" : uris]
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: ["Authorization": "Bearer " + code!]).validate(contentType: ["application/json"]).responseJSON { response in
                    switch response.result {
                    case .success(_):
                        completion(tracks)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    static func getTopArtists(completion: @escaping (String) -> Void) {
        guard let url = URL(string: hostURL + "/v1/me/top/artists") else { return }
        let parameters:[String: Any] = ["time_range": "short_term",
                                        "limit" : 3]
        var seed:String = ""
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization": "Bearer " + code!]).validate().responseData { response in
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        for artist in json["items"].arrayValue {
                            print(artist["name"].stringValue)
                            seed += "\(artist["id"].stringValue),"
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    completion(seed)
                }
            }
        }
    }
    
    static func getRecommendations(energy: Float, valence: Float, danceability: Float, completion: @escaping ([Track]) -> Void) {
        guard let url = URL(string: hostURL + "/v1/recommendations") else { return }
        var seed = ""
        getTopTracks(userid: user.id, timeRange: "short_term", limit: 2) { (tracks) in
            for track in tracks {
                print(track.name)
                seed += "\(track.id!),"
            }
//            getTopTracks(userid: user.id, timeRange: "long_term", limit: 2) { (tracks) in
//                for track in tracks {
//                    print(track.name)
//                    seed += "\(track.id!),"
//                }
            getTopArtists { (artistSeed) in
                let parameters:[String : Any] = ["seed_tracks" : seed, //"seed_artists" : artistSeed,
                                                 "target_energy" : energy,
                                                 "target_valence" : valence,
                                                 "target_danceability" : danceability]
                
                var recommended: [Track] = []
                SpotifyLogin.shared.getAccessToken { (code, error) in
                    print(seed)
                    if (error == nil){
                        Alamofire.request(url, method: .get, parameters: parameters, headers: ["Authorization": "Bearer " + code!]).validate(contentType: ["application/json"]).responseJSON { response in
                            switch response.result {
                                
                            case .success(let data):
                                let json = JSON(data)
                                for track in json["tracks"].arrayValue{
                                    recommended.append(Track(json: track))
                                }
                            case .failure(let error):
                                print(error)
                            }
                            completion(recommended)
                            
                        }
                    }
                }
            }
        }
    }
    
    static func deletePlaylist(playlistid: String, completion: @escaping () -> Void){
        guard let url = URL(string: hostURL + "/v1/users/" + user.id + "/playlists/" + playlistid + "/followers") else { return }
        SpotifyLogin.shared.getAccessToken { (code, error) in
            if (error == nil){
                Alamofire.request(url, method: .delete, headers: ["Authorization": "Bearer " + code!]).validate().responseJSON { response in
                    completion()
                }
            }
        }
    }
}
