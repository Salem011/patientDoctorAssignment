//
//  AppointmentsRouter.swift
//  DoctorApp
//
//  Created by Salem Mohamed on 3/4/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit

class AppointmentsRouter {
    
    static func instantiateDoctorsViewController () -> UIViewController {
        
        let appointmentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppointmentsViewController") as! AppointmentsViewController
        
        let navigation = UINavigationController(rootViewController: appointmentsVC)
        return navigation
    }
    
}
