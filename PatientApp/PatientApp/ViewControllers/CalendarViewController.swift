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
    func didSelectDate (date: String)
}

class CalendarViewController: UIViewController, FSCalendarDelegate {

    weak var delegate: CalendarDelegate?
    
    var formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "dd-MM-yyyy"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - FSCalendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let result = Calendar.current.compare(date, to: Date(), toGranularity: .day)
        if monthPosition == .previous || result == .orderedAscending {
            displayErrorAlert()
            return
        }
        displayConfirmationAlert(for: formatter.string(from: date))
    }
    
    // MARK: - Helping Functions
    func displayConfirmationAlert (for date: String) {
        let alert = UIAlertController(title: "Confirm Reservation", message: "Are you sure you want to reserve an appointment at: \(date)?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {void in
            self.delegate?.didSelectDate(date: date)
            self.navigationController?.popViewController(animated: true)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }

    func displayErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "You can only select today's date and above.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
