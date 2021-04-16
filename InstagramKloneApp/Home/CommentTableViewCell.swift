//
//  CommentTableViewCell.swift
//  InstagramKloneApp
//
//  Created by Christian on 24.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import SDWebImage
import KILabel

protocol CommentTableViewCellDelegate {
    func didTapNameLabel(userUid: String)
    func didTapCommentTextLabel(hashtag: String)
}

class CommentTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var commentTextLabel: KILabel!
    
    
    // MARK: Setup View
    var comment: CommentModel?
    
    var user: UserModel? {
        didSet {
            
            guard let _commentText = comment?.commentText else { return }
            guard let _username = user?.username else { return }
            guard let _profilImageUrl = user?.profilImageUrl else { return }
            setupViewCell(commentText: _commentText, username: _username, profilImageUrl: _profilImageUrl)
        }
    }
    
    func setupViewCell(commentText: String, username: String, profilImageUrl: String) {
        let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n" + commentText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]))
        commentTextLabel.attributedText = attributedText
        
        commentTextLabel.hashtagLinkTapHandler = { (label, string, range) in
            print(string)
            let newString = string.trimmingCharacters(in: CharacterSet.punctuationCharacters)
            print(newString)
            self.delegate?.didTapCommentTextLabel(hashtag: newString)
        }
        
        guard let imageUrl = URL(string: profilImageUrl) else { return }
        profilImageView.sd_setImage(with: imageUrl) { (_, _, _, _) in
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        commentTextLabel.text = ""
        
       addTapGestureToImageView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profilImageView.image = UIImage(named: "playeholder image")
    }
    
    
    // MARK: - Navigation to ShowUserInfoVC
    var delegate: CommentTableViewCellDelegate?
    
    func addTapGestureToImageView() {
        let tapGestureShowUserInfo = UITapGestureRecognizer(target: self, action: #selector(handleShowUserInfo))
        profilImageView.addGestureRecognizer(tapGestureShowUserInfo)
        profilImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleShowUserInfo() {
        guard let userUid = user?.uid else { return }
        delegate?.didTapNameLabel(userUid: userUid)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
