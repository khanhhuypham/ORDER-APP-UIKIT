//
//  ReportBusinessViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import BmoViewPager

class ReportBusinessViewController: BaseViewController {
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    
    var viewModel = ReportBusinessViewModel()
    var router = ReportBusinessRouter()
    var categoryReport:RevenueCategoryReport = RevenueCategoryReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var areaRevenueReport:AreaRevenueReport = AreaRevenueReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var tableRevenueReport:TableRevenueReport = TableRevenueReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var foodReport:FoodReportData = FoodReportData.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var otherFoodReport:FoodReportData = FoodReportData.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var cancelFoodReport:FoodReportData = FoodReportData.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var giftReport:FoodReportData = FoodReportData.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var discountReport:DiscountReport = DiscountReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    var vatReport:VATReport = VATReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)

    
  
    
    
    
    @IBOutlet weak var avatar_branch: UIImageView!
    @IBOutlet weak var branch_name: UILabel!
    @IBOutlet weak var branch_address: UILabel!
    

    
    @IBOutlet weak var scroll_view: UIScrollView!

    
    var cates = [Category]()
    var cate_names = ["DANH MỤC", "MÓN ĂN","MÓN NGOÀI MENU" ,"MÓN HỦY", "MÓN TẶNG", "GIẢM GIÁ", "VAT","BÀN","KHU VỰC"]
    var categoryPresent:Int = 0

    
    @IBOutlet weak var viewMenu: UIView!
    
    @IBOutlet weak var height_of_view_menu: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)

        viewModel.categoryReport.accept(categoryReport)
        viewModel.areaRevenueReport.accept(areaRevenueReport)
        viewModel.tableRevenueReport.accept(tableRevenueReport)
        viewModel.foodReport.accept(foodReport)
        viewModel.otherFoodReport.accept(otherFoodReport)
        viewModel.cancelFoodReport.accept(cancelFoodReport)
        viewModel.giftedFoodReport.accept(giftReport)
        viewModel.discountReport.accept(discountReport)
        viewModel.vatReport.accept(vatReport)
        
        
        self.viewPagerNavigationBar.viewPager = viewPager
        self.viewPagerNavigationBar.layer.masksToBounds = true
        self.viewPager.presentedPageIndex = categoryPresent
        self.viewPager.dataSource = self
        self.viewPager.delegate = self
        
        // iterate from i = 0 to i = 5
        for i in 0..<cate_names.count {
            var cate = Category()
            cate?.id = i
            cate?.name = cate_names[i]
            self.cates.append(cate!)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // thêm tên chi nhánh và địa chỉ chi nhánh, hình ảnh
        branch_name.text = ManageCacheObject.getCurrentBranch().name // tên chi nhánh
        branch_address.text = ManageCacheObject.getCurrentBranch().address // đia chỉ chi nhánh
      
        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )), placeholder: UIImage(named: "image_defauft_medium"))
        /*
            Nếu từ module tổng quan route qua module này thì ta hiển thị report của tháng này
         */
//        report_type == REPORT_TYPE_THIS_MONTH ? actionFilterThisMonth(REPORT_TYPE_THIS_MONTH) : actionFilterToday(REPORT_TYPE_TODAY)
//        scroll_view.setContentOffset(report_type == REPORT_TYPE_THIS_MONTH ? CGPoint(x: 200,y: 0) : CGPoint(x: 0,y: 0), animated: true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }


}
extension ReportBusinessViewController: BmoViewPagerDataSource, BmoViewPagerDelegate{
    
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return self.cates.count
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page{
            case 0: //MARK: Báo cáo danh mục
                let vc = ReportBusinessCategoryViewController()
                vc.viewModel = self.viewModel
                return vc
            
            case 1://MARK: Báo cáo món ăn
                let vc = ReportBusinessFoodViewController()
                vc.viewModel = self.viewModel
                return vc
            
            case 2://MARK: Báo cáo món ngoài menu
                let vc = ReportOtherFoodViewController()
                vc.viewModel = self.viewModel
                return vc
            
            
            case 3://MARK: Báo cáo món huỷ
                let vc = ReportBusinessCancelFoodViewController()
                vc.viewModel = self.viewModel
                return vc
                
            
            case 4://MARK: Báo cáo món tăng

                let vc = ReportBusinessGiftFoodViewController()
                vc.viewModel = self.viewModel
                return vc
            
            
            case 5://MARK: Báo cáo giảm giá
                let vc = ReportBusinessDiscountViewController()
                vc.viewModel = self.viewModel
                return vc
            
            case 6://MARK: Báo cáo doanh thu VAT
                let vc = ReportBusinessVATViewController()
                vc.viewModel = self.viewModel
                return vc
            
            
            case 7://MARK: Báo cáo doanh thu bàn
                let vc = ReportBusinessTableRevenueViewController()
                vc.viewModel = self.viewModel
                return vc
            
            case 8://MARK: Báo cáo doanh thy khu vực
                let vc = ReportBusinessAreaRevenueViewController()
                vc.viewModel = self.viewModel
                return vc
            
    
            default://MARK: Báo cáo món ăn, món tặng, món huỷ
                let reportBusinessFoodViewController = ReportBusinessFoodViewController()
                reportBusinessFoodViewController.viewModel = self.viewModel
                return reportBusinessFoodViewController
            
        }

    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            NSAttributedString.Key.foregroundColor : ColorUtils.green_200() // chỉnh màu xanh nhạt
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            NSAttributedString.Key.foregroundColor : ColorUtils.green_600() // chỉnh màu xanh đậm
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return self.cates[page].name.uppercased()
    }

    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        switch page {
            case 0:
                return CGSize(width: 100, height: navigationBar.bounds.height)
            
            case 1:
                return CGSize(width: 100, height: navigationBar.bounds.height)
            
            case 2:
                return CGSize(width: 150, height: navigationBar.bounds.height)
            
            case 3:
                return CGSize(width: 100, height: navigationBar.bounds.height)
            case 4:
                return CGSize(width: 100, height: navigationBar.bounds.height)
            case 5:
                return CGSize(width: 100, height: navigationBar.bounds.height)
            case 6:
                return CGSize(width: 60, height: navigationBar.bounds.height)
            case 7:
                return CGSize(width: 60, height: navigationBar.bounds.height)
            case 8:
                return CGSize(width: 80, height: navigationBar.bounds.height)
            default:
                return CGSize(width: 100, height: navigationBar.bounds.height)
        }
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.addBottomBorder(color: ColorUtils.green_600(),borderLineSize: 4) // Thêm màu đường line màu xanh
        return view
    }
}
