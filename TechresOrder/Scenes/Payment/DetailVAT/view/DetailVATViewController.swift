//
//  DetailVATViewController.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 19/03/2023.
//

import UIKit

class DetailVATViewController: BaseViewController {
    var viewModel = DetailVATViewModel()

    var order_id = 0
    @IBOutlet weak var lbl_total_vat: UILabel!
    @IBOutlet weak var root_view_vat: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.order_id.accept(order_id)
        viewModel.brand_id.accept(ManageCacheObject.getCurrentBranch().id)
        
        registerCell()
        bindTableViewData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getVATDetails()
    }

    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
