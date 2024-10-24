//
//  ReportBusinessAnalyticsViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 25/02/2023.
//

import UIKit
import BmoViewPager

class ReportBusinessAnalyticsViewController: BaseViewController {
    var viewModel = ReportBusinessAnalyticsViewModel()
    var router = ReportBusinessAnalyticsRouter()
    
    
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
//    @IBOutlet weak var viewPagerSegmentedView: SegmentedView!

    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var branch_logo: UIImageView!
    
    @IBOutlet weak var lbl_filter_today: UILabel!
    @IBOutlet weak var lbl_filter_yesterday: UILabel!
    @IBOutlet weak var lbl_filter_thisweek: UILabel!
    @IBOutlet weak var lbl_filter_this_month: UILabel!
    @IBOutlet weak var lbl_filter_last_month: UILabel!
    @IBOutlet weak var lbl_filter_three_month: UILabel!
    @IBOutlet weak var lbl_filter_this_year: UILabel!
    @IBOutlet weak var lbl_filter_last_year: UILabel!
    @IBOutlet weak var lbl_filter_three_year: UILabel!
    @IBOutlet weak var lbl_filter_all_year: UILabel!
    
    
    @IBOutlet weak var view_filter_today: UIView!
    @IBOutlet weak var view_filter_yesterday: UIView!
    @IBOutlet weak var view_filter_thisweek: UIView!
    @IBOutlet weak var view_filter_last_month: UIView!
    @IBOutlet weak var view_filter_this_month: UIView!
    
    @IBOutlet weak var view_filter_three_month: UIView!
    @IBOutlet weak var view_filter_this_year: UIView!
    @IBOutlet weak var view_filter_last_year: UIView!
    @IBOutlet weak var view_filter_three_year: UIView!
    @IBOutlet weak var view_filter_all_year: UIView!
    
    @IBOutlet weak var btnFilterToday: UIButton!
    @IBOutlet weak var btnFilterYesterday: UIButton!
    @IBOutlet weak var btnFilterThisweek: UIButton!
    @IBOutlet weak var btnFilterThismonth: UIButton!
    @IBOutlet weak var btnFilterThreeMonth: UIButton!
    @IBOutlet weak var btnFilterThisYear: UIButton!
    @IBOutlet weak var btnFilterLastYear: UIButton!
    @IBOutlet weak var btnFilterThreeYear: UIButton!
    @IBOutlet weak var btnFilterAllYear: UIButton!
    
    
    var dateTimeNow = ""
    var yesterday = ""
    var thisWeek = ""
    var lastThreeMonth = ""
    var lastMonth = ""
    var currentMonth = ""
    var lastThreeYear = ""
    var lastYear = ""
    var currentYear = ""
    var report_type = 1
//    var time = ""
//    var today = ""
//    var yesterday = ""
//    var monthCurrent = ""
//    var yearCurrent = ""
//    var Week = 1
//    var thisWeek = ""
//    var lastMonth = ""
//    var thisMonth = ""
//    var lastYear = ""
//    var dateTimeNow = ""
//    var report_type = 1
    
    var cates = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let link_image = Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )
        branch_logo.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text =  ManageCacheObject.getCurrentBranch().address

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(ManageCacheObject.getCurrentUser().branch_id)
        
        self.viewPagerNavigationBar.viewPager = viewPager
        self.viewPagerNavigationBar.layer.masksToBounds = true
        self.viewPager.presentedPageIndex = 0
        self.viewPager.dataSource = self
        self.viewPager.delegate = self
        
        getCurentTime()
        getCategoriesManagement()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
extension ReportBusinessAnalyticsViewController: BmoViewPagerDataSource, BmoViewPagerDelegate{
    
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return self.cates.count
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        let categoryReportViewController = CategoryReportRouter().viewController as! CategoryReportViewController
        categoryReportViewController.cate_id = self.cates[page].id
        self.viewModel.cate_id.accept(self.cates[page].id)
        self.viewModel.restaurant_brand_id.accept(ManageCacheObject.getCurrentBrand().id)
        self.viewModel.category_types.accept(ACTIVE)
        categoryReportViewController.viewModel = self.viewModel
        return categoryReportViewController
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0,weight: .semibold),
//            NSAttributedString.Key.b
            NSAttributedString.Key.foregroundColor : ColorUtils.green_200()
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            NSAttributedString.Key.foregroundColor : ColorUtils.green_600()
        ]
    }
    

    
 
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return cates[page].name.uppercased()
    }

    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        

        if self.cates.count > 3 {
            return CGSize(width: (navigationBar.bounds.width) / 3 - 10, height: navigationBar.bounds.height)
        }
        else {
            return CGSize(width: (navigationBar.bounds.width) / CGFloat(cates.count), height: navigationBar.bounds.height)
        }
    }
    
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        self.viewModel.is_goods.accept(page)
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.addBottomBorder(color: ColorUtils.green_600(),borderLineSize:4)
        return view
    }
 

 
}
