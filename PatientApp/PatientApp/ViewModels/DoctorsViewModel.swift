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
    
    func getDoctorsCount () -> Int
    func getDoctorName(at index: Int) -> String
    func getImageUrl(at index: Int) -> String
}

class DoctorsViewModel: NSObject, DoctorsViewModelInterface {
    
    var view: DoctorsViewInterface!
    var doctors = [Doctor]()
    
    func loadDoctors() {
        let db = Firestore.firestore()
        
        db.collection("doctors").getDocuments { (snapshot, error) in
            if let error = error {
                self.view.displayError(with: error.localizedDescription)
                print("Error retrieving doctors: \(error)")
            }else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let doctor = Doctor(id: document.documentID, dictionary: document.data()) {
                        self.doctors.append(doctor)
                    }
                }
                self.view.doctorsAreLoaded()
            }
        }
    }
    
    // MARK: - ViewModelInterface
    func getDoctorsCount() -> Int {
        return doctors.count
    }
    
    func getDoctorName(at index: Int) -> String {
        return doctors[index].name
    }
    
    func getImageUrl(at index: Int) -> String {
        return doctors[index].imageUrl ?? ""
    }
    
    
}
