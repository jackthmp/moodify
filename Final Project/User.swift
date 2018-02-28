//
//  User.swift
//  Final Project
//
//  Created by Jack Thompson on 12/8/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class User{
    var id: String!
    var displayName: String = ""
    var followers: Int!
    var imageURL:String = ""
    var profileURL: URL!
    
    init (json: JSON){
        self.id = json["id"].stringValue
        self.displayName = json["display_name"].stringValue
        self.followers = json["followers"]["total"].intValue
        self.imageURL = (json["images"].array?.first?["url"].string)!
        self.profileURL = URL(string: json["external_urls"]["spotify"].stringValue)!
    }
}
