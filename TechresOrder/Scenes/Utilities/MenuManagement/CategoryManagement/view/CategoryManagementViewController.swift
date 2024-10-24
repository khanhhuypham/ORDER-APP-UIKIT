//
//  CategoryManagementViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class CategoryManagementViewController: BaseViewController {
    var viewModel = CategoryManagementViewModel()
    var router = CategoryManagementRouter()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var no_data_view: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        no_data_view.isHidden = false
        registerCell()
        bindTableViewData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCategoriesManagement()
    }


    @IBAction func actionCreate(_ sender: Any) {
        self.presentModalCreateCategory()
    }
}
