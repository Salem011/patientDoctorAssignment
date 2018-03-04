//
//  AppointmentsViewModel.swift
//  DoctorApp
//
//  Created by Salem Mohamed on 3/4/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol AppointmentsViewModelInterface {
    func loadAppointments ()
    
    func getAppointmentsCount () -> Int
    func getTitleTextForAppointment(at index: Int) -> String
    func getDetailedTextForAppointment(at index: Int) -> String 
}


class AppointmentsViewModel: NSObject, AppointmentsViewModelInterface {

    var view: AppointmentsViewInterface!
    let db = Firestore.firestore()

    let currentDoctorId = "AAN4qeFVS4IxGzCkkSq0"
    var appointments = [Appointment]()
    
    func loadAppointments() {
        db.collection("reservations").whereField("doctorId", isEqualTo: currentDoctorId).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error retrieving reservations: \(error.localizedDescription)")
                self.view.displayError(with: error.localizedDescription)
                return
            }
            
            for document in snapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                if let appointment = Appointment(id: document.documentID, dictionary: document.data()) {
                    self.appointments.append(appointment)
                }
            }
            self.view.appointmentsAreLoaded()
        }
    }
    
    func getAppointmentsCount() -> Int {
        return appointments.count
    }
    
    func getTitleTextForAppointment(at index: Int) -> String {
        return "Appointment Status: \(appointments[index].status)"
    }
    
    func getDetailedTextForAppointment(at index: Int) -> String {
        let appointment = appointments[index]
        return "at: \(appointment.date), from patient: \(appointment.patientId)"
    }
    
}
