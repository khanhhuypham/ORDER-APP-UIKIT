//
//  ReportBusinessGiftFoodViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/09/2023.
//

import UIKit
import Charts
import ObjectMapper
class ReportBusinessGiftFoodViewController: BaseViewController {
    
    
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
    
    
    @IBOutlet weak var barChart: BarChartView!

    

    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total_amount: UILabel!
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bindTableViewData()
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        Utils.changeBgBtn(btn: btn_this_month, btnArray: btnArray)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.giftedFoodReport.value.reportType{
                Utils.changeBgBtn(btn: btn, btnArray: btnArray)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportGiftedFood()
    }
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.giftedFoodReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.giftedFoodReport.accept(report)
        getReportGiftedFood()
    }
    

    private func getReportGiftedFood(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportGiftedFood().subscribe(onNext: {[self] (response) in
            dLog(response.data)
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.dateString = viewModel.giftedFoodReport.value.dateString
                    report.reportType = viewModel.giftedFoodReport.value.reportType
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.giftedFoodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    var viewModel: ReportBusinessViewModel?

}

extension ReportBusinessGiftFoodViewController{
   
    private func registerCell(){
        let tableViewCell = UINib(nibName: "ReportBusinessGiftFoodTableViewCell", bundle: .main)
        tableView.register(tableViewCell, forCellReuseIdentifier: "ReportBusinessGiftFoodTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func bindTableViewData() {
        guard let viewModel = self.viewModel else {return}
        
        viewModel.giftedFoodReport.subscribe(onNext: { [self] report in
            view_no_data.isHidden = report.total_amount > 0 ? true : false
            total_amount.text = report.total_amount.toString
            setupBarChart(data: report.foods, barChart: barChart)
        }).disposed(by: rxbag)
        
        viewModel.giftedFoodReport.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessGiftFoodTableViewCell", cellType: ReportBusinessGiftFoodTableViewCell.self))
        {(row, food, cell) in
            cell.data = food
            cell.lbl_number.text = String(row + 1)
        }.disposed(by: rxbag)
        
    }
    

    private func setupBarChart(data:[FoodReport],barChart:BarChartView){
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel:  data.enumerated().map{(i,value) in String(i + 1)}
        )
      
        barChart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
        
    }
    

}
