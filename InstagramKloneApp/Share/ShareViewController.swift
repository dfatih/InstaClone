//
//  ShareViewController.swift
//  InstagramKloneApp
//
//  Created by Christian on 20.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import AVFoundation

class ShareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    
    
    // MARK: - var / let
    var selectedImage: UIImage?
    var videoUrl: URL?
    
    
    // MARK: - View Lifycylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Share"

        addTapGestureToImageView()
        handleShareAndAbortButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageDidChange()
    }
    
    
    // MARK: View stuff
    func handleShareAndAbortButton() {
        shareButton.isEnabled = false
        abortButton.isEnabled = false
        
        let attributeShareButtonText = NSAttributedString(string: shareButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)])
        let attributeAbortButtonText = NSAttributedString(string: abortButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)])
        
        shareButton.setAttributedTitle(attributeShareButtonText, for: UIControl.State.normal)
        abortButton.setAttributedTitle(attributeAbortButtonText, for: UIControl.State.normal)
    }
    
    func imageDidChange() {
        let isImage = selectedImage != nil
        
        if isImage {
            shareButton.isEnabled = true
            abortButton.isEnabled = true
            
            let attributeShareButtonText = NSAttributedString(string: shareButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
            let attributeAbortButtonText = NSAttributedString(string: abortButton.currentTitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)])
            
            shareButton.setAttributedTitle(attributeShareButtonText, for: UIControl.State.normal)
            abortButton.setAttributedTitle(attributeAbortButtonText, for: UIControl.State.normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    // MARK: Choose post photo
    func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present(pickerController, animated: true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.cropRect] as? UIImage {
            postImageView.image = editImage
            selectedImage = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            postImageView.image = originalImage
            selectedImage = originalImage
        } else if let videoUrl = info[.mediaURL] as? URL {
            if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: videoUrl) {
                self.videoUrl = videoUrl
                self.postImageView.image = thumbnailImage
                self.selectedImage = thumbnailImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenrerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let time = CMTime.init(value: 9, timescale: 3)
            let thumbnailImage = try imageGenrerator.copyCGImage(at: time, actualTime: nil)
            
            return UIImage(cgImage: thumbnailImage)
        } catch let err {
            print("Fehler: ", err)
        }
        return nil
    }
    
    
    // MARK: Post
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        ProgressHUD.show("Lade...", interaction: false)
        
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let imageRatio = image.size.width / image.size.height
        
        ShareService.uploadDataToStorage(imageData: imageData, videoUrl: videoUrl, postText: postTextView.text, imageRatio: imageRatio) {
            self.remove()
            self.handleShareAndAbortButton()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        remove()
        handleShareAndAbortButton()
    }
    
    func remove() {
        selectedImage = nil
        postTextView.text = ""
        postImageView.image = UIImage(named: "placeholder")
        videoUrl = nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
