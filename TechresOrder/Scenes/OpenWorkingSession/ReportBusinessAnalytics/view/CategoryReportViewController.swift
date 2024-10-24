//
//  CategoryReportViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 25/02/2023.
//

import UIKit

class CategoryReportViewController: BaseViewController {
    
    var cate_id = 0
    
    @IBOutlet weak var no_data_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        no_data_view.isHidden = true
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFoodByCategory()
    }

    var viewModel: ReportBusinessAnalyticsViewModel? {
       didSet {
           bindViewModel()
       }
    }
    
    private func bindViewModel() {
       if let viewModel = viewModel {
           dLog(viewModel.cate_id.value)
           viewModel.is_goods.accept(ALL)
           viewModel.is_combo.accept(ALL)
           viewModel.is_gift.accept(ALL)
           viewModel.cate_id.accept(viewModel.cate_id.value)
           viewModel.report_type.subscribe( // Thực hiện subscribe Observable
             onNext: { [weak self] report_type in
                dLog(report_type)
                dLog(self?.cate_id)
//                     self?.viewModel?.is_goods.accept(report_type)
                 self?.getFoodByCategory()
             }).disposed(by: rxbag)
           
       }
    }
}
