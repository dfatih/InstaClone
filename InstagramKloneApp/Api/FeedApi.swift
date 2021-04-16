//
//  FeedApi.swift
//  InstagramKloneApp
//
//  Created by Christian on 05.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    // Datenbank Adresse
    var REF_NEWSFEED = Database.database().reference().child("newsFeed")
    
    // Singleton pattern (Einzelstück Muster)
    static let shared: FeedApi = FeedApi()
    private init() {
    }
    
    // Lade die Posts aus Posts in der Datenbank, mit Hilfe der postId welche im NewsFeed hinterlegt sind
    func observeFeed(withUid uid: String, completion: @escaping (PostModel) -> Void) {
        REF_NEWSFEED.child(uid).observe(.childAdded) { (snapshot) in
            let postId = snapshot.key
            PostApi.shared.observePost(withPostId: postId, completion: { (post) in
                completion(post)
            })
        }
    }
    
    // Hört zu ob der User einem anderen nicht mehr folgt
    func observeRemoveFeed(withUid uid: String, completion: @escaping (PostModel) -> Void) {
        REF_NEWSFEED.child(uid).observe(.childRemoved) { (snapshot) in
            let postId = snapshot.key
            PostApi.shared.observePost(withPostId: postId, completion: { (post) in
                completion(post)
            })
        }
    }
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
