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
        
        let doctorsNavigation = UINavigationController(rootViewController: doctorsVC)
        return doctorsNavigation
    }
    
}

