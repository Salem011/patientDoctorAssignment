//
//  DoctorsViewController.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage


private let reuseIdentifier = "doctorCell"

protocol DoctorsViewInterface {
    func doctorsAreLoaded ()
    func displayError(with message: String)
}

class DoctorsViewController: UICollectionViewController, DoctorsViewInterface, CalendarDelegate {

    var viewModel: DoctorsViewModelInterface!
    var currentSelectedDrIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let collectioViewLayout = UICollectionViewFlowLayout()
        collectioViewLayout.itemSize = CGSize(width: 140, height: 140)
        collectionView!.collectionViewLayout = collectioViewLayout
        
        self.title = "Find a Doctor"
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.loadDoctors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    // MARK: - UICollectionViewDataSource

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDoctorsCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoctorViewCell
    
        cell.doctorNameLabel.text = viewModel.getDoctorName(at: indexPath.row)
        cell.doctorImageView.sd_setImage(with: viewModel.getImageUrl(at: indexPath.row), completed: nil)
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedDrIndex = indexPath.row
        let calendarVC = DoctorsRouter.instantiateCalendarViewController() as! CalendarViewController
        calendarVC.delegate = self
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    // MARK: - Calendar Delegate
    func didSelectDate(date: Date) {
        // TODO: create the appointment!
        print("Selected Date for appointment: \(date)")
    }
    
    // MARK: - DoctorsViewInterface
    func doctorsAreLoaded() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.collectionView!.reloadData()
    }
    
    func displayError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
