//
//  DoctorsViewModel.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import Foundation
import Firebase


protocol DoctorsViewModelInterface {
    func loadDoctors ()
}

class DoctorsViewModel: NSObject, DoctorsViewModelInterface {
    
    var view: DoctorsViewInterface!
    var doctors = [Doctor]()
    
    func loadDoctors() {
        let db = Firestore.firestore()
        
        db.collection("doctors").getDocuments { (snapshot, error) in
            if let error = error {
                // TODO: display error message to the user
                print("Error retrieving doctors: \(error)")
            }else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let doctor = Doctor(id: document.documentID, dictionary: document.data()) {
                        self.doctors.append(doctor)
                    }
                }
                // TODO: call view and reload content
            }
        }
        
    }
    
}
