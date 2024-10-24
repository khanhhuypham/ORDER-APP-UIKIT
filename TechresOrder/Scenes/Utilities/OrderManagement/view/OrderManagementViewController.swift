//
//  OrderManagementViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift

class OrderManagementViewController: BaseViewController {
    var viewModel = OrderManagementViewModel()
    var router = OrderManagementRouter()
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var lbl_nodata_order: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var view_nodata_order: UIView!


    
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    
    
    @IBOutlet weak var temp_revenue: UILabel!
    @IBOutlet weak var total_order_number: UILabel!
    
    
    @IBOutlet weak var text_field_search: UITextField!
    
    
    var btnShowMore = UIButton()
    let refreshControl = UIRefreshControl()
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        registerCell()
        bindTableViewData()
       
        
        // search call API
        text_field_search.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(text_field_search.rx.text)
            .subscribe (onNext:{ [self] query in
                var apiParameter = viewModel.APIParameter.value
                apiParameter.key_search = query ?? ""
                viewModel.APIParameter.accept(apiParameter)
                viewModel.clearDataAndCallAPI()
        }).disposed (by: rxbag)
        
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        
        Utils.changeBgBtn(btn: btn_today, btnArray: btnArray)
        
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self!.btnArray)
            }).disposed(by: rxbag)
        }
        
 
    
    }
    
      
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.clearDataAndCallAPI()
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.viewModel.makePopViewController()
    }
        
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        var apiParameter = viewModel.APIParameter.value
        apiParameter.report_type = sender.tag
        viewModel.APIParameter.accept(apiParameter)
        viewModel.clearDataAndCallAPI()
     
    }
    

    
}
