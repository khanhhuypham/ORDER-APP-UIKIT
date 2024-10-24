//
//  FeeRebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/01/2024.
//

import UIKit

class FeeRebuildViewController: BaseViewController {
    
    var viewModel = FeeRebuildViewModel()
    var router = FeeRebuildRouter()
    var btnArray:[UIButton] = []
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
    
    @IBOutlet weak var lbl_total_fee: UILabel!
    @IBOutlet weak var lbl_material_fee_sm:UILabel!
    @IBOutlet weak var lbl_other_fee_sm:UILabel!
    
    @IBOutlet weak var lbl_material_fee_lg:UILabel!
    @IBOutlet weak var materialFeeTable: UITableView!
    @IBOutlet weak var height_of_material_fee_table: NSLayoutConstraint!
    @IBOutlet weak var view_no_data_of_material_fee: UIView!
    
    
    @IBOutlet weak var lbl_other_fee_lg: UILabel!
    @IBOutlet weak var otherFeeTable: UITableView!
    @IBOutlet weak var height_of_other_fee_table: NSLayoutConstraint!
    @IBOutlet weak var view_no_data_of_other_fee: UIView!
    
   
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
    
        registerCell()
        bindTableSection()
        
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel.feeReport.value.reportType {
                Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionChooseReportType(btn_today)
    }
    
    
    @IBAction func actionCreate(_ sender: Any) {
        viewModel.makeToCreateFeeViewController()
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        var report = viewModel.feeReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.feeReport.accept(report)
        fees()
    }
    
}
