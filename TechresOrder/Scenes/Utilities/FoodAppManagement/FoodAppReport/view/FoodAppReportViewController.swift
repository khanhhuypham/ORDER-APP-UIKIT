//
//  FoodAppReportViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import Charts
class FoodAppReportViewController: BaseViewController {
    
    var viewModel = FoodAppReportViewModel()
    var router = FoodAppReportRouter()

    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_total_order: UILabel!
    @IBOutlet weak var stackViewOfBtn: UIStackView!
    
    @IBOutlet weak var btn_today: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCell()
   
        actionChooseReportType(btn_today)
     
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        var report = viewModel.report.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.report.accept(report)
        changeColorBtn(parentView: stackViewOfBtn,selectedBtn: sender)
        getRevenueSumaryReportOfFoodApp()
    }
    
  
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    private func changeColorBtn(parentView:UIView,selectedBtn:UIButton) {
        
        if parentView.subviews.count > 0{
            
            parentView.subviews.forEach{(view) in
                
                if let btn = view as? UIButton {
                   
                    if btn == selectedBtn{
                        btn.borderWidth = 0
                        btn.backgroundColor = ColorUtils.orange_brand_900()
                        btn.setTitleColor(ColorUtils.white(),for: .normal)
                        
                    }else{
                        btn.backgroundColor = ColorUtils.white()
                        btn.setTitleColor(ColorUtils.orange_brand_900(),for: .normal)
                        let btnTxt = NSMutableAttributedString(string: btn.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 12, weight: .semibold)])
                        btn.setAttributedTitle(btnTxt,for: .normal)
                        btn.borderWidth = 1
                        btn.borderColor = ColorUtils.orange_brand_900()
                    }
                }
            
                self.changeColorBtn(parentView:view,selectedBtn: selectedBtn)
            }
        }
    }
    
    
    

}
