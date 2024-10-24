//
//  LinkStoreViewController.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class LinkStoreViewController: BaseViewController {

    var viewModel = LinkStoreViewModel()
    var router = LinkStoreRouter()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    var conversation_id: String = ""
    let refreshControl = UIRefreshControl()
    let spinner = UIActivityIndicatorView(style: .medium)
    var isLoadingMore:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        
        viewModel.object_id.accept(conversation_id)
        
        registerCell()
        bindTableViewData()
        
        getListMedia()
    }

}
