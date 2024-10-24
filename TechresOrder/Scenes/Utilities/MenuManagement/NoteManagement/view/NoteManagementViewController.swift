//
//  NoteManagementViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit


class NoteManagementViewController: BaseViewController {

    var viewModel = NoteManagementViewModel()
    var router = NoteManagementRouter()
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
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.status.accept(ACTIVE)
        getNotes()
    }

    @IBAction func actionCreate(_ sender: Any) {
        self.presentModalCreateNote()
    }
   

}
