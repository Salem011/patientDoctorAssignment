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
    func listenForMyAppointments ()
    func updateReservationStatus(to newStatus: String)
    
    func getAppointmentsCount () -> Int
    func getTitleTextForAppointment(at index: Int) -> String
    func getDetailedTextForAppointment(at index: Int) -> String 
}


class AppointmentsViewModel: NSObject, AppointmentsViewModelInterface {

    var view: ReservationsViewInterface!
    let db = Firestore.firestore()

    let currentDoctorId = "AAN4qeFVS4IxGzCkkSq0"
    var appointments = [Appointment]()
    
    var createdReservationDocId = ""
    
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
    
    func listenForMyAppointments() {
        db.collection("reservations").whereField("doctorId", isEqualTo: currentDoctorId).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            snapshot.documentChanges.forEach({ (change) in
                if change.type == .added && change.document.data()["status"] as! String == "pending" {
                    self.createdReservationDocId = change.document.documentID
                    let docData = change.document.data()
                    var reservationDate :String?
                    if let date = docData["date"] as? Date {
                        reservationDate = dateFormatter.string(from: date)
                    }
                    self.view.displayNotificationAlert(with: "The patient: \(docData["patientId"] as? String ?? "N/A") requested an appointment at: \(reservationDate ?? "N/A")")
                }
            })
            
        }
    }
    
    func updateReservationStatus(to newStatus: String) {
        if createdReservationDocId == "" {
            return
        }
        db.collection("reservations").document(createdReservationDocId).setData(["status": newStatus], options: SetOptions.merge())
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
