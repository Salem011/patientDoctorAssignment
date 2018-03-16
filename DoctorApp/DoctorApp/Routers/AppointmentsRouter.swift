//
//  AppointmentsRouter.swift
//  DoctorApp
//
//  Created by Salem Mohamed on 3/4/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit

class AppointmentsRouter {
    
    static func instantiateAppointmentsViewController () -> UIViewController {
        
        let appointmentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationsViewController") as! ReservationsViewController
        
        let viewModel = AppointmentsViewModel()
        appointmentsVC.viewModel = viewModel
        viewModel.view = appointmentsVC
        
        let navigation = UINavigationController(rootViewController: appointmentsVC)
        return navigation
    }
    
}
