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
    
}

class DoctorsViewController: UICollectionViewController, DoctorsViewInterface {

    var viewModel: DoctorsViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let collectioViewLayout = UICollectionViewFlowLayout()
        collectioViewLayout.itemSize = CGSize(width: 140, height: 140)
        collectionView!.collectionViewLayout = collectioViewLayout
        
//        self.collectionView!.register(DoctorViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        return 500
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoctorViewCell
    
        // Configure the cell
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    // MARK: - DoctorsViewInterface

}
