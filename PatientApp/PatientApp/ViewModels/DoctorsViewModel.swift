//
//  DoctorsViewModel.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import UserNotifications

protocol DoctorsViewModelInterface {
    func loadDoctors ()
    
    func createAppointment(for drIndex: Int, at date: String)
    
    func getDoctorsCount () -> Int
    func getDoctorName(at index: Int) -> String
    func getImageUrl(at index: Int) -> URL?
}

class DoctorsViewModel: NSObject, DoctorsViewModelInterface {
    
    var view: DoctorsViewInterface!
    var doctors = [Doctor]()
    
    let patientId = "sk132GM6DJ56H7qICzqt"
    let db = Firestore.firestore()
    
    func loadDoctors() {
        
        Auth.auth().signIn(withEmail: "patient@app.com", password: "passowrd") { (user, error) in
            if let error = error {
                self.view.displayError(with: error.localizedDescription)
            }else {
                // user is logged in, load the data
                self.loadDoctorsDocument()
            }
        }
    }
    
    func loadDoctorsDocument () {
       
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
    
    func createAppointment(for drIndex: Int, at date: String) {
        let doctor = doctors[drIndex]
      
        db.collection("reservations").whereField("doctorId", isEqualTo: doctor.id).getDocuments { (snapshot, error) in
            var dateIsAVailable = true
            for reservation in snapshot!.documents {
                if let reservationDate = reservation.data()["date"] as? String, reservationDate == date {
                    dateIsAVailable = false
                    break
                }
            }
            if dateIsAVailable {
                // Create the reservation
                self.createReservationDocument(for: doctor.id, at: date)
                
                return
            }
            // date is not valid
            self.view.displayError(with: "The appointment is not available. Please select another date")
        }
        
    }
    
    func createReservationDocument (for doctorId: String, at date: String) {
        var reservation: DocumentReference? = nil
        reservation = db.collection("reservations").addDocument(data: ["doctorId": doctorId, "patientId": patientId, "date": date, "status": "pending"]) { (error) in
            
            if let error = error {
                self.view.displayError(with: error.localizedDescription)
                return
            }
            
            self.view.appointmentCreated()
            // Listen to the reservation status modification
            self.db.collection("reservations").document("\(reservation!.documentID)").addSnapshotListener({ (snapshot, error) in
                if let newStatus = snapshot?.data()?["status"] as? String, newStatus != "pending" {
                    self.notifyThePatient(status: newStatus)
                }
            })
        }
    }
    
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
    
    func getDoctorsCount() -> Int {
        return doctors.count
    }
    
    func getDoctorName(at index: Int) -> String {
        return doctors[index].name
    }
    
    func getImageUrl(at index: Int) -> URL? {
        guard let urlString = doctors[index].imageUrl else {
            return nil
        }
        return URL(string: urlString)
    }
 
}
