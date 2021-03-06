//
//  Appointment.swift
//  DoctorApp
//
//  Created by Salem Mohamed on 3/4/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import Foundation

struct Reservation {
    
    var id: String
    var doctorId: String
    var patientId: String
    var status: String
    var date: String
    
    init?(id: String, dictionary: [String : Any]) {
        guard let doctorId = dictionary["doctorId"] as? String,
            let patientId = dictionary["patientId"] as? String,
            let status = dictionary["status"] as? String,
            let date = dictionary["date"] as? Date else {
                return nil
        }
        
        self.id = id
        self.doctorId = doctorId
        self.patientId = patientId
        self.status = status
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        self.date = formatter.string(from: date)
    }
    
    
    
    
}
