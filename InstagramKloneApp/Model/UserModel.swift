//
//  UserModel.swift
//  InstagramKloneApp
//
//  Created by Christian on 23.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation

class UserModel {
    
    var username: String?
    var email: String?
    var profilImageUrl: String?
    
    var uid: String?
    
    var isFollowing: Bool?
    
    init(dictionary: [String: Any]) {
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
        profilImageUrl = dictionary["profilImageUrl"] as? String
        uid = dictionary["uid"] as? String
    }
}
