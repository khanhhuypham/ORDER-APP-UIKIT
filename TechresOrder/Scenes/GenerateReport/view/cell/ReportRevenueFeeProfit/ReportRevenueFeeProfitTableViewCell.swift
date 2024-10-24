//
//  ReportRevenueFeeProfitTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import Charts
import RxSwift
class ReportRevenueFeeProfitTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_revenue: UILabel!
    @IBOutlet weak var lbl_fee: UILabel!
    @IBOutlet weak var lbl_profit: UILabel!

    @IBOutlet weak var bar_chart: BarChartView!

    @IBOutlet weak var lbl_time: UILabel!
    
    @IBOutlet weak var icon_calendar: UIImageView!
    
    //    @IBOutlet weak var root_view_empty_data: UIView!
//    @IBOutlet weak var lbl_food_total_amount: UILabel!

    
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
    
    @IBOutlet weak var view_width_choose_time: NSLayoutConstraint!
    
    @IBOutlet weak var view_choose_time: UIView!
    var isChooseTime = false

    var btnArray:[UIButton] = []

    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_branch_name.text = ManageCacheObject.getCurrentUser().branch_name
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionShowCalendar(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        self.isChooseTime = true
        view_choose_time.backgroundColor = ColorUtils.orange_brand_900()
        view_width_choose_time.constant = 80
        lbl_time.textColor = ColorUtils.white()
        lbl_time.text = viewModel.revenueCostProfitReport.value.dateString
        icon_calendar.image = UIImage(named: "icon-calendar-white")
        
       
        viewModel.view?.showDateTimePicker(selectedDate: viewModel.revenueCostProfitReport.value.dateString)
        
        for button in self.btnArray{
            button.backgroundColor = ColorUtils.white()
            button.setTitleColor(ColorUtils.orange_brand_900(),for: .normal)
            
            let btnTxt = NSMutableAttributedString(string: button.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
            button.setAttributedTitle(btnTxt,for: .normal)
            button.borderWidth = 1
            button.borderColor = ColorUtils.orange_brand_900()
        }
        
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
   
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.revenueCostProfitReport.value
        report.revenueFeeProfitData = []
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.revenueCostProfitReport.accept(report)
        viewModel.view?.getRevenueCostProfitReport()
        
    }
    
    
    
    var viewModel: GenerateReportViewModel? {
           didSet {
         
               guard let viewModel = self.viewModel else {return}
               btnArray = [btn_today, btn_yesterday, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year] // btn_this_week -> choose time
    
             
               for btn in self.btnArray{
                   btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                       Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                   }).disposed(by: disposeBag)
                   
                   if btn.tag == viewModel.revenueCostProfitReport.value.reportType {
                       Utils.changeBgBtn(btn: btn, btnArray: btnArray)
                   }
               }
               
               viewModel.revenueCostProfitReport.subscribe(onNext: { [weak self] (report) in
//                   self?.btnTitleMonth.setTitle(month_of_revenue_fee_profit_report, for: .normal)
                   if(self!.isChooseTime){
                       self?.lbl_time.text = report.dateString
                   }else{
                       self?.lbl_time.text = "Chọn thời gian"
                       self?.view_width_choose_time.constant = 110
                       self?.icon_calendar.image = UIImage(named: "icon-calendar-orange")
                       self?.view_choose_time.backgroundColor = ColorUtils.white()
                       self?.lbl_time.textColor = ColorUtils.orange_brand_900()
                   }

                   self?.lbl_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue_amount)
                   self?.lbl_fee.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_cost_amount)
                   self?.lbl_profit.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_profit_amount)
                   self?.setupBarChart(data: report)
                   

               }).disposed(by: disposeBag)

           }
    }
    
    
}

extension ReportRevenueFeeProfitTableViewCell{

    func setupBarChart(data:RevenueFeeProfitReport){
        
    
        ChartUtils.customBarChart(
            chartView: bar_chart,
            barChartItems: [
                BarChartDataEntry(x: Double(0), y: Double(data.total_revenue_amount)),
                BarChartDataEntry(x: Double(1), y: Double(data.total_cost_amount)),
                BarChartDataEntry(x: Double(2), y: Double(data.total_profit_amount))
            ],
            color: [ColorUtils.green_600(),ColorUtils.red_400(),ColorUtils.orange_brand_900()],
            drawValuesOnDataSet: true
        )
        
    }



}

