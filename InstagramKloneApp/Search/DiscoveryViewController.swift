//
//  DiscoveryViewController.swift
//  InstagramKloneApp
//
//  Created by Christian on 20.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: var / let
    var posts = [PostModel]()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadTopPosts()
        
    }
    
    
    // MARK: - Load top posts
    func loadTopPosts() {
        ProgressHUD.show("Lade...", interaction: false)
        self.posts.removeAll()
        self.collectionView.reloadData()
        PostApi.shared.observeTopPost { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadTopPosts()
    }
    
}

// MARK: - CollectionView Datasocure
extension DiscoveryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoveryCollectionViewCell", for: indexPath) as! DiscoveryCollectionViewCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
}

// MARK: - CollectionView Flowlayout
extension DiscoveryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 4 - 1
        let size: CGSize = CGSize(width: width, height: width)
        return size
    }
}




















