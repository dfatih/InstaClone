//
//  DiscoveryCollectionViewCell.swift
//  InstagramKloneApp
//
//  Created by Christian on 07.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import SDWebImage

class DiscoveryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            updateView(post: _post)
        }
    }
    
    func updateView(post: PostModel) {
        guard let url = URL(string: post.imageUrl!) else { return }
        
        postImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
}
