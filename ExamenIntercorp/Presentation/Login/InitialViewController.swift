//
//  InitialViewController.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import UIKit
import JGProgressHUD
import FacebookCore
import FacebookLogin


class InitialViewController: UIViewController {
    
    var name: String? = ""
    var username: String? = ""
    var email: String? = ""
    
    
    let imageBackground : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    let imageLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "intercorp_logo")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    let signInWithFacebookButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Inicia sesion con facebook", for: .normal)
        button.titleLabel?.font = UIFont.boldINTFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.INTblue()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setImage(#imageLiteral(resourceName: "FacebookButton").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleSignInWithFacebookButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let labelOr:UILabel = {
       let label = UILabel()
        label.text = "Or"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.regularINTFont(ofSize: 18)
        return label
    }()
    
    let txtEmail : INTTextField = {
      let textfield = INTTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Email"
      return textfield
    }()
    
    let txtPassword : INTTextField = {
        let textfield = INTTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Password"
        textfield.keyboardType = UIKeyboardType.default
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    let buttonEmail : INTButton = {
       let button = INTButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ingresar con email", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
       return button
    }()
    
    
    @objc func handleSignInWithFacebookButtonTapped() {
        hud.textLabel.text = "Iniciando sesion con Facebook.."
        hud.show(in: view, animated: true)
        hud.interactionType = .blockAllTouches
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.signIntoFirebase()
                
            case .failed(let err):
                INTProgress.dismissHud(self.hud, text: "Error", detailText: "No se pudo iniciar sesión: \(err)", delay: 3)
                break

            case .cancelled:
                INTProgress.dismissHud(self.hud, text: "Error", detailText: "Se canceló el inicio de sesión", delay: 3)
                break

            }
        }
    }
    
    fileprivate func signIntoFirebase() {
        INTConnectionManager().signInFacebook(success: { (isSuccess) in
            if isSuccess! {
                print("Succesfully authenticated with Firebase.")
                self.fetchFacebookUser()
                return
            }
        }) { (message) in
             INTProgress.dismissHud(self.hud, text: "Error en el Registro", detailText: message!, delay: 3)
        }
    }
    
    fileprivate func fetchFacebookUser() {
        INTConnectionManager().getUserFacebook(success: { (name, email) in
            self.name = name!
            self.email = email!
            INTProgress.dismissHud(self.hud, text: "", detailText: "Obteniendo datos...", delay: 3)
            self.saveUserIntoFirebaseDatabase()
        }) { (messagge) in
            INTProgress.dismissHud(self.hud, text: "Error", detailText: messagge!, delay: 3)
        }
    }
    
    fileprivate func saveUserIntoFirebaseDatabase() {
        self.hud.dismiss()
        let createUserVC = CreateUserViewController()
        createUserVC.name = self.name
        createUserVC.email = self.email
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        navigationItem.title = "Intercorp"
        
        
        //add views to view parent
        view.addSubview(self.imageBackground)
        view.addSubview(imageLogo)
        view.addSubview(signInWithFacebookButton)
        view.addSubview(labelOr)
        view.addSubview(buttonEmail)
        view.addSubview(txtPassword)
        view.addSubview(txtEmail)

        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupLayout() {
        //view.addSubview(signInWithFacebookButton)
        
        //constraints
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant:0)
        
      
        
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        imageLogo.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageLogo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        // btnFacebook
        signInWithFacebookButton.translatesAutoresizingMaskIntoConstraints = false
        signInWithFacebookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        signInWithFacebookButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        signInWithFacebookButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        signInWithFacebookButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //label Or
        labelOr.translatesAutoresizingMaskIntoConstraints = false
        labelOr.bottomAnchor.constraint(equalTo: signInWithFacebookButton.topAnchor, constant: -20).isActive = true
        labelOr.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelOr.heightAnchor.constraint(equalToConstant: 40).isActive = true
        labelOr.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //btnEmail
        buttonEmail.translatesAutoresizingMaskIntoConstraints = false
        buttonEmail.bottomAnchor.constraint(equalTo: labelOr.topAnchor, constant: -30).isActive = true
        buttonEmail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        buttonEmail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        buttonEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true

        //btnPassword
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        txtPassword.bottomAnchor.constraint(equalTo: buttonEmail.topAnchor, constant: -20).isActive = true
        txtPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        txtPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        txtPassword.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //txtEmail
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        txtEmail.bottomAnchor.constraint(equalTo: txtPassword.topAnchor, constant: -20).isActive = true
        txtEmail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        txtEmail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        txtEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}
