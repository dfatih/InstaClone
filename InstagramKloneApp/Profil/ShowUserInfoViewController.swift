//
//  ShowUserInfoViewController.swift
//  InstagramKloneApp
//
//  Created by Christian on 11.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit

class ShowUserInfoViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - var / let
    var user: UserModel?
    var userUid = ""
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
        loadMyPosts()
        
        print(userUid)
    }
    
    // MARK: - Fetch current user
    func fetchUser() {
        UserApi.shared.observeUser(uid: userUid, completion: { (user) in
            self.isFollwing(userUid: user.uid!, completion: { (value) in
                user.isFollowing = value
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            })
            
        })
    }
    
    func isFollwing(userUid: String, completion: @escaping(Bool) -> Void) {
        FollowApi.shared.isFollowing(withUser: userUid, completed: completion)
    }
    
    
    // MARK: - load myPosts
    func loadMyPosts() {
        PostApi.shared.observeMyPosts(withUid: userUid) { (postId) in
            PostApi.shared.observePost(withPostId: postId, completion: { (post) in
                self.posts.insert(post, at: 0)
                self.collectionView.reloadData()
            })
        }
    }

  
}

// MARK: - CollectionView Datasocurce
extension ShowUserInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfilHeaderCollectionViewCell", for: indexPath) as! ProfilHeaderCollectionViewCell
        
        if let user = self.user {
            cell.user = user
        }
        
        return cell
    }
}

// MARK: - CollectionView FlowLayout
extension ShowUserInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 3 - 1
        let size = CGSize(width: width, height: width)
        return size
    }
}

