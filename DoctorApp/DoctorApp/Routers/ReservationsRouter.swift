//
//  AppointmentsRouter.swift
//  DoctorApp
//
//  Created by Salem Mohamed on 3/4/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit

class ReservationsRouter {
    
    static func instantiateReservationsViewController () -> UIViewController {
        
        let reservationsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationsViewController") as! ReservationsViewController
        
        let viewModel = ReservationsViewModel()
        reservationsVC.viewModel = viewModel
        viewModel.view = reservationsVC
        
        let navigation = UINavigationController(rootViewController: reservationsVC)
        return navigation
    }
    
}
