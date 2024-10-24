//
//  InformationApplicationViewController.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 04/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxCocoa

class InformationApplicationViewController: BaseViewController {

    var viewModel = InformationApplicationViewModel()
    var router = InformationApplicationRouter()
    
    @IBOutlet weak var tableView: UITableView!
    
    var page: Int = 1
    var lastPage: Bool = false
    let spinner = UIActivityIndicatorView(style: .medium)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        viewModel.os_name.accept(Utils.getOSName())
        var newData = viewModel.dataArray.value
        newData.append(ResponseInfoApp()!)
        viewModel.dataArray.accept(newData)
        
        registerCell()
        bindTableViewData()
        
        getInforApp()
        
    }

    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
}
