//
//  AppointmentsViewController.swift
//  DoctorApp
//
//  Created by Salem Mohamed on 3/4/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ReservationsViewInterface {
    func appointmentsAreLoaded ()
    func displayError(with message: String)
    
    func displayNotificationAlert (with message: String)
}

class ReservationsViewController: UITableViewController, ReservationsViewInterface {

    var viewModel: AppointmentsViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "subtitleCell")
        tableView.tableFooterView = UIView()

        self.title = "Appointments"
        
        MBProgressHUD.showAdded(to: view, animated: true)
        viewModel.loadAppointments()
        viewModel.listenForMyAppointments()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAppointmentsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
       
        cell.textLabel?.text = viewModel.getTitleTextForAppointment(at: indexPath.row)
        cell.detailTextLabel?.text = viewModel.getDetailedTextForAppointment(at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    // MARK: - View Interface Delegate
    func appointmentsAreLoaded() {
        MBProgressHUD.hide(for: view, animated: true)
        self.tableView.reloadData()
    }
    
    func displayError(with message: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayNotificationAlert(with message: String) {
        let alert = UIAlertController(title: "Appointment Request",message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: {void in
            self.viewModel.updateReservationStatus(to: "accepted")
        }))
        alert.addAction(UIAlertAction(title: "Reject", style: .default, handler: {void in
            self.viewModel.updateReservationStatus(to: "rejected")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
