//
//  User.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import UIKit
import Swifter

class User {
    var id: UInt = 0
    var name: String = ""
    var screenName: String = ""
    var verified: Bool = false
    var profileImageURL: URL?
    var profileBackgroundColour: UIColor = UIColor()
    
    init() {
        
    }
    
    init(id: UInt, name: String, screenName: String, verified: Bool, profileImageURL: URL? = nil, profileBackgroundColour: UIColor) {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.verified = verified
        self.profileImageURL = profileImageURL
        self.profileBackgroundColour = profileBackgroundColour
    }
    
    convenience init(from json: JSON) {
        self.init()
        
        if let id = json["id_str"].string {
            self.id = UInt(id) ?? 0
        }
        if let name = json["name"].string {
            self.name = name
        }
        if let screenName = json["screen_name"].string {
            self.screenName = screenName
        }
        if let verified = json["verified"].bool {
            self.verified = verified
        }
        if let profileImageURL = json["profile_image_url_https"].string {
            self.profileImageURL = URL(string: profileImageURL)
        }
        if let profileBackgroundColour = json["profile_background_color"].string {
            if profileBackgroundColour.contains("000000") {
                self.profileBackgroundColour = UIColor.systemBlue
            } else {
                self.profileBackgroundColour = UIColor(hexString: profileBackgroundColour) ?? UIColor.systemBlue
            }
        }
    }
}
