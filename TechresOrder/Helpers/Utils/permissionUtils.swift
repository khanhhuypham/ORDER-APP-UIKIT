//
//  permissionUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 03/05/2024.
//

import UIKit

struct permissionUtils {
    //======== Role Name ========
    static private let OWNER = "OWNER"
    static private let FOOD_MANAGER = "FOOD_MANAGER"
    static private let GENERAL_MANAGER = "GENERAL_MANAGER"
    static private let CHEF_MANAGER = "CHEF_MANAGER"
    static private let ACCOUNTING_MANAGER = "ACCOUNTING_MANAGER"
    static private let CANCEL_COMPLETED_FOOD = "CANCEL_COMPLETED_FOOD"
    static private let EMPLOYEE_MANAGER = "EMPLOYEE_MANAGER"
    static private let RESTAURANT_MANAGER = "RESTAURANT_MANAGER"
    static private let CASHIER_ACCESS = "CASHIER_ACCESS"
    static private let TICKET_MANAGEMENT = "TICKET_MANAGEMENT"

    static private let DISCOUNT_FOOD = "DISCOUNT_FOOD"
    static private let DISCOUNT_ORDER = "DISCOUNT_ORDER"
    static private let ADD_FOOD_NOT_IN_MENU = "ADD_FOOD_NOT_IN_MENU"
    static private let BRANCH_MANAGER = "BRANCH_MANAGER"
    static private let AREA_TABLE_MANAGER = "AREA_TABLE_MANAGER"
    static private let CANCEL_DRINK = "CANCEL_DRINK"
    static private let NEWS_MANAGER = "NEWS_MANAGER"
    static private let UNREACHABLE_NETWORK = "UNREACHABLE_NETWORK"
    static private let REACHABLE_NETWORK = "REACHABLE_NETWORK"
    static private let ACTION_ON_FOOD_AND_TABLE = "ACTION_ON_FOOD_AND_TABLE"
    static private let ORDER_FOOD = "ORDER_FOOD"
    static private let SHARE_POINT = "SHARE_POINT_IN_BILL"
    static private let VIEW_ALL = "VIEW_ALL"
    static private let REPORT_SYSTEM_ERRORS = "REPORT_SYSTEM_ERRORS"
    
    static private let SALE_REPORT = "SALE_REPORT"
    
    
    static var GPBH_1:Bool {
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE
        }
    }
    
    
    static var GPBH_1_o_1:Bool {
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE
        }
    }
    
    
    static var GPBH_1_o_2:Bool {
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO
        }
    }
    
    
    static var GPBH_1_o_3:Bool {
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_ONE && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE
        }
    }
    
    
    static var GPBH_2:Bool {
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO
        }
    }
    
    
    static var GPBH_2_o_1:Bool {
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_ONE
        }
    }
    
    
    static var GPBH_2_o_2:Bool{
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_TWO
        }
        
    }
    
    
    static var GPBH_2_o_3:Bool{
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_TWO && ManageCacheObject.getSetting().branch_type_option == BRANCH_TYPE_OPTION_THREE
        }
        
    }
    
    static var GPBH_3:Bool{
        get{
            return ManageCacheObject.getSetting().branch_type == BRANCH_TYPE_LEVEL_THREE
        }
        
    }
    
    static var GPQT_1_and_above :Bool{
        get{
            return ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_ONE
        }
        
    }
    
    static var GPQT_2_and_above:Bool{
        get{
            return ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_TWO
        }
        
    }
    
    static var GPQT_3_and_above:Bool{
        get{
            return ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_THREE
        }
        
    }
    
    
    static var GPQT_5_and_above :Bool{
        get{
            return ManageCacheObject.getSetting().service_restaurant_level_id >= GPQT_LEVEL_FIVE
        }
    }
    
    static var OwnerOrCashier :Bool{
        get{
          
            var isAllow = false
            for item in ManageCacheObject.getCurrentUser().permissions {
                if ((item.elementsEqual(OWNER)) == true || (item.elementsEqual(CASHIER_ACCESS)) == true){
                      isAllow = true
                    }
            }
            return isAllow
        }
    }
    
    
    static var Owner:Bool{
        get{
            return ManageCacheObject.getCurrentUser().permissions.contains(OWNER)
        }

    }
    
    
    static var Cashier:Bool{
        get{

            return ManageCacheObject.getCurrentUser().permissions.contains(CASHIER_ACCESS)
        }

    }
    
    static var BuffetManager:Bool{
        get{
            let permissions = ManageCacheObject.getCurrentUser().permissions
            return permissions.contains(TICKET_MANAGEMENT) || permissions.contains(OWNER)
        }
    }
    
    static var OrderManager:Bool{
        get{
            let permissions = ManageCacheObject.getCurrentUser().permissions
    
            return permissions.contains(ACTION_ON_FOOD_AND_TABLE) || permissions.contains(OWNER)
        }
    }
    
    
    static var discountOrderItem:Bool{
        get{
            let permissions = ManageCacheObject.getCurrentUser().permissions
    
            return permissions.contains(DISCOUNT_ORDER) || permissions.contains(OWNER)
        }
    }
    
    
    static var is_allow_take_away :Bool{
        get{
            return (GPBH_1 || GPBH_2_o_1 && OwnerOrCashier) && ManageCacheObject.getOrderMethod().is_have_take_away == ACTIVE
        }
    }
    
    
    static var is_enale_buffet:Bool{
        get{
            return ManageCacheObject.getSetting().is_enable_buffet == ACTIVE
        }
    }
    
    static var IOSPrinter :Bool{
        get{
            return GPBH_1_o_2 || GPBH_1_o_3 || GPBH_2_o_1
        }
    }


    static var BillPrinter :Bool{
        get{
            let billPrinter = Constants.printers.filter{$0.type == .cashier}.first ?? Printer()

            return billPrinter.is_have_printer == ACTIVE &&
            Utils.checkRoleIsPrintBill() &&
            (GPBH_1_o_3 || (GPBH_2_o_1 && OwnerOrCashier))
        }
    }


    static var KitchenPrinter:Bool{
        get{
            return GPBH_1_o_2 ||  GPBH_1_o_3
        }
    }
    
    
    static var Checking:Bool{
        get{
          
            if ManageCacheObject.getCurrentBranch().is_enable_checkin == ACTIVE{
                return Constants.user.is_working == ACTIVE ? true : false
            }else{
                return true
            }
            
        }
    }
    
    static var toggleWorkSession:Bool{
        // kiểm tra chỉ có GPBH_2_o_1 && Có quyền thu ngân mới mở ca & đóng ca làm việc để bắt đầu làm việc ca mới.
        get{
            
            var condition:Bool = false
            let branch = Constants.branch
            
            if permissionUtils.GPBH_2_o_1 && permissionUtils.Cashier && branch.is_office == DEACTIVE && !Constants.user.alreadCheckWorkingSession{
                condition = true
            }else if branch.is_office == ACTIVE && permissionUtils.Owner{
                condition = false
            }
            
            return condition
        }
    }
    
    
    static var reportSytemError:Bool{
        get{
            let permissions = ManageCacheObject.getCurrentUser().permissions
            return permissions.contains(REPORT_SYSTEM_ERRORS)
            
        }
    }
    
    
    static var isAllowFoodApp:Bool{
        get{
 
            let isAllow = Constants.branch.setting.is_enable_app_food == ACTIVE ? true : false
//            let isAllow = (Constants.branch.setting.is_enable_app_food == ACTIVE) && (GPBH_1 || GPBH_2_o_1) ? true : false
            return isAllow
            
        }
    }
    
    
    static var isSaleReport:Bool{
        get{
            let permissions = ManageCacheObject.getCurrentUser().permissions
            return permissions.contains(SALE_REPORT) || permissions.contains(OWNER)
            
        }
    }
    
    
    
}
