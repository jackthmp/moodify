//
//  Track.swift
//  Final Project
//
//  Created by Jack Thompson on 12/6/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import Foundation
import SwiftyJSON

class Track{
    //will gather data from Song's href later
    //var href:String!
    
    var name:String!
    var artist:String!
    var album:String!
    var previewURL: String!
    var id:String!
    var uri:String!
    
    init (json: JSON){
        self.name = json["name"].stringValue
        self.artist = json["artists"].array?.first?["name"].stringValue
        self.album = json["album"]["name"].stringValue
        self.previewURL = json["previewURL"].stringValue
        self.id = json["id"].stringValue
        self.uri = json["uri"].stringValue
    }
}
