//
//  Utilities_rebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/10/2023.
//

import UIKit
import Kingfisher

class UtilitiesViewController: BaseViewController {
    
    var viewModel = UtilitiesViewModel()
    private var router = UtilitiesRouter()
    
    @IBOutlet weak var lbl_employee_code: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var avatar_employee: UIImageView!
    
    
    @IBOutlet weak var view_point: UIView!
    @IBOutlet weak var lbl_current_point: UILabel!
    
    @IBOutlet weak var lbl_current_amount: UILabel!
    
    
    @IBOutlet weak var avatar_branch: UIImageView!
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_branch_address: UILabel!
    
    @IBOutlet weak var top_constraint_of_stackview: NSLayoutConstraint!
    
    @IBOutlet weak var view_member_register: UIView!
    @IBOutlet weak var view_print_config: UIView!
    @IBOutlet weak var view_config: UIView!
    
    @IBOutlet weak var view_area_manager: UIView!
    @IBOutlet weak var view_food_manager: UIView!
    @IBOutlet weak var view_order_manager: UIView!
    
    @IBOutlet weak var view_report: UIView!
    @IBOutlet weak var view_report_employee: UIView!
    
    
    @IBOutlet weak var stackView_of_food_app: UIStackView!
    @IBOutlet weak var view_assign_branch_of_food_app: UIView!
    
    
    
    var originalPosition: CGPoint = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        
 
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapData()
        
        
    }
    
    
    
    
    
     func mapData(){
         let user = Constants.user
         //map thông tin account
         lbl_employee_code.text = user.username
         lbl_employee_name.text = user.name
         avatar_employee.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: user.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
         lbl_current_point.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_target_point))
         lbl_current_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(ManageCacheObject.getCurrentPoint().next_rank_bonus_salary))
         view_point.isHidden = ManageCacheObject.getSetting().service_restaurant_level_id < 2 ? true : false
         // map thông tin chi nhanh
         avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo)), placeholder: UIImage(named: "image_defauft_medium"))
                
         lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
         lbl_branch_address.text =  ManageCacheObject.getCurrentBranch().address
        
         view_member_register.isHidden = permissionUtils.GPQT_3_and_above && ManageCacheObject.getSetting().is_enable_membership_card == ACTIVE ? false : true
         
         view_print_config.isHidden = permissionUtils.IOSPrinter ? false : true
         
         view_config.isHidden = permissionUtils.GPBH_1 || (permissionUtils.GPBH_2_o_1 && permissionUtils.OwnerOrCashier) ? false : true
         
         if view_print_config.isHidden && view_member_register.isHidden && view_config.isHidden{
             top_constraint_of_stackview.constant = 0
         }
         

        view_area_manager.isHidden = permissionUtils.GPBH_1 ? false : true
        view_food_manager.isHidden = permissionUtils.GPBH_1 ? false : true
        view_report_employee.isHidden = permissionUtils.GPBH_1 ? true : false
         
        view_assign_branch_of_food_app.isHidden = permissionUtils.GPBH_2_o_2 || permissionUtils.GPBH_2_o_3 || permissionUtils.GPBH_3 ? true : false
         stackView_of_food_app.isHidden = permissionUtils.isAllowFoodApp ? false : true
         

        //NẾU LÀ GIẢI PHÁP QUẢN TRỊ THÌ ẨN VIEW NÀY ĐI
        if(ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_TWO ){
            view_report.isHidden = true
        }else{
            // ẩn view_report_cell khi đang không phải quyền chủ nhà hàng
            view_report.isHidden = Utils.checkRoleOwner(permission: user.permissions) ? false : true
        }
         
    }
    
    
    @IBAction func actionNavigateToSettingAccount(_ sender: Any) {
        viewModel.makeSettingAccountViewController()

    }
    
    @IBAction func actionNavigateToUpdateBranch(_ sender: Any) {
        !permissionUtils.GPBH_1 ? presentModalChooseBrand() : viewModel.makeToUpdateBranchViewController()

    }
    
    
        
    
    @IBAction func actionNavigateToCustomerRegister(_ sender: Any) {
        viewModel.makeMemberRegisterViewController()

    }
    @IBAction func actionNavigateToSettingPrinter(_ sender: Any) {
        viewModel.makeSettingPrinterViewController()
    }
    
 
    
    @IBAction func actionNavigateToSetting(_ sender: Any) {
        viewModel.makeSettingViewController()
    }
    
    
    @IBAction func actionNavigateToAreaManagement(_ sender: Any) {
        viewModel.makeManagementAreaTableViewController()
    
    }
    @IBAction func actionNavigateToFoodManagement(_ sender: Any) {
        viewModel.makeManagementCategoryFoodNoteViewController()
        
    }
    @IBAction func actionNavigateToOrderManagement(_ sender: Any) {
        viewModel.makeOrderManagementViewController()
    }
    
    @IBAction func actionNavigateToRevenueDetail(_ sender: Any) {
        viewModel.makeToRevenueDetailViewController()
    }
    
    @IBAction func actionNavigateToReportBusinessAnalytics(_ sender: Any) {
        viewModel.makeToReportBusinessAnalyticsViewController()
    }
    
    @IBAction func actionNavigateToReportBusiness(_ sender: Any) {
        viewModel.makeToReportBusinessViewController()
    }
    
    @IBAction func actionNavigateToEmployeeReport(_ sender: Any) {
        viewModel.makeToEmployeeReportRevenueViewController()
    }
    
    
    @IBAction func actionNavigateToEnvironmentManagement(_ sender: Any) {
        viewModel.makeEnvironmentViewController()
    }
    
    
    
    @IBAction func actionNavigateToTechresShop(_ sender: Any) {
        viewModel.makeWebViewController()
    }
    
    
    @IBAction func actionNavigateToAppFood(_ sender: Any) {
        viewModel.makeAppFoodViewController()
    }
    
  
    @IBAction func actionNavigateToAssignToAppFood(_ sender: Any) {
        viewModel.makeAssignToAppFoodViewController()
    }
    
    @IBAction func actionNavigateToFoodAppDiscount(_ sender: Any) {
        viewModel.makeFoodAppDiscountViewController()
    }
    
    
    @IBAction func actionNavigateToFoodAppPrinter(_ sender: Any) {
        viewModel.makeSettingPrinterViewController(isFoodApp: true)
    }
    
    
    @IBAction func actionNavigateToOrderHistoryOfFoodApp(_ sender: Any) {
        viewModel.makeOrderHistoryOfFoodAppViewController()
    }
    
    @IBAction func actionNavigateToFoodAppReport(_ sender: Any) {
        viewModel.makeFoodAppReportViewController()
    }
    
    
    
   
}
