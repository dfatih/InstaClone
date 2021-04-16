//
//  RegistrationViewController.swift
//  InstagramKloneApp
//
//  Created by Christian on 19.02.18.
//  Copyright © 2018 Codingenieur. All rights reserved.
//

import UIKit
import AMPopTip
import Keychain

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlet
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var containerView: UIStackView!
    
    @IBOutlet weak var haveAnAccountButton: UIButton!
    
    
    // MARK: - var / let
    var selectedImage: UIImage?
    let popTip = PopTip()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupPopTip()
        
        addTargetToTextField()
        
        addTapGestureToImageView()
    }
    
    
    // MARK: - Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
        for touch in touches {
            let touchLocation = touch.location(in: self.view)
            //            print(touchLocation)
            
            if !createAccountButton.frame.contains(touchLocation) && !createAccountButton.isEnabled {
                popTip.show(text: "Bitte Username, E-Mail und Passwort eintippen", direction: .down, maxWidth: 200, in: containerView, from: createAccountButton.frame, duration: 3)
            }
        }
    }

    
    // MARK: - Methoden
    func setupView() {
        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        profilImageView.layer.borderColor = UIColor.white.cgColor
        profilImageView.layer.borderWidth = 2
        
        usernameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        emailTextField.borderStyle = .roundedRect
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        createAccountButton.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.isEnabled = false
        
        let attributeText = NSMutableAttributedString(string: "Du hast einen Account?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white])
        
        attributeText.append(NSMutableAttributedString(string: " " + "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        haveAnAccountButton.setAttributedTitle(attributeText, for: UIControl.State.normal)
    }
    
    func addTargetToTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        emailTextField.addTarget(self, action: #selector(emailFieldDidEnter), for: UIControl.Event.editingDidBegin)
        passwordTextField.addTarget(self, action: #selector(passwordFieldDidEnter), for: UIControl.Event.editingDidBegin)
    }
    
    @objc func emailFieldDidEnter() {
        //        print("Email Eingabe")
        popTip.show(text: "Nur E-Mail mit @ gültig", direction: .up, maxWidth: 200, in: containerView, from: emailTextField.frame, duration: 3)
    }
    
    @objc func passwordFieldDidEnter() {
        //        print("Password Eingabe")
        popTip.show(text: "Nur Passwort mit min. 6 Zeichen gültig", direction: .up, maxWidth: 200, in: containerView, from: passwordTextField.frame, duration: 3)
    }
    
    @objc func textFieldDidChange() {
        let isText = usernameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isText {
            createAccountButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            createAccountButton.layer.cornerRadius = 5
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
            createAccountButton.layer.cornerRadius = 5
            createAccountButton.isEnabled = false
        }
    }
    
    
    // MARK: - Choose Photo
    func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilPhoto))
        profilImageView.addGestureRecognizer(tapGesture)
        profilImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfilPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.cropRect] as? UIImage {
            profilImageView.image = editImage
            selectedImage = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profilImageView.image = originalImage
            selectedImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action
    @IBAction func createButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        if selectedImage == nil {
            ProgressHUD.showError("Bitte Foto wählen!")
            return
        }
        
        // Passwort speichern
        let saveSucces: Bool = Keychain.save(self.passwordTextField.text!, forKey: "userInformation")
        
        if saveSucces == true {
            print("Passwort gespeichert")
        }
        
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        ProgressHUD.show("Lade...", interaction: false)
        AuthenticationService.createUser(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
            ProgressHUD.showSuccess("Profil wurde erstellt")
            self.performSegue(withIdentifier: "registerSegue", sender: nil)
        }) { (error) in
            ProgressHUD.showError("User konnte nicht erstellt werden")
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - PopTip Setup
    func setupPopTip() {
        popTip.shouldDismissOnTap = true
        popTip.actionAnimation = .bounce(10.0)
        popTip.isRounded = true
        popTip.offset = 2.0
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip.bubbleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        popTip.textColor = UIColor.white
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
