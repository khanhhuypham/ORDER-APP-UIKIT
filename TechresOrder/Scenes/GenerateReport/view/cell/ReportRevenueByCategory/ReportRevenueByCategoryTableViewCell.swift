//
//  ReportRevenueByCategoryTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import Charts
import RxSwift
import RxRelay
class ReportRevenueByCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lbl_total_revenue: UILabel!
    @IBOutlet weak var table_view_cate: UITableView!

    @IBOutlet weak var lbl_title_report: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var pie_chart: PieChartView!
    var pieChartItems = [PieChartDataEntry]()
    var colors = [UIColor]()
    
    var totalAmount = 1.0
    
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    var btnArray:[UIButton] = []
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
        let categoryItemRevenueTableViewCell = UINib(nibName: "CategoryItemRevenueTableViewCell", bundle: .main)
        table_view_cate.register(categoryItemRevenueTableViewCell, forCellReuseIdentifier: "CategoryItemRevenueTableViewCell")
        table_view_cate.rx.setDelegate(self).disposed(by: disposeBag)
    }
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {return}
        var categoryReport = viewModel.categoryRevenueReport.value
        categoryReport.revenuesData = []
        categoryReport.reportType = sender.tag
        categoryReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.categoryRevenueReport.accept(categoryReport)
        viewModel.view?.getCategoryReport()
    }

    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailRevenueByFoodCategoryViewController()
    }
    
    
    var viewModel: GenerateReportViewModel? {
       didSet {
           guard let viewModel = self.viewModel else {return}
           btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
          
           for btn in self.btnArray{
               btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                   Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
               }).disposed(by: disposeBag)
               
               if btn.tag == viewModel.categoryRevenueReport.value.reportType {
                   Utils.changeBgBtn(btn: btn, btnArray: btnArray)
               }

           }
           bindViewModel()
       }
    }
    
}
extension ReportRevenueByCategoryTableViewCell:UITableViewDelegate{
    private func bindViewModel() {
        if let viewModel = viewModel {
            /*
                 table_view_cate lắng nghe trước sau đó
                 viewModel.revenueCategories.accept(revenueCategory.revenues!) là table_view_cate sẽ có dữ liệu
             */
            viewModel.categoryRevenueReport.map{$0.revenuesData}.bind(to: table_view_cate.rx.items(cellIdentifier: "CategoryItemRevenueTableViewCell", cellType: CategoryItemRevenueTableViewCell.self))
            {(row, category, cell) in
                cell.color = self.colors[row]
                cell.totalAmount = self.totalAmount
                cell.category = category
            }.disposed(by: disposeBag)
            
            viewModel.categoryRevenueReport.subscribe( // Thực hiện subscribe Observable data
              onNext: { [weak self] report in
                  self?.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
                  
                  self!.setByCategoryRevenueChart(revenues: report.revenuesData)
                  self!.totalAmount = Double(report.total_amount)

            }).disposed(by: disposeBag)
        }

     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReportRevenueByCategoryTableViewCell{

    func setByCategoryRevenueChart(revenues: [RevenueCategory]) {
        self.pie_chart.noDataText = NSLocalizedString("Data not available", comment: "")
        pieChartItems.removeAll()
        
        
        
        colors = revenues.map{_ in ColorUtils.random()}
        pieChartItems = revenues.enumerated().map{(index,value) in PieChartDataEntry(value: Double(value.total_amount))}

    
//        
        self.colors.append(ColorUtils.red_color())
        self.colors.append(ColorUtils.orange_brand_900())
//        
        

        pie_chart.drawHoleEnabled = true
        pie_chart.drawCenterTextEnabled = true
        pie_chart.holeRadiusPercent = 0.5
        pie_chart.transparentCircleRadiusPercent = 0.61
               
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let centerText = NSMutableAttributedString(string: Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(revenues.map{Double($0.total_amount)}.reduce(0.0, +))))

        centerText.addAttributes([.font : UIFont.systemFont(ofSize: 14,weight: .bold),
                                  .foregroundColor : ColorUtils.green_600()],
                             range: NSRange(location: 0, length: centerText.length))

        pie_chart.centerAttributedText = centerText
     
        
        let pieChartDataSet = PieChartDataSet(entries: self.pieChartItems, label: "")
        pieChartDataSet.colors = self.colors
        pieChartDataSet.sliceSpace = 0
        pieChartDataSet.selectionShift = 5
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.yValuePosition = .insideSlice
        pieChartDataSet.valueTextColor = .white
        pieChartDataSet.valueLineWidth = 100
        pieChartDataSet.valueLinePart1Length = 1
        pieChartDataSet.valueLinePart2Length = 1
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.drawIconsEnabled = false
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        pie_chart.data = PieChartData(dataSet: pieChartDataSet)
        pie_chart.entryLabelColor = .black
        pie_chart.transparentCircleRadiusPercent = CGFloat(0.1)
        //gone chú thích
        pie_chart.legend.enabled = false
        pie_chart.legend.horizontalAlignment = .center

        pie_chart.clearsContextBeforeDrawing = true
        pie_chart.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.easeInOutBack)
        pie_chart.entryLabelFont = UIFont.init(name: "HelveticaNeue", size: 4)
    }
    
}
