//
//  Doctor.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import Foundation

struct Doctor {
    
    var id: String
    var name: String
    var speciality: String
    var imageUrl: String?
    
    
    var dictionary:[String:Any] {
        return [
            "name": name,
            "speciality" : speciality,
            "imageUrl" : imageUrl ?? ""
        ]
    }
    
    init?(id: String, dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let speciality = dictionary["speciality"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.speciality = speciality
        self.imageUrl = dictionary ["imageUrl"] as? String
    }
    
    
    
    
}
