//
//  OrderManagementOfFoodAppViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit

class OrderManagementOfFoodAppViewController: BaseViewController {
    var viewModel = OrderManagementOfFoodAppViewModel()
    var router = OrderManagementOfFoodAppRouter()
    let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var lbl_total_revenue: UILabel!
    @IBOutlet weak var lbl_GRF_total_revenue: UILabel!
    @IBOutlet weak var lbl_SHF_total_revenue: UILabel!
    @IBOutlet weak var lbl_GOF_total_revenue: UILabel!
    @IBOutlet weak var lbl_BEF_total_revenue: UILabel!
    
    @IBOutlet weak var btn_reportType_filter: UIButton!
    @IBOutlet weak var btn_partner_filter: UIButton!
    
    @IBOutlet weak var lbl_total_complete: UILabel!

    @IBOutlet weak var lbl_total_cancel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var view_no_data: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        bindTableViewAndRegisterCell()
        getOrderHistoryOfFoodApp()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionShowReportTypeFilter(_ sender: UIButton) {
        viewModel.filterType.accept(1)
        showDropDown(btn: sender, list: viewModel.reportTypeFilter.value.map{$0.value})
    }
    
    @IBAction func actionShowParterFilter(_ sender: UIButton) {
        viewModel.filterType.accept(2)
        showDropDown(btn: sender, list: viewModel.partnerFilter.value.map{$0.key})
    }
    
    


}
