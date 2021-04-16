//
//  PostImageCollectionViewCell.swift
//  InstagramKloneApp
//
//  Created by Christian on 02.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import SDWebImage

class PostImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: PostModel? {
        didSet {
            guard let _post = post else { return }
            updateCellView(post: _post)
        }
    }
    
    func updateCellView(post: PostModel) {
        guard let url = URL(string: post.imageUrl!) else { return }
        
        postImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
    }
    
}
