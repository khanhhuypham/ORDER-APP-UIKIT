//
//  ReportBusinessCategoryViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import ObjectMapper
import Charts
import RxSwift
import RxRelay
import RxCocoa
class ReportBusinessCategoryViewController: BaseViewController {
    
    
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
    
    
    

    @IBOutlet weak var pieChartCategory: PieChartView!
    @IBOutlet weak var barChartCategory: BarChartView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_total_revenue: UILabel!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var No_data_view: UIView!
    
    
    var btnArray:[UIButton] = []
    var colors = [UIColor]()
    var totalAmount = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        No_data_view.isHidden = true
        // Do any additional setup after loading the view.

        registerCell()
        bindTableView()
        
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        changeBgBtn(btn: btn_this_month)
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                self?.changeBgBtn(btn: btn)
            }).disposed(by: rxbag)
            
            if btn.tag == viewModel?.categoryReport.value.reportType{
                changeBgBtn(btn: btn)
            }
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reportRevenueByCategory()
    }
    
    
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.categoryReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.categoryReport.accept(report)
        reportRevenueByCategory()
    }
    
    func changeBgBtn(btn:UIButton){
        for button in self.btnArray{
            button.backgroundColor = ColorUtils.white()
            button.setTitleColor(ColorUtils.orange_brand_900(),for: .normal)
            
            let btnTxt = NSMutableAttributedString(string: button.titleLabel?.text ?? "",attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
            button.setAttributedTitle(btnTxt,for: .normal)
            button.borderWidth = 1
            button.borderColor = ColorUtils.orange_brand_900()
        }
        btn.borderWidth = 0
        btn.backgroundColor = ColorUtils.orange_brand_900()
        btn.setTitleColor(ColorUtils.white(),for: .normal)
    }
        
    var viewModel: ReportBusinessViewModel?

    //MARK: Register Cells as you want
    private func registerCell(){
        let itemCategoryTableViewCell = UINib(nibName: "ItemCategoryTableViewCell", bundle: .main)
        tableView.register(itemCategoryTableViewCell, forCellReuseIdentifier: "ItemCategoryTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    }
    
    
    func bindTableView(){
        
        
        if let viewModel = viewModel{
            
            viewModel.categoryReport.subscribe(onNext: { [self] report in
                lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
    
                totalAmount = Double(report.total_amount)
                colors = report.revenuesData.enumerated().map{_ in ColorUtils.random()}
                
                setupPieChart(data: report.revenuesData,pieChart: pieChartCategory)
                setupBarChart(data: report.revenuesData,barChart: barChartCategory)
                

//                if report.revenuesData.count > 0{
//                    tableViewHeight.constant = 200
//                    for i in (0...report.revenuesData.count - 1){
//                        let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
//                        tableViewHeight.constant += CGFloat(cell?.frame.height ?? 0)
//                        tableView.layoutIfNeeded()
//                    }
//                    tableViewHeight.constant -= 200
//                }else{
//                    tableViewHeight.constant = 0
//                }
//                
                
                
            }).disposed(by: rxbag)
  
            
            viewModel.categoryReport.map{$0.revenuesData}.bind(to: tableView.rx.items(cellIdentifier: "ItemCategoryTableViewCell", cellType: ItemCategoryTableViewCell.self))
            {(row, category, cell) in
                
                cell.total_revenue = self.totalAmount
                cell.lbl_number.backgroundColor = self.colors[row]
                cell.lbl_number.text = String(format: "%d", row+1)
                cell.lbl_percent.textColor = self.colors[row]
                cell.data = category
                
                dLog(category.category_name)
            }.disposed(by: rxbag)
        }
    }
    
    
    //MARK: Revenue By Category
   private func reportRevenueByCategory(){
        guard let viewModel = self.viewModel else {return}
        viewModel.reportRevenueByCategory().subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<RevenueCategoryReport>().map(JSONObject: response.data) {
                    report.dateString = viewModel.categoryReport.value.dateString
                    report.reportType = viewModel.categoryReport.value.reportType
                    viewModel.categoryReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }


        }).disposed(by: rxbag)
    }
    
    
}


extension ReportBusinessCategoryViewController{

    func setupPieChart(data:[RevenueCategory],pieChart:PieChartView){
        ChartUtils.customPieChart(
            pieChart: pieChart,
            dataEntries: data.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.total_amount),label: Utils.doubleToPrecent(value: Double(value.total_amount)/Double(self.totalAmount)))},
            colors: colors,
            holeEnable: true
        )
  
    }
    
    func setupBarChart(data:[RevenueCategory],barChart:BarChartView){
      
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{$0.category_name.count <= 15 ? $0.category_name : $0.category_name.prefix(15) + "..."},
            color: colors
        )
        
        
        
   
        
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
   
    }
  
}







