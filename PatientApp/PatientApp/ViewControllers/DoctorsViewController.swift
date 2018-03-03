//
//  DoctorsViewController.swift
//  PatientApp
//
//  Created by Salem Mohamed on 3/3/18.
//  Copyright © 2018 Salem Mohamed. All rights reserved.
//

import UIKit

private let reuseIdentifier = "doctorCell"

protocol DoctorsViewInterface {
    func doctorsAreLoaded ()
    func displayError(with message: String)
}

class DoctorsViewController: UICollectionViewController, DoctorsViewInterface {

    var viewModel: DoctorsViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let collectioViewLayout = UICollectionViewFlowLayout()
        collectioViewLayout.itemSize = CGSize(width: 140, height: 140)
        collectionView!.collectionViewLayout = collectioViewLayout
        
        self.title = "Find a Doctor"
        
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
        
        return cell
    }

    // MARK: - UICollectionViewDelegate

    // MARK: - DoctorsViewInterface
    func doctorsAreLoaded() {
        // TODO: hide loader
        self.collectionView!.reloadData()
    }
    
    func displayError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
