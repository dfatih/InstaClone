//
//  CommentModel.swift
//  InstagramKloneApp
//
//  Created by Christian on 26.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation

class CommentModel {
    
    var commentText: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        commentText = dictionary["commentText"] as? String
        uid = dictionary["uid"] as? String
    }
}
