//
//  Playlist.swift
//  Final Project
//
//  Created by Jack Thompson on 12/6/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Playlist{
    //use later
    //var href:String!
    
    var id: String!
    var name: String!
    var tracks: [Track] = [] //may be empty
    var author: String!
    var user: String!
    var imageURL:String! //may be empty
    var image:UIImage!
    var stats: [String: Float] = [:]
    
    init () {
        self.name = "Moodify Playlist"
        self.tracks = []
    }
    
    init (json: JSON) {
        let uri = json["uri"].string!
        self.id = String(uri[(uri.count - 22)...uri.count-1])
        self.name = json["name"].stringValue
        self.author = json["owner"]["display_name"].stringValue
        self.user = json["owner"]["id"].stringValue
        if !(json["images"].arrayValue.isEmpty) {
            self.imageURL = json["images"].array?.first!["url"].stringValue
        }
        else {
            self.imageURL = ""
            
        }
        self.image = #imageLiteral(resourceName: "Music-icon")
        //getData()
    }
    
    func getData(){
        DispatchQueue.main.async {
        NetworkManager.getImage(url: self.imageURL) { (image) in
            print("get data image")
            self.image = image
            NetworkManager.getTracks(userID: self.user, playlistID: self.id) { (tracks) in
                self.tracks = tracks
            }
        }
        }
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
}
