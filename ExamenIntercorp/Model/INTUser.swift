//
//  INTUser.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import Foundation

class INTUser {
    let name:String
    let email:String
    let lastName:String
    let age:String
    let fecNac:String
    
    init(dictionary: [String: Any] ) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.lastName = dictionary["lastname"] as? String ?? ""
        self.age = dictionary["age"] as? String ?? ""
        self.fecNac = dictionary["fecnac"] as? String ?? ""
    }
    
    init(name:String , lastname :String , email:String , fecNac:String , age:String) {
        self.name = name
        self.lastName = lastname
        self.email = email
        self.fecNac = fecNac
        self.age = age
    }
}
