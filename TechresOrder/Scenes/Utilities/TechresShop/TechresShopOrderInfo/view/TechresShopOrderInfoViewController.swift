//
//  TechresShopOrderInfoViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopOrderInfoViewController: BaseViewController {
    var popViewController:(() -> Void) = {}
    
    var viewModel = TechresShopOrderInfoViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCell()
        getTechresShopOrder()
    }


}
