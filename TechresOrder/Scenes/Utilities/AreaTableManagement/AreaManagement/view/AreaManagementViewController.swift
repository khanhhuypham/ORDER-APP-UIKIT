//
//  ManagementAreaViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation


class AreaManagementViewController: BaseViewController {
    var viewModel = AreaManagementViewModel()


    var behavior: MSCollectionViewPeekingBehavior!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
        
        registerAreaCell()
        binđDataCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAreas()
    }
  
    @IBAction func actionCreate(_ sender: Any) {
        self.presentModalCreateAreaViewController()
    }
    
    
}
