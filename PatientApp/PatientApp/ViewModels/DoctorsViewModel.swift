//
//  DoctorsViewModel.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import UserNotifications


protocol DoctorsViewModelInterface {
    
    func loadDoctors ()
    func createReservation(for drIndex: Int, at date: Date)
    
    func doctorsCount () -> Int
    func doctorName(at index: Int) -> String
    func doctorImageUrl(at index: Int) -> StorageReference
}

class DoctorsViewModel: NSObject, DoctorsViewModelInterface {
    
    var view: DoctorsViewInterface!
    var doctors = [Doctor]()
    
    let patientId = "sk132GM6DJ56H7qICzqt"
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    // MARK: - Doctors
    func loadDoctors() {
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
    
    // MARK: - Reservations
    func createReservation(for drIndex: Int, at date: Date) {
        let doctor = doctors[drIndex]
      
        db.collection("reservations").whereField("doctorId", isEqualTo: doctor.id).whereField("date", isEqualTo: date).getDocuments { (snapshot, error) in
            
            guard let reservations = snapshot?.documents else {
                self.view.displayError(with: error?.localizedDescription ?? "Error Retrieving data")
                return
            }
            
            if reservations.count > 0 {
                self.view.displayError(with: "The appointment's date is not available. Please select another date")
                return
            }
    
            self.createReservationDocument(for: doctor.id, at: date)
        }
    
    }
    
    func createReservationDocument (for doctorId: String, at date: Date) {
        var reservation: DocumentReference? = nil
        reservation = db.collection("reservations").addDocument(data: ["doctorId": doctorId, "patientId": patientId, "date": date, "status": "pending"]) { (error) in
            
            if let error = error {
                self.view.displayError(with: error.localizedDescription)
                return
            }
            
            self.view.reservationCreated()
            // Listen to the reservation status modification
            self.db.collection("reservations").document("\(reservation!.documentID)").addSnapshotListener({ (snapshot, error) in
                if let newStatus = snapshot?.data()?["status"] as? String, newStatus != "pending" {
                    self.notifyThePatient(status: newStatus)
                }
            })
        }
    }
    
    // MARK: - UserNotifications
    func notifyThePatient (status: String) {
        let content = UNMutableNotificationContent()
        content.title = "Reservation Update"
        content.body = "Your reservation is \(status)."
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "ReservationStatusChanged", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Posting notification failed: \(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - View Helping Functions
    func doctorsCount() -> Int {
        return doctors.count
    }
    
    func doctorName(at index: Int) -> String {
        return doctors[index].name
    }
    
    func doctorImageUrl(at index: Int) -> StorageReference {
        let storageRef = storage.reference()
        return storageRef.child("\(doctors[index].imageUrl)")
    }
 
}
