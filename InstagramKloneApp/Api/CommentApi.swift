//
//  CommentApi.swift
//  InstagramKloneApp
//
//  Created by Christian on 28.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    // Adresse Datenbank comments
    var REF_COMMENTS = Database.database().reference().child("comments")
    var REF_POST_COMMENTS = Database.database().reference().child("post-comments")
    
    // Singleton pattern (Einzelstück Muster)
    static var shared: CommentApi = CommentApi()
    private init() {
    }
    
    // Lade die commentId für den jeweiligen Post herrunter
    func observePostComments(postId: String, completion: @escaping (String) -> Void) {
        REF_POST_COMMENTS.child(postId).observe(.childAdded) { (snapshot) in
            let commentId = snapshot.key
            completion(commentId)
        }
    }
    
    // Lade das Kommentar mit der id...
    func observeComment(commentId: String, completion: @escaping (CommentModel) -> Void) {
        REF_COMMENTS.child(commentId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let newComment = CommentModel(dictionary: dic)
            completion(newComment)
        }
    }
    
    // Kommentar erstellen
    func createCommentAndUploodToDatabase(commentText: String, postId: String, onSuccess: @escaping () -> Void, onError: @escaping (_ error: String?) -> Void) {
        
        // 1 Teil - Kommentar erstellen
        let commenRef = REF_COMMENTS
        let commentId = commenRef.childByAutoId().key
        
        let newCommentRef = commenRef.child(commentId)
        guard let currentUserUid = UserApi.shared.CURRENT_USER_UID else { return }
        
        let dic = ["uid" : currentUserUid, "commentText" : commentText] as [String: Any]
        newCommentRef.setValue(dic) { (_, _) in
            
            // 2 Teil - Kommentar mit dem Post verknüpfen
            self.REF_POST_COMMENTS.child(postId).child(commentId).setValue(true, withCompletionBlock: { (error, _) in
                if error != nil {
                    onError(error?.localizedDescription)
                }
                
                // hashtag stuff
                var textArray = commentText.components(separatedBy: CharacterSet.whitespaces)
                
                for var word in textArray {
                    if word.hasPrefix("#") && word.count > 1 {
                        word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                        let newHashtagRef = HashtagApi.shared.REF_HASHTAG.child(word.lowercased())
                        let dic = [postId : true]
                        newHashtagRef.updateChildValues(dic)
                    }
                }
                textArray.removeAll()
                
                // report stuff
                let postCommentRef = self.REF_POST_COMMENTS.child(postId).child(commentId)
                postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    PostApi.shared.observePost(withPostId: postId, completion: { (post) in
                        if post.uid! != UserApi.shared.CURRENT_USER_UID! {
                            let commentTime = Date().timeIntervalSince1970
                            let reportingId = ReportingApi.shared.REF_REPORTING.childByAutoId().key
                            let reportingRef = ReportingApi.shared.REF_REPORTING.child(post.uid!).child(reportingId)
                            reportingRef.setValue(["id" : reportingId, "fromUserUid": currentUserUid, "type" : "comment", "time": commentTime, "objectId" : postId])
                        }
                    })
                })
                
              
                onSuccess()
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
