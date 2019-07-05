//
//  INTConnectionManager.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import UIKit
import FacebookCore
import FirebaseAuth
import FirebaseCore
import SwiftyJSON

protocol INTConnectionManagerProtocol {
    func getUserFacebook(success: @escaping (String?, String?) -> Void, failure: @escaping (String?) -> Void)
    func signInFacebook(success: @escaping (Bool?) -> Void, failure : @escaping (String?) -> Void)
}

class INTConnectionManager: INTConnectionManagerProtocol {
    
    func signInFacebook(success: @escaping (Bool?) -> Void, failure: @escaping (String?) -> Void) {
       
        guard let authenticationToken = AccessToken.current?.authenticationToken else { failure("error"); return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (result, err) in
            if let err = err {
                failure("Error en el registro : \(err)")
                return
            }
            success(true)
        }
    }
    
    func getUserFacebook(success: @escaping (String?, String?) -> Void, failure: @escaping (String?) -> Void) {
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequestConnection.add(graphRequest, completion: { (httpResponse, result) in
            switch result {
            case .success(response: let response):
                guard let responseDict = response.dictionaryValue else {
                    failure("error al obtener datos")
                    return }
                
                let json = JSON(responseDict)
                let name = json["name"].string
                let email = json["email"].string
                success(name,email)
                break
            case .failed(let err):
                failure("error al obtener datos de usuario :\(err)")
                break
            }
        })
        graphRequestConnection.start()
    }
}
