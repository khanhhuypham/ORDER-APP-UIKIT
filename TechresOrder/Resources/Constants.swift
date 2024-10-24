//
//  Constants.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit



let color = NSAttributedString.Key.foregroundColor
let crossLineKey = NSAttributedString.Key.strikethroughStyle
let crossLineValue = NSNumber(value: NSUnderlineStyle.single.rawValue)

struct Constants {
    static let apiKey = "net.techres.order.api"
    static let OS_NAME = "iOS"


    struct PROJECT_IDS {
        static let PROJECT_OAUTH = 8003 // oauth java api
        static let PROJECT_ID_ORDER = 8005
        static let PROJECT_ID_DASHBOARD = 8011
        static let PROJECT_ID_ORDER_SMALL = 8004
        static let PROJECT_ID_BUSINESS_REPORT = 1453
        static let PROJECT_ID_FINANCE_REPORT = 1454
        static let PROJECT_UPLOAD_SERVICE = 9007
        static let PROJECT_HEALTH_CHECK_SERVICE = 1408
        static let PROJECT_ID_LOG = 9018
        static let PROJECT_ID_VERSION_APP = 8001
    }

    struct METHOD_TYPE {
        static let POST = 1
        static let GET = 0
    }

    
    
    //BETA
    struct URL {
        static let GETWAY_SERVER_URL = "http://172.16.2.243:8092/api/queues"
        static let CHAT_DOMAIN = "http://172.16.2.240:1483"
        static let REALTIME_SERVER_URL = "http://172.16.2.240:1483"
        static let UPLOAD_DOMAIN = "https://beta.storage.aloapp.vn"
    }
    

    
    struct KEY_DEFAULT_STORAGE{
        static let KEY_ACCOUNT = "KEY_ACCOUNT"
        static let KEY_CURRENT_POINT = "KEY_CURRENT_POINT"
        static let KEY_ACCOUNT_ID = "KEY_ACCOUNT_ID"
        static let KEY_TOKEN = "KEY_TOKEN"
        static let KEY_PUSH_TOKEN = "KEY_PUSH_TOKEN"
        static let KEY_CONFIG = "KEY_CONFIG"
        static let KEY_SETTING = "KEY_SETTING"
        static let KEY_PHONE = "KEY_PHONE"
        static let KEY_PASSWORD = "KEY_PASSWORD"
        static let KEY_BIOMETRIC = "KEY_BIOMETRIC"
        static let KEY_LOGIN = "KEY_LOGIN"
        static let KEY_LOCATION = "KEY_LOCATION"
        static let KEY_PERMISION_CONTACT = "KEY_PERMISION_CONTACT"
        static let KEY_TIME = "KEY_TIME"
        static let KEY_ACCOUNT_NODE = "KEY_ACCOUNT_NODE"
        static let KEY_TAB_INDEX = "KEY_TAB_INDEX"
        static let KEY_NUMBER_UNREAD_MESSAGE = "KEY_NUMBER_UNREAD_MESSAGE"
        
        static let KEY_BRANCH_RIGHTS = "KEY_BRAND_RIGHTS"
        static let KEY_BRAND = "KEY_BRAND"
        static let KEY_BRANCH = "KEY_BRANCH"
        static let KEY_RESTAURANT_NAME = "KEY_RESTAURANT_NAME"
        static let KEY_PAYMENT_METHOD = "KEY_PAYMENT_METHOD"
        static let KEY_ORDER_METHOD = "KEY_ORDER_METHOD"
        static let KEY_DEV_MODE = "KEY_DEV_MODE"
        static let KEY_IDLE_TIMER = "KEY_IDLE_TIMER"
        static let KEY_BANK_ACCOUNT = "KEY_BANK_ACCOUNT"
    }
    
    struct LOGIN_FORM_REQUIRED{
        //        static let requiredUserIDMinLength = 6
        static let requiredUserIDMinLength = 8
        static let requiredUserIDMaxLength = 10
        
        static let requiredUserNameLength = 4
        static let requiredPasswordLengthMin = 4
        static let requiredPasswordLengthMax = 20
        static let requiredPhoneMinLength = 10
        static let requiredPhoneMaxLength = 11
        
        static let requiredRestaurantMinLength = 2
        static let requiredRestaurantMaxLength = 50
        
    }


    // Thêm truong giới hạn của table Area
    struct AREA_TABLE_REQUIRED{
        static let requiredAreaTableMinLength = 2
        static let requiredAreaTableMaxLength = 7
    }
    
    


    

    
    struct UPDATE_INFO_FORM_REQUIRED{
        static let requiredNameLength = 2
        static let requiredNameLengthMax = 50
        static let requiredGender = 3
        
        static let requiredPassword = 4
        static let requiredPasswordMin = 4
        static let requiredPasswordMax = 20
        static let requireNameMin = 2
        static let requireNameMax = 50
        static let requireEmailLength = 50
        static let requireAddressLength = 255
        static let requireAddressMin = 2
        
        static let requireEmailLengthMin = 3
        static let requireDescriptionMin = 3
        static let requireDescriptionMax = 255
    }
    
    
    
    
//    struct PRINTER_TYPE{
//        static let BAR = 0
//        static let CHEF = 1
//        static let CASHIER = 2
//        static let FISH_TANK = 3
//        static let STAMP = 4
//    }
//    
    
    
   
    
    
    public enum printType {
        case new_item
        case cancel_item
        case return_item
        case print_test

    
        // 2- Hủy món | 3- trả bia | 1- món mới
        var value: Int {
            switch self {
            case .print_test:
                return 0
            case .new_item:
                return 1
            case .cancel_item:
                return 2
            case .return_item:
                return 3
            
            }
        }
    }
    
    
   
    
    public enum areaType {
        case moveTable
        case mergeTable
        case splitFood

    }
    
    
    
    
    struct PAYMENT_METHOD{
        static let CASH = 1
        static let TRANSFER = 6 //Chuyển khoản
        static let ATM_CARD = 2 //sử dụng thẻ
    }
    
    struct FOOD_TYPE{
        static let ADDITION = 1
        static let TRANSFER = 6 //Chuyển khoản
        static let ATM_CARD = 2 //sử dụng thẻ
    }
    
    static var isLogin:Bool{
        get{
            ManageCacheObject.isLogin()
        }
    }
        
    
    
    static var branch:Branch{
        get{
            ManageCacheObject.getCurrentBranch()
        }
    }
            
    static var brand:Brand{
        get{
            ManageCacheObject.getCurrentBrand()
        }
    }
   
    
    static var restaurant_id:Int{
        get{
            return ManageCacheObject.getCurrentBrand().restaurant_id
        }
    }
    
    static var bill_type:Bill_TYPE{
        get{
            return ManageCacheObject.getSetting().template_bill_printer_type
        }
    }
    
    
    static var setting:Setting{
        get{
            return ManageCacheObject.getSetting()
        }
    }
    
    static var bankAccount:BankAccount{
        get{
            return ManageCacheObject.getBankAccount()
        }
    }
    
    static var user:Account{
        get{
            return ManageCacheObject.getCurrentUser()
        }
    }
    
    static var printers:[Printer]{
        get{
//            var printerArray:[Printer] = ManageCacheObject.getChefBarConfigs(cache_key: KEY_CHEF_BARS)
//            printerArray.append(ManageCacheObject.getPrinterBill(cache_key: KEY_PRINTER_BILL))
            return ManageCacheObject.getPrinters(cache_key: KEY_CHEF_BARS)
        }
    }
    
    
//    static var foodAppPrinters:[Printer]{
//        get{
//            return ManageCacheObject.getAppFoodPrinter(cache_key: KEY_FOOD_APP_PRINTER)
//        }
//    }
    
    static var BLEPrinter:[CBPeripheral] = []

    static var REPORT_TYPE_DICTIONARY:[Int:String]{
        
        get{
            return [
                REPORT_TYPE_TODAY:TimeUtils.getCurrentDateTime().dateTimeNow,
                REPORT_TYPE_YESTERDAY:TimeUtils.getCurrentDateTime().yesterday,
                REPORT_TYPE_THIS_WEEK:TimeUtils.getCurrentDateTime().thisWeek,
                REPORT_TYPE_LAST_MONTH:TimeUtils.getCurrentDateTime().lastMonth,
                REPORT_TYPE_THIS_MONTH:TimeUtils.getCurrentDateTime().thisMonth,
                REPORT_TYPE_THREE_MONTHS:TimeUtils.getCurrentDateTime().threeLastMonth,
                REPORT_TYPE_LAST_YEAR:TimeUtils.getCurrentDateTime().lastYear,
                REPORT_TYPE_THIS_YEAR:TimeUtils.getCurrentDateTime().yearCurrent,
                REPORT_TYPE_THREE_YEAR:TimeUtils.getCurrentDateTime().threeLastYear,
                REPORT_TYPE_ALL_YEAR:""]
        }
    }
    
    
}


@objc(PRINTER_NOTIFI)
class PRINTER_NOTIFI : NSObject {
    
    @objc static let PRINTER_METHOD_KEY = "vn.techres.printer_method_key"
    @objc static let IS_PRINT_WIFI = "vn.techres.is_print_wifi"
    @objc static let PRINT_SUCCESS = "vn.techres.print.success"
    @objc static let PRINT_FAIL = "vn.techres.print.fail"
    @objc static let CONNECT_SUCCESS = "vn.techres.printer.connect.success"
    @objc static let CONNECT_FAIL = "vn.techres.printer.connect.fail"
    
    @objc static let ERROR_FROM_PRINT_FUNCTION_OF_FOOD_APP = "vn.techres.printer.foodApp.fail"
    
    
    @objc static let BACKGROUND_PRINT_SUCCESS = "vn.techres.print.success_background"
    @objc static let BACKGROUND_PRINT_FAIL = "vn.techres.print.fail_background"
    @objc static let BACKGROUND_CONNECT_SUCCESS = "vn.techres.printer.connect.success_background"
    @objc static let BACKGROUND_CONNECT_FAIL = "vn.techres.printer.connect.fail_background"
    
    
    static let SETUP_LOCALDATABASE_LISTENER = "vn.techres.print.setup_local_database_listener"
    static let REMOVE_LOCALDATABASE_LISTENER = "vn.techres.print.remove_local_database_listener"
    
}
