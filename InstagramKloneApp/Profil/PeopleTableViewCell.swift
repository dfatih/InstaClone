//
//  PeopleTableViewCell.swift
//  InstagramKloneApp
//
//  Created by Christian on 05.03.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import SDWebImage

protocol PeopleCellDelegate {
    func didTappedShowUserInfo(userUid: String)
}


class PeopleTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followUnfollowButton: UIButton!
    
    var user: UserModel? {
        didSet {
            guard let _user = user else { return }
            updateView(user: _user)
        }
    }
    
    func updateView(user: UserModel) {
        nameLabel.text = user.username
        
        guard let url = URL(string: user.profilImageUrl!) else { return }
        profilImageView.sd_setImage(with: url) { (_, _, _, _) in
        }
        
        if user.isFollowing! == true {
            setupUnFollowButton()
        } else {
            setupFollowButton()
        }
    }
    
    
    // MARK: Follow / UnFollow
    func setupFollowButton() {
        followUnfollowButton.layer.borderWidth = 1
        followUnfollowButton.layer.borderColor = UIColor.lightGray.cgColor
        followUnfollowButton.layer.cornerRadius = 5
        followUnfollowButton.clipsToBounds = true
        
        followUnfollowButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        followUnfollowButton.backgroundColor = UIColor(red: 1 / 255, green: 84 / 255, blue: 147 / 255, alpha: 1.0)
        followUnfollowButton.setTitle("Follow", for: UIControl.State.normal)
        followUnfollowButton.addTarget(self, action: #selector(followAction), for: UIControl.Event.touchUpInside)
    }
    
    func setupUnFollowButton() {
        followUnfollowButton.layer.borderWidth = 1
        followUnfollowButton.layer.borderColor = UIColor.lightGray.cgColor
        followUnfollowButton.layer.cornerRadius = 5
        followUnfollowButton.clipsToBounds = true
        
        followUnfollowButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        followUnfollowButton.backgroundColor = UIColor.white
        followUnfollowButton.setTitle("Following", for: UIControl.State.normal)
        followUnfollowButton.addTarget(self, action: #selector(unFollowAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func followAction() {
        if user?.isFollowing == false {
            FollowApi.shared.followAction(withUser: user!.uid!) // Datenbank
            setupUnFollowButton() // View
            user?.isFollowing = true // Objekt
        }
    }
    
    @objc func unFollowAction() {
        if user?.isFollowing == true {
            FollowApi.shared.unFollowAction(withUser: user!.uid!) // Datenbank
            setupFollowButton() // View
            user?.isFollowing = false // Objekt
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()

        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        let tapGestureShowProfil = UITapGestureRecognizer(target: self, action: #selector(handleShowProfil))
        nameLabel.addGestureRecognizer(tapGestureShowProfil)
        nameLabel.isUserInteractionEnabled = true
    }
    
    // MARK: - Show User Information
    var delegate: PeopleCellDelegate?
    
    @objc func handleShowProfil() {
        print("UserUid: ", user?.uid)
        
        guard let userUid = user?.uid else { return }
        delegate?.didTappedShowUserInfo(userUid: userUid)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
