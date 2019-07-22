//
//  ProfileViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class ProfileViewController: BaseViewController, GIDSignInUIDelegate, UIGestureRecognizerDelegate {
    
    var viewModel: ProfileViewModel!
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    //MARK: - Profile views
    private lazy var profilePicture: UIImageView = {
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "profilePicture")
        imgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(test))
        tap.delegate = self
        imgView.addGestureRecognizer(tap)
        imgView.clipsToBounds = true
        return imgView
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign in to view your profile"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    private lazy var signInButton: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private lazy var signOutButton: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Sign Out", for: .normal)
        btn.addTarget(self, action: #selector(signOutUser), for: .touchUpInside)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        return btn
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        title = "Profile"
        setupConstraints()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserStatus()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.trackUserStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let authListener = viewModel.authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    //MARK: - View constraints
    func setupConstraints() {
        view.addSubview(profilePicture)
        view.addSubview(usernameLabel)
        view.addSubview(signInButton)
        view.addSubview(signOutButton)
        
        profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: view.bounds.size.width/2).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: view.bounds.size.width/2).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 5).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signInButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        signOutButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 5).isActive = true
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    //MARK: - Firebase/profile setup
    func checkUserStatus() {
        viewModel.onGotStatus = { [weak self] user in
            self?.signOutButton.isEnabled = true
            self?.signInButton.isEnabled = false
            self?.usernameLabel.text = user.displayName
//            guard let url = user.photoURL else { return }
//            guard let data = try? Data(contentsOf: url) else { return }
//            self?.profilePicture.image = UIImage(data: data)
            self?.viewModel.loadProfilePicture()

        }
        viewModel.onNoChanges = { [weak self] in
            self?.signOutButton.isEnabled = false
            self?.signInButton.isEnabled = true
        }
        viewModel.onSignedOut = { [weak self] in
            self?.usernameLabel.text = "Sign in to view your profile"
            self?.profilePicture.image = UIImage(named: "profilePicture")
            self?.showAlert(title: "Success!", message: "You signed out!")
        }
        viewModel.onErrorSignOut = { [weak self] error in
            self?.showAlert(title: "Oops!", message: "There was an error while signing out!")
            print(error)
        }
        viewModel.onGotPicture = { [weak self] picture in
            self?.profilePicture.image = picture
        }
    }
    @objc func test() {
        present(imagePicker, animated: true)
    }
    @objc func signOutUser() {
        viewModel.signOut()
    }
    //MARK: - Helper function (alerts)
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profilePicture.image = image
        viewModel.saveProfilePicture(image)
        dismiss(animated: true, completion: nil)
    }
}
