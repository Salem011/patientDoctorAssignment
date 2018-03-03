//
//  DoctorsRouter.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit

class DoctorsRouter {
    
    static func instantiateDoctorsViewController () -> UIViewController {
        
        let doctorsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
        
        let doctorsViewModel = DoctorsViewModel()
        doctorsViewModel.view = doctorsVC
        doctorsVC.viewModel = doctorsViewModel
        
        let doctorsNavigation = UINavigationController(rootViewController: doctorsVC)
        return doctorsNavigation
    }
    
    static func instantiateCalendarViewController () -> UIViewController {
        let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        return calendarVC
    }
    
}

