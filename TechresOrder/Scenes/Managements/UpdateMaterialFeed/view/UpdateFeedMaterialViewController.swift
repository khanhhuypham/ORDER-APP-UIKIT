//
//  UpdateFeedViewController.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 16/06/2023.
//

import UIKit

class UpdateFeedMaterialViewController: BaseViewController {

    var viewModel = UpdateFeedMaterialViewModel()
    var router = UpdateFeedMaterialRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    @IBAction func actionSave(_ sender: Any) {
    }
  
}
