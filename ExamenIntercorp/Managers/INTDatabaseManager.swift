//
//  INTDatabaseManager.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
protocol INTDatabaseManagerProtocol {
    func saveUser(user: INTUser , success:@escaping (Bool?) -> Void , failure:@escaping (String?) -> Void)
    func clearDatabase()
}

class INTDatabaseManager: INTDatabaseManagerProtocol {
    
    func saveUser(user: INTUser , success:@escaping (Bool?) -> Void , failure:@escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            failure("Error al obtener el usuario")
            return
        }
        let dictionaryValues = ["name": user.name,
                                "email": user.email,
                                "lastname": user.lastName,
                                "birthday": user.fecNac]
        let values = [uid : dictionaryValues]
        
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                failure(err.localizedDescription)
                return
            }
            success(true)
        })
    }
    
    func clearDatabase() {
        
    }
    
    
}
