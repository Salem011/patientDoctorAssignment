//
//  CalendarViewController.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarDelegate: class {
    func didSelectDate (date: Date)
}

class CalendarViewController: UIViewController, FSCalendarDelegate {

    weak var delegate: CalendarDelegate?
    
    var selectedDate: Date?
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDate = date
        displayConfirmationAlert(for: formatter.string(from: date))
    }
    
    func displayConfirmationAlert (for date: String) {
        let alert = UIAlertController(title: "Confirm Reservation", message: "Are you sure you want to reserve an appointment at: \(date)?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {void in
            self.delegate?.didSelectDate(date: self.selectedDate!)
            self.navigationController?.popViewController(animated: true)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: {void in
            self.selectedDate = nil
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

}
