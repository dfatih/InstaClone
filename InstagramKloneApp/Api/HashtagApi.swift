//
//  HashtagApi.swift
//  InstagramKloneApp
//
//  Created by Christian on 19.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HashtagApi {
    var REF_HASHTAG = Database.database().reference().child("hashtag")
    
    static let shared: HashtagApi = HashtagApi()
    private init() {
    }
    
    func fetchPostsId(with hashtag: String, completion: @escaping(String) -> Void) {
        REF_HASHTAG.child(hashtag.lowercased()).observe(.childAdded) { (snapshot) in
            completion(snapshot.key)
        }
    }
}
