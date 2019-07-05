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
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    lazy var signInWithFacebookButton: UIButton = {
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
        view.backgroundColor = .white
        navigationItem.title = "Intercorp"
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(signInWithFacebookButton)
        
        signInWithFacebookButton.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        signInWithFacebookButton.anchorCenterSuperview()
        
    }
}
