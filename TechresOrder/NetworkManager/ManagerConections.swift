//
//  ManagerConections.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import Foundation
import RxSwift
import Moya
import Alamofire
//import NVActivityIndicatorView
    

enum ManagerConections: TargetType {
    // ========= API BUSINESS JAVA CORE =======
    case sessions
    case config(restaurant_name:String)
    case checkVersion
    case regisDevice(deviceRequest:DeviceRequest)
    case login(username:String, password:String)
    case setting(branch_id:Int)
    case areas(branch_id:Int, status:Int)
    case tables(branchId:Int, area_id:Int, status:String, exclude_table_id:Int = 0, order_statuses:String = "")
    case brands(key_search:String = "", status:Int = -1)
    case branches(brand_id:Int, status:Int)
    case orders(userId:Int, order_status:String, key_word:String = "", branch_id:Int = -1,is_take_away:Int=DEACTIVE)
    case order(order_id:Int, branch_id:Int)
    case foods(branch_id:Int, area_id:Int = -1, category_id:Int, category_type:Int, is_allow_employee_gift:Int = -1, is_sell_by_weight:Int = -1, is_out_stock:Int = 0, key_word:String = "",limit:Int,page:Int)
    case addFoods(branch_id:Int, order_id:Int, foods:[FoodRequest], is_use_point:Int)
    case addGiftFoods(branch_id:Int, order_id:Int, foods:[FoodRequest], is_use_point:Int)
    case kitchenes(branch_id:Int, brand_id:Int, status:Int = 1)
    case vats
    case addOtherFoods(branch_id:Int, order_id:Int, foods:OtherFoodRequest)
    case addNoteToOrderDetail(branch_id:Int, order_detail_id:Int, note:String)
    case reasonCancelFoods(branch_id:Int)
    case cancelFood(branch_id:Int, order_id:Int, reason:String, order_detail_id:Int, quantity:Int)
    case updateFoods(branch_id:Int, order_id:Int, foods:[FoodUpdateRequest])
    case ordersNeedMove(branch_id:Int, order_id:Int, food_status:String = "")
    case moveFoods(branch_id:Int, order_id:Int, destination_table_id:Int,target_table_id:Int, foods:[FoodSplitRequest])
    case getOrderDetail(order_id:Int, branch_id:Int, is_print_bill:Int,food_status:String)
    case openTable(table_id:Int)
    case discount(order_id:Int, branch_id:Int,food_discount_percent:Int, drink_discount_percent:Int, total_amount_discount_percent:Int, note:String)
    case moveTable(branch_id:Int, destination_table_id:Int,target_table_id:Int)
    case mergeTable(branch_id:Int, destination_table_id:Int,target_table_ids:[Int])
    case profile(branch_id:Int, employee_id:Int)
    case extra_charges(restaurant_brand_id:Int, branch_id:Int, status:Int)
    case addExtraCharge(branch_id:Int, order_id:Int, extra_charge_id:Int, name:String, price:Int, quantity:Int, note:String)
    case returnBeer(branch_id:Int, order_id:Int, quantity:Int, order_detail_id:Int, note:String)
    case reviewFood(order_id:Int, review_data:[Review])
    case getFoodsNeedReview(branch_id:Int, order_id:Int)
    case updateCustomerNumberSlot(branch_id:Int, order_id:Int, customer_slot_number:Int)
    case requestPayment(branch_id:Int, order_id:Int, payment_method:Int, is_include_vat:Int)
    case completedPayment(branch_id:Int, order_id:Int, cash_amount:Int, bank_amount:Int, transfer_amount:Int, payment_method_id:Int, tip_amount:Int)
    
    case tablesManagement(branchId:Int, area_id:Int, status:Int = -1)
    case createArea(branch_id:Int, area:Area)
    case foodsManagement(branch_id:Int, is_addition:Int, status:Int = -1, category_types:Int = -1, restaurant_kitchen_place_id:Int = -1)
    case categoriesManagement(brand_id:Int, status:Int = -1,category_types:String = "")
    case notesManagement(branch_id:Int, status:Int = -1)
    
    case createTable(branch_id:Int, table_id:Int, table_name:String, area_id:Int, total_slot:Int, status:Int, is_active:Int)
    
    case prints(branch_id:Int, is_have_printer:Int,is_print_bill:Int, status:Int = -1)
    
    case openSession(before_cash:Int, branch_working_session_id:Int)
    
    case workingSessions(branch_id:Int, empaloyee_id:Int)
    case checkWorkingSessions
    
    case sharePoint(order_id:Int, employee_list:[EmployeeSharePointRequest])
    case employeeSharePoint(branch_id:Int, order_id:Int)
    case currentPoint(employee_id:Int)
    
    case assignCustomerToBill(order_id:Int, qr_code:String)
    
    case fees(branch_id:Int, restaurant_budget_id:Int, from:String, to:String, type:Int, is_take_auto_generated:Int, order_session_id:Int, report_type:Int,addition_fee_statuses:String,is_paid_debt:Int = -1)
    
    case applyVAT(branch_id:Int, order_id:Int, is_apply_vat:Int)
    
    case createFee(branch_id:Int, type:Int, amount:Int, title:String, note:String, date:String, addition_fee_reason_type_id:Int)
    case foodsNeedPrint(order_id:Int)
    case requestPrintChefBar(order_id:Int, branch_id:Int, print_type:Int)
    
    case updateReadyPrinted(order_id:Int, order_detail_ids:[Int])
    
    case employees(branch_id:Int, is_for_share_point:Int)
    case kitchens(branch_id:Int, status:Int = 1)
    case updateKitchen(branch_id:Int, kitchen:Kitchen)
    case updatePrinter(printer:Kitchen)
    case createNote(branch_id:Int, noteRequest:NoteRequest, is_deleted:Int)
    case createCategory(name:String, code:String, description:String, categoryType:Int, status:Int)
    case ordersHistory(brand_id:Int, branch_id:Int,id:Int, report_type:Int, time : String, limit : Int, page : Int, key_search:String,is_take_away_table:Int,is_take_away:Int)
    case units
    case createFood(branch_id:Int, foodRequest:CreateFood)
    case generateFileNameResource(medias:[Media])
    case updateFood(branch_id:Int, foodRequest:CreateFood)
    case updateCategory(id:Int, name:String, code:String, description:String, categoryType:Int, status:Int)
    case cities(limit : Int = 200)
    case districts(city_id:Int ,limit : Int = 200)
    case wards(district_id:Int, limit : Int = 200)
    
    case updateProfile(profileRequest:ProfileRequest)
    case updateProfileInfo(infoRequest:UserInfoRequest)
    
    case changePassword(employee_id:Int, old_password:String, new_password:String, node_access_token:String)
    case closeTable(table_id:Int)
   
    case feedbackDeveloper(email:String, name:String, phone:String, type:Int, describe:String)
    case sentError(email:String, name:String, phone:String, type:Int, describe:String)
    case workingSessionValue
    case closeWorkingSession(closeWorkingSessionRequest:CloseWorkingSessionRequest)
    case assignWorkingSession(branch_id:Int, order_session_id:Int)
    case forgotPassword(username:String)
    case verifyOTP(restaurant_name:String, username:String, verify_code:String)
    case verifyPassword(username:String, verify_code:String, new_password:String)
    case notes(branch_id:Int)
    case gift(qr_code_gift:String = "", branch_id:Int)
    case useGift(branch_id:Int, order_id:Int, customer_gift_id:Int, customer_id:Int)
    case tablesManager(area_id:Int, branch_id:Int, status:Int, is_deleted:Int = 0)
    case notesByFood(food_id:Int, brand_id:Int = -1)
    case getVATDetail(order_id:Int, branch_id:Int)
    case cancelExtraCharge(branch_id:Int, order_id:Int, reason:String, order_extra_charge:Int, quantity:Int)
//    case vats
    
    //======== API REPORT ==========
    case report_revenue_by_time(restaurant_brand_id:Int, branch_id:Int,report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "")
    case report_revenue_activities_in_day_by_branch(restaurant_brand_id:Int, branch_id:Int,report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "")
    
    case report_revenue_fee_profit(restaurant_brand_id:Int, branch_id:Int,report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "")
    
    case report_revenue_by_category(restaurant_brand_id:Int, branch_id:Int,report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "")
    case report_revenue_by_employee(employee_id:Int, restaurant_brand_id:Int, branch_id:Int,report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "")
    
    case report_business_analytics(restaurant_brand_id:Int, branch_id:Int, category_id:Int, category_types:Int, report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "", is_cancelled_food:Int, is_combo:Int, is_gift:Int, is_goods:Int, is_take_away_food:Int)

    case report_revenue_by_all_employee(restaurant_brand_id:Int, branch_id:Int,report_type:Int, date_string:String = "", from_date:String = "", to_date:String = "")
    
    case report_food(
        restaurant_brand_id:Int,
        branch_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = "",
        category_id: Int,
        is_combo:Int,
        is_goods:Int,
        is_cancelled_food:Int,
        is_gift:Int,
        is_take_away_food:Int
    )
    
    case report_cancel_food(
        restaurant_brand_id:Int,
        branch_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = "",
        category_id: Int,
        is_combo:Int,
        is_goods:Int,
        is_cancelled_food:Int,
        is_gift:Int,
        is_take_away_food:Int
    )
    
    case report_gifted_food(
        restaurant_brand_id:Int,
        branch_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = "",
        category_id: Int,
        is_combo:Int,
        is_goods:Int,
        is_cancelled_food:Int,
        is_gift:Int,
        is_take_away_food:Int
    )
    
    case report_discount(
        restaurant_brand_id:Int,
        branch_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = ""
    )
    
    
    case report_VAT(
        restaurant_brand_id:Int,
        branch_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = ""
    )
    
    
    case report_area_revenue(
        restaurant_brand_id:Int,
        branch_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = ""
    )
    
    case report_table_revenue(
        restaurant_brand_id:Int,
        branch_id:Int,
        area_id:Int,
        report_type:Int,
        date_string:String,
        from_date:String = "",
        to_date:String = ""
    )
    
    
    case updateOtherFeed(id: Int, branch_id: Int, brand_id: Int, status: Int)
    
    case getAdditionFee(id:Int)
    case cancelAdditionFee(id:Int, cancel_reason:String, branch_id:Int ,addition_fee_status:Int)
    case updateAdditionFee(id:Int, date:String, note:String, amount:Int, is_count_to_revenue: Int, object_type:Int, type:Int, payment_method_id: Int , cancel_reason:String, branch_id: Int, object_name:String,addition_fee_status:Int,addition_fee_reason_type_id: Int)
    case updateOtherFee(id:Int, date:String, note:String, amount:Int, is_count_to_revenue: Int, payment_method_id: Int ,  branch_id: Int, object_name:String,addition_fee_status:Int,addition_fee_reason_type_id: Int)

    case moveExtraFoods(branch_id:Int, order_id:Int,target_order_id: Int, foods:[ExtraFoodSplitRequest])
    case getFoodsBookingStatus(order_id:Int)
    //API REPORT SEEMT
    case getReportOrderRestaurantDiscountFromOrder(restaurant_brand_id: Int, branch_id: Int, report_type: Int, date_string: String, from_date: String, to_date: String  ) //@ *2
    case getOrderReportFoodCancel(restaurant_brand_id:Int, branch_id:Int, type:Int, report_type:Int, date_string:String, from_date:String, to_date:String) //@ *3
    case getOrderReportFoodGift(restaurant_brand_id:Int, branch_id:Int, type_sort:Int, is_group:Int, report_type:Int, date_string:String, from_date:String, to_date:String) //@ *4
    case getOrderReportTakeAwayFood(restaurant_brand_id:Int, branch_id:Int, report_type:Int, date_string:String = "", food_id:Int, is_gift:Int, is_cancel_food:Int, key_search:String = "", from_date:String = "", to_date:String = "", page:Int, limit:Int) //@ *5
    case getRestaurantRevenueCostProfitEstimation(restaurant_brand_id:Int, branch_id: Int,report_type:Int,date_string:String,from_date:String,to_date:String) //@ *6
    case getOrderCustomerReport(restaurant_brand_id:Int, branch_id: Int, report_type:Int, date_string:String, from_date:String, to_date:String) //@*7
    case getRestaurantRevenueCostProfitSum(restaurant_brand_id:Int, branch_id: Int,report_type:Int,date_string:String,from_date:String,to_date:String) //@*8
    case getReportRevenueGenral(restaurant_brand_id: Int, branch_id: Int, report_type: Int, date_string: String, from_date: String, to_date: String) //@ *9
    case getReportRevenueArea(restaurant_brand_id: Int, branch_id: Int, report_type: Int, date_string: String, from_date: String, to_date: String) //@ *10
    case getReportRevenueProfitFood(restaurant_brand_id: Int, branch_id: Int, category_types: String, food_id: Int, is_goods: Int, report_type: Int, date_string:String, from_date:String, to_date: String) //@*11
    case getReportSurcharge(restaurant_brand_id: Int, branch_id: Int, report_type: Int, date_string:String, from_date:String, to_date: String) //@*12
    case getRestaurantOtherFoodReport(restaurant_brand_id: Int, branch_id: Int, category_types: String, food_id: Int, is_goods: Int, report_type: Int, date_string:String, from_date:String, to_date: String) //@*13
    case getRestaurantVATReport(restaurant_brand_id:Int, branch_id: Int, report_type:Int, date_string:String, from_date:String, to_date:String)//@*14
    // ========= API INVENTORY REPORT ==========
    case getWarehouseSessionImportReport(restaurant_brand_id:Int, branch_id: Int, report_type:Int, date_string:String, from_date:String, to_date:String) //@*15
    // ========= API REVENUE EMPLOYEE REPORT ==========
    case getRenueByEmployeeReport(restaurant_brand_id:Int, branch_id: Int, report_type:Int, date_string:String, from_date:String, to_date:String) //@*16
    case getRestaurantRevenueDetailByBrandId(restaurant_brand_id:Int,branch_id: Int,report_type:Int,from_date:String,to_date:String,date_string:String) //@ *17
    case getRestaurantRevenueDetailByBranch(restaurant_brand_id:Int,branch_id: Int,report_type:Int,from_date:String,to_date:String,date_string:String) //@ *18
    case getRestaurantRevenueCostProfitReality(restaurant_brand_id:Int, branch_id: Int,report_type:Int,date_string:String,from_date:String,to_date:String)//@
    case updateBranch(branchRequest: Branch)
    case getInfoBranches(IdBranches:Int)
    case healthCheckChangeDataFromServer(branch_id:Int, restaurant_brand_id:Int, restaurant_id:Int)
    
    
    case getLastLoginDevice(device_uid:String,app_type:Int)
    
    
    case postCreateOrder(branch_id:Int,table_id:Int,note:String)
    
    
    case getBranchRights(restaurant_brand_id:Int, employee_id:Int)
    
    case getTotalAmountOfOrders(restaurant_brand_id:Int,branch_id:Int,is_take_away_table:Int,order_status:String, key_search:String,employee_id:Int,is_take_away:Int,report_type:Int)
    
    case postApplyExtraChargeOnTotalBill(order_id:Int,branch_id:Int,total_amount_extra_charge_percent:Int)
    
    case postPauseService(order_id:Int, branch_id:Int,order_detail_id:Int)
    
    case postUpdateService(order_id:Int, branch_id:Int,order_detail_id:Int,start_time:String,end_time:String,note:String)
     
    case getActivityLog(object_id:Int,type:Int,key_search:String,object_type:String,from:String,to:String,page:Int,limit:Int)
    
    case postApplyOnlyCashAmount(branchId:Int)
    case getApplyOnlyCashAmount(branchId:Int)
    case getVersionApp(os_name: String, key_search: String, is_require_update: Int, limit: Int, page: Int)
    
    
    case postApplyTakeAwayTable(branch_id:Int)

    case postCreateTableList(branch_id:Int,area_id:Int,tables:[CreateTableQuickly])
    
    case getPrintItem(type_print:Int,restaurant_id:Int,branch_id:Int)
    
}
extension ManagerConections {
    
    var baseURL: URL {
        return URL(string: APIEndPoint.Name.GATEWAY_SERVER_URL)!
    }
    
    var path: String {
        switch self {
        case .sessions:
            return APIEndPoint.Name.urlSessions
            
        case .config:
            return APIEndPoint.Name.urlConfig
            
        case .orders(_, _, _, _,_):
            return APIEndPoint.Name.urlOrders
        case .checkVersion:
            return APIEndPoint.Name.urlCheckVersion
            
        case .regisDevice(_):
            return APIEndPoint.Name.urlRegisterDevice
        case .login(_, _):
            return APIEndPoint.Name.urlLogin
            
        case .setting(_):
            return APIEndPoint.Name.urlSetting
            
        case .areas(_, _):
            return APIEndPoint.Name.urlAreas
            
        case .tables(_, _, _, _, _):
            return APIEndPoint.Name.urlTables
            
        case .brands(_, _):
            return APIEndPoint.Name.urlBrands
        
        case .branches(_, _):
            return APIEndPoint.Name.urlBranches
            
        case .order(let order_id, _):
            return String(format: APIEndPoint.Name.urlOrder, order_id)
            
        case .foods(_,_,_,_,_,_,_,_,_,_):
            return APIEndPoint.Name.urlFoods
        
        case .addFoods(_, let  order_id, _, _):
            return String(format: APIEndPoint.Name.urlAddFoodsToOrder, order_id)
            
        case .addGiftFoods(_, let order_id, _, _):
            return String(format: APIEndPoint.Name.urlAddGiftFoodsToOrder, order_id)
            
        case .kitchenes(_, _, _):
            return APIEndPoint.Name.urlKitchenes
            
        case .vats:
            return APIEndPoint.Name.urlVAT
            
        case .addOtherFoods(_, let order_id, _):
            return String(format: APIEndPoint.Name.urlAddOtherFoodsToOrder, order_id)
            
        case .addNoteToOrderDetail(_, let order_detail_id, _):
            return String(format: APIEndPoint.Name.urlAddNoteToOrderDetail, order_detail_id)
            
            
        case .reasonCancelFoods(_):
            return APIEndPoint.Name.urlReasonCancelFoods
            
        case .cancelFood(_, let order_id, _, _, _):
            return String(format: APIEndPoint.Name.urlCancelFood, order_id)
            
        case .updateFoods(_, let order_id, _):
            return String(format: APIEndPoint.Name.urlUpdateFood, order_id)
            
        case .ordersNeedMove(_, let order_id, _):
            return String(format: APIEndPoint.Name.urlOrderNeedMove, order_id)
            
        case .moveFoods(_, _, _, _, _):
            let parameter = parameters! as NSDictionary
            let destination_table_id = parameter.object(forKey: "destination_table_id") as? Int // get order_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlMoveFoods, destination_table_id!)
            
        case .getOrderDetail(_, _, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "id") as? Int // get order_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlOrderDetailPayment, order_id!)
            
            
        case .openTable(_):
            let parameter = parameters! as NSDictionary
            let table_id = parameter.object(forKey: "table_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlOpenTable, table_id!)
            
        case .discount(let order_id,_,_,_,_,_):
            dLog(order_id)
            return String(format: APIEndPoint.Name.urlDiscount, order_id)
            
        case .moveTable(_, _, _):
            let parameter = parameters! as NSDictionary
            let destination_table_id = parameter.object(forKey: "id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlMoveTable, destination_table_id!)
            
        case .mergeTable(_, _, _):
            let parameter = parameters! as NSDictionary
            let destination_table_id = parameter.object(forKey: "destination_table_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlMergeTable, destination_table_id!)
            
        case .profile(_, _):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlProfile, employee_id!)
            
            
        case .extra_charges(_, _, _):
            return APIEndPoint.Name.urlExtraCharges
            
        case .addExtraCharge(_, _, _, _, _, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlAddExtraCharges, order_id!)
            
            
        case .returnBeer(_, _, _, _, _):
            let parameter = parameters! as NSDictionary
            let branch_id = parameter.object(forKey: "branch_id") as? Int // get table_id from dictionary parameters
            let order_id = parameter.object(forKey: "id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlReturnBeer, order_id!)
            
            
        case .reviewFood(_, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlReviewFood, order_id!)
            
        case .getFoodsNeedReview(_, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlGetFoodsNeedReview, order_id!)
            
        case .updateCustomerNumberSlot(_, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlUpdateCustomerNumberSlot, order_id!)
            
        case .requestPayment(_, _, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlRequestPayment, order_id!)
            
        case .completedPayment(_, _, _, _, _, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlCompletedPayment, order_id!)
            
        case .tablesManagement(_, _, _):
            return APIEndPoint.Name.urlTablesManagement
            
        case .createArea(_, _):
            return APIEndPoint.Name.urlCreateArea

        case .foodsManagement(_, _, _, _, _):
            return APIEndPoint.Name.urlAllFoodsManagement

            
        case .categoriesManagement(_,_,_):
            return APIEndPoint.Name.urlAllCategoriesManagement
            
        case .notesManagement(_, _):
            return APIEndPoint.Name.urlAllNotesManagement
            
        case .createTable(_, _, _, _, _, _, _):
            return APIEndPoint.Name.urlTablesManagement
            
      
        case .prints(_, _, _, _):
            return APIEndPoint.Name.urlPrinters
            
        case .openSession(_, _):
            return APIEndPoint.Name.urlOpenWorkingSession
            
        case .workingSessions(_, _):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "employee_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlWorkingSession, employee_id!)
            
            
        case .checkWorkingSessions:
            return APIEndPoint.Name.urlCheckWorkingSessions
            
        case .sharePoint(_, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlSharePoint, order_id!)
            
        case .employeeSharePoint(_, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlSharePoint, order_id!)
            
        case .currentPoint(_):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "employee_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlCurrentPoint, employee_id!)
            
        case .assignCustomerToBill(_, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get table_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlAssignCustomerToBill, order_id!)
            
        case .applyVAT(_, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "order_id") as? Int // get order_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlApplyVAT, order_id!)
            
        case .fees(_, _, _, _, _, _, _, _, _, _):
            return APIEndPoint.Name.urlFees
            
        case .createFee(_, _, _, _, _, _, _):
            return APIEndPoint.Name.urlCreateFee
            
        case .foodsNeedPrint(_):
            return APIEndPoint.Name.urlFoodsNeedPrint
            
        case .requestPrintChefBar(_, _, _):
            let parameter = parameters! as NSDictionary
            let order_id = parameter.object(forKey: "id") as? Int // get order_id from dictionary parameters
          
            return String(format: APIEndPoint.Name.urlRequestPrintChefBar, order_id!)
            
        case .updateReadyPrinted(_, _):
            return APIEndPoint.Name.urlUpdateReadyPrinted
            
        case .employees(_, _):
            return APIEndPoint.Name.urlEmployees
            
        case .kitchens(_, _):
            return APIEndPoint.Name.urlKitchens
            
        case .updateKitchen(_, _):
            let parameter = parameters! as NSDictionary
            let restaurant_kitchen_place_id = parameter.object(forKey: "id") as? Int // get restaurant_kitchen_place_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlUpdateKitchen, restaurant_kitchen_place_id!)
            
        case .updatePrinter(_):
            let parameter = parameters! as NSDictionary
            let printer_id = parameter.object(forKey: "id") as? Int // get restaurant_kitchen_place_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlUpdatePrinter, printer_id!)
            
        case .createNote(_, _, _):
            return APIEndPoint.Name.urlCreateUpdateNote
            
        case .createCategory(_, _, _, _, _):
            return APIEndPoint.Name.urlCreateCategory
            
        case .ordersHistory(_, _, _, _, _, _,_,_,_,_):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "id") as? Int // get restaurant_kitchen_place_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlOrdersHistory, employee_id!)
            
        case .units:
            return APIEndPoint.Name.urlUnits
            
        case .createFood(_, _):
            return APIEndPoint.Name.urlCreateFood
            
            
        case .generateFileNameResource(_):
            return APIEndPoint.Name.urlGenerateLink
            
        case .updateFood(_, _):
            let parameter = parameters! as NSDictionary
            let food_id = parameter.object(forKey: "id") as? Int // get restaurant_kitchen_place_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlEditFood, food_id!)
            
        case .updateCategory(_, _, _, _, _, _):
            let parameter = parameters! as NSDictionary
            let id = parameter.object(forKey: "id") as? Int // get restaurant_kitchen_place_id from dictionary parameters
            return String(format: APIEndPoint.Name.urlUpdateCategory, id!)
            
        case .cities:
            return APIEndPoint.Name.urlCities
            
            
        case .districts(_, _):
            let parameter = parameters! as NSDictionary
            let city_id = parameter.object(forKey: "city_id") as? Int
            return String(format: APIEndPoint.Name.urlDistrict, city_id!)
            
        case .wards(_, _):
            let parameter = parameters! as NSDictionary
            let district_id = parameter.object(forKey: "district_id") as? Int
            return String(format: APIEndPoint.Name.urlWards, district_id!)
            
        case .updateProfile(_):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "employee_id") as? Int
            return String(format: APIEndPoint.Name.urlUpdateProfile, employee_id!)
            
        case .updateProfileInfo(_):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "employee_id") as? Int
            return String(format: APIEndPoint.Name.urlUpdateProfileInfo, employee_id!)
            
            
        case .changePassword(_, _, _, _):
            let parameter = parameters! as NSDictionary
            let employee_id = parameter.object(forKey: "id") as? Int
            return String(format: APIEndPoint.Name.urlChangePassword, employee_id!)
            
        case .closeTable(_):
            let parameter = parameters! as NSDictionary
            let table_id = parameter.object(forKey: "id") as? Int
            return String(format: APIEndPoint.Name.urlCloseTable, table_id!)
            
            
        case .feedbackDeveloper(_, _, _, _, _):
            return  APIEndPoint.Name.urlFeedbackAndSentError
            
        case .sentError(_, _, _, _, _):
            return APIEndPoint.Name.urlFeedbackAndSentError
            
            
        case .workingSessionValue:
            return APIEndPoint.Name.urlWorkingSessionValue
            
        case .closeWorkingSession(_):
            return APIEndPoint.Name.urlCloseWorkingSession
            
        case .assignWorkingSession(_, _):
            return APIEndPoint.Name.urlAssignWorkingSession
            
        case .forgotPassword(_):
            return APIEndPoint.Name.urlForgotPassword
            
        case .verifyOTP(_, _, _):
            return APIEndPoint.Name.urlVerifyOTP
            
        case .verifyPassword(_, _, _):
            return APIEndPoint.Name.urlVerifyPassword
            
        case .notes(_):
            return APIEndPoint.Name.urlNotes
            
        case .gift(_, _):
            return APIEndPoint.Name.urlGift
            
        case .useGift(_, _, _, _):
            
            let parameter = parameters! as NSDictionary
           
            let order_id = parameter.object(forKey: "orderId") as? Int
            
            return String(format: APIEndPoint.Name.urlUseGift, order_id!)
            
            
        case .tablesManager(_, _, _, _):
        return APIEndPoint.Name.urlTableManage
            
            
        case .notesByFood(_, _):
            let parameter = parameters! as NSDictionary
            let order_detail_id = parameter.object(forKey: "food_id") as? Int
            
        return String(format: APIEndPoint.Name.urlNotesByFood, order_detail_id!)
       
        case .getVATDetail(let order_id, _):
//            let parameter = parameters! as NSDictionary
//            let order_id = parameter.object(forKey: "order_id") as? Int
            return String(format: APIEndPoint.Name.urlVATDetails,order_id)

            //=========== API REPORT ========
            
        case .report_revenue_by_time(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportRevenueByTime
            
            
        case .report_revenue_activities_in_day_by_branch(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportRevenueByBrand
            
        case .report_revenue_fee_profit(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportRevenueFeeProfit
            
        case .report_revenue_by_category(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportRevenueByCategory
            
        case .report_revenue_by_employee(_, _, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportRevenueByEmployee
            
        case .report_business_analytics(_, _, _, _, _, _, _, _, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportBusinessAnalytics
       
            
            
        case .report_revenue_by_all_employee(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportRevenueByAllEmployees
            
        case .cancelExtraCharge(branch_id: let branch_id, order_id: let order_id, reason: let reason, order_extra_charge: let order_extra_charge, let quantity):
            return String(format: APIEndPoint.Name.urlCancelExtraCharge, order_id)
            
        case .report_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportFoods
            
        case .report_cancel_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportCancelFoods
            
        case .report_gifted_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportGiftedFoods
            
        case .report_discount(_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportDiscount
            
        case .report_VAT(_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportVAT
            
            
        case .report_area_revenue(_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportAreaRevenue
            
        case .report_table_revenue(_,_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlReportTableRevenue
        
        case .updateOtherFeed(let id, _,_,_):
            return String(format: APIEndPoint.Name.urlUpdateOtherFeed, id)
            
        case .getAdditionFee(let id):
            return String(format: APIEndPoint.Name.urlGetAdditionFee, id)
            
        case .updateAdditionFee(let id,_,_,_,_,_,_,_,_,_,_,_,_):
            return String(format: APIEndPoint.Name.urlUpdateAdditionFee, id)
            
        case .cancelAdditionFee(let id,_,_,_):
            return String(format: APIEndPoint.Name.urlCancelAdditionFee, id)
            
        case .updateOtherFee(let id,_,_,_,_,_,_,_,_,_):
            return String(format: APIEndPoint.Name.urlUpdateOtherFee, id)
            
        case .moveExtraFoods(_,let order_id,_,_):

            return String(format: APIEndPoint.Name.urlMoveExtraFoods, order_id)
            
        case .getFoodsBookingStatus(let order_id):
            return String(format: APIEndPoint.Name.urlGetFoodsBookingStatus, order_id)
            
        case .updateBranch(let branch):
            return String(format: APIEndPoint.Name.urlUpdateBranch, branch.id)
        //API REPORT SEEMT
            
        case .getReportOrderRestaurantDiscountFromOrder(_, _, _, _, _, _):
            return  APIEndPoint.NameReportEndPoint.urlReportOrderRestaurantDiscountFromOrder
            
        case .getOrderReportFoodCancel(_, _, _, _, _, _, _):
            return String(format: APIEndPoint.NameReportEndPoint.urlOrderReportFoodCancel)
            
        case .getOrderReportFoodGift(_, _, _, _, _, _, _, _):
            return String(format: APIEndPoint.NameReportEndPoint.urlOrderReportFoodGift)//@
            
        case .getOrderReportTakeAwayFood(_, _, _, _, _, _, _, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlOrderReportFoodTakeAway
            
        case .getRestaurantRevenueCostProfitEstimation(_,_,_,_,_,_):
            return String(format: APIEndPoint.NameReportEndPoint.urlGetRestaurantRevenueCostProfitEstimation)
            
        case .getOrderCustomerReport(_,_,_,_,_,_):
            return String(format: APIEndPoint.NameReportEndPoint.urlOrderCustomerReport)
            
        case .getReportRevenueGenral(_, _, _, _, _, _):
            return  APIEndPoint.NameReportEndPoint.urlReportRevenueGenral
            
        case .getReportRevenueArea(_, _, _, _, _, _):
            return  APIEndPoint.NameReportEndPoint.urlReportRevenueArea
            
        case .getReportSurcharge(_, _, _, _, _, _):
            return String(format: APIEndPoint.NameReportEndPoint.urlReportSurcharge)
            
        case .getReportRevenueProfitFood(_, _, _, _, _, _, _, _, _):
            return  APIEndPoint.NameReportEndPoint.urlReportRevenueProfitFood
            
        case .getRestaurantOtherFoodReport(_, _, _, _, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlReportOtherFood
            
        case .getRestaurantVATReport(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlRestaurantVATReport
            
        case .getWarehouseSessionImportReport(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlWarehouseSessionImportReport
            
        case .getRenueByEmployeeReport(_, _, _, _, _, _):
            return APIEndPoint.NameReportEndPoint.urlRenueByEmployeeReport
            
        case .getRestaurantRevenueDetailByBrandId(_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlGetRevenueDetailByBrandId
            
        case .getRestaurantRevenueDetailByBranch(_,_,_,_,_,_):
            return APIEndPoint.NameReportEndPoint.urlGetRevenueDetailByBranch
            
        case .getRestaurantRevenueCostProfitSum(_,_,_,_,_,_):
            return String(format: APIEndPoint.NameReportEndPoint.urlGetRestaurantRevenueCostProfitSum)
            
        case .getRestaurantRevenueCostProfitReality(_,_,_,_,_,_):
            return String(format: APIEndPoint.NameReportEndPoint.urlGetRestaurantRevenueCostProfitReality)
            
        case .getInfoBranches(let IdBranches):
            return String(format: APIEndPoint.Name.urlBranchesInfo,IdBranches)
            
        case .healthCheckChangeDataFromServer(_,_,_):
            return APIEndPoint.Name.urlHealthCheckChangeFromServer
            
            
        case .getLastLoginDevice(_,_):
             return APIEndPoint.Name.urlGetLastLoginDevice
            
        case .postCreateOrder(_,_,_):
            return APIEndPoint.Name.urlPostCreateOrder
            
        
        case .getBranchRights(_,_):
            return APIEndPoint.Name.urlgetBranchRights
            
            
        case .getTotalAmountOfOrders(_,_,_,_,_,_,_,_):
            return APIEndPoint.Name.urlGetTotalAmountOfOrders
        
        case .postApplyExtraChargeOnTotalBill(let order_id,_,_):
            return String(format: APIEndPoint.Name.urlPostApplyExtraChargeOnTotalBill, order_id)
            
         
        case .postPauseService(let order_id,_,_):
            return String(format: APIEndPoint.Name.urlPostPauseService, order_id)
        case .postUpdateService(let order_id,_,_,_,_,_):
            return String(format: APIEndPoint.Name.urlPostUpdateService, order_id)
        
            
        case .getActivityLog(_,_,_,_,_,_,_,_):
            return APIEndPoint.Name.urlGetActivityLog
            
        case .postApplyOnlyCashAmount(let branchId):
            return String(format: APIEndPoint.Name.urlPostApplyOnlyCashAmount, branchId)
        case .getApplyOnlyCashAmount(let branchId):
            return String(format: APIEndPoint.Name.urlGetApplyOnlyCashAmount, branchId)
            
        case .getVersionApp(_, _, _, _, _):
            return APIEndPoint.Name.urlInformationApp
            
        case .postApplyTakeAwayTable(let branch_id):
            return String(format: APIEndPoint.Name.urlPostApplyTakeAwayTable, branch_id)
            
        case .postCreateTableList(_,_,_):
            return APIEndPoint.Name.urlPostCreateTableList
            
        case .getPrintItem(_,_,_):
            return APIEndPoint.Name.urlGetPrintItem
            
            
            
        }
   
    }
    
    
    var method: Moya.Method {
        switch self {
        case .sessions:
            return .get
        case .config(_):
            return .get
        case .checkVersion:
            return .get
        case .regisDevice(_):
            return .post
        case .login(_, _):
            return .post
        case .setting(_):
            return .get
        case .areas(_, _):
            return .get
        case .tables(_, _, _, _, _):
            return .get
        case .brands(_, _):
            return .get
        case .branches(_, _):
            return .get
        case .orders(_, _, _, _,_):
            return .get
        case .order(_, _):
            return .get
        case .foods(_,_,_,_,_,_,_,_,_,_):
            return .get
        case .addFoods(_, _, _, _):
            return .post
        case .addGiftFoods(_, _, _, _):
            return .post
        case .kitchenes(_, _, _):
            return .get
        case .vats:
            return .get
        case .addOtherFoods(_, _, _):
            return .post
        case .addNoteToOrderDetail(_, _, _):
            return .post
        case .reasonCancelFoods(_):
            return .get
        case .cancelFood(_, _, _, _, _):
            return .post
        case .ordersNeedMove(_, _, _):
            return .get
        case .updateFoods(_, _, _):
            return .post
            
        case .moveFoods(_, _, _, _, _):
            return .post
        case .getOrderDetail(_, _, _, _):
            return .get
        case .openTable(_):
            return .post
        case .discount(_,_,_,_,_,_):
            return .post
        case .moveTable(_, _, _):
            return .post
        case .mergeTable(_, _, _):
            return .post
        case .profile(_, _):
            return .get
        case .extra_charges(_, _, _):
            return .get
        case .addExtraCharge(_, _, _,_, _, _, _):
            return .post
        case .returnBeer(_, _, _, _, _):
            return .post
        case .reviewFood(_, _):
            return .post
            
        case .getFoodsNeedReview(_, _):
            return .get
        case .updateCustomerNumberSlot(_, _, _):
            return .post
        case .requestPayment(_, _, _, _):
            return .post
        case .completedPayment(_, _, _, _, _, _, _):
            return .post
            
        case .tablesManagement(_, _, _):
            return .get
        case .createArea(_, _):
            return .post
            
        case .foodsManagement(_, _, _, _, _):
            return .get

        case .categoriesManagement(_,_,_):
            return .get
        case .notesManagement(_, _):
            return .get
        case .createTable(_, _, _, _, _, _, _):
            return .post
        case .prints(_, _, _, _):
            return .post
        case .openSession(_, _):
            return .post
            
        case .workingSessions(_, _):
            return .get
        case .checkWorkingSessions:
            return .get
        case .sharePoint(_, _):
            return .post
        case .employeeSharePoint(_, _):
            return .get
        case .currentPoint(_):
            return .get
        case .assignCustomerToBill(_, _):
            return .post
        case .applyVAT(_, _, _):
            return .post
        case .fees(_, _, _, _, _, _, _, _, _, _):
            return .get
        case .createFee(_, _, _, _, _, _, _):
            return .post
        case .foodsNeedPrint(_):
            return .get
        case .requestPrintChefBar(_, _, _):
            return .post
        case .updateReadyPrinted(_, _):
            return .post
        case .employees(_, _):
            return .get
        case .kitchens(_, _):
            return .get
        case .updateKitchen(_, _):
            return .post
        case .updatePrinter(_):
            return .post
        case .createNote(_, _, _):
            return .post
        case .createCategory(_, _, _, _, _):
            return .post
        case .ordersHistory(_, _, _, _, _, _,_,_,_,_):
            return .get
        case .units:
            return .get
        case .createFood(_, _):
            return .post
        case .generateFileNameResource(_):
            return .post
        case .updateFood(_, _):
            return .post
        case .updateCategory(_, _, _, _, _, _):
            return .post
        case .cities(_):
            return .get
            
        case .districts(_,_):
            return .get
        case .wards(_,_):
            return .get
            
        case .updateProfile(_):
            return .post
            
        case .updateProfileInfo(_):
            return .post
        case .changePassword(_, _, _, _):
            return .post
            
        case .closeTable(_):
            return .post
            
        case .feedbackDeveloper(_, _, _, _, _):
            return .post
        case .sentError(_, _, _, _, _):
            return .post
        case .workingSessionValue:
            return .get
        case .closeWorkingSession(_):
            return .post
        case .assignWorkingSession(_, _):
            return .post
        case .forgotPassword(_):
            return .post
            
        case .verifyOTP(_, _, _):
            return .post
            
        case .verifyPassword(_, _, _):
            return .post
        case .notes(_):
            return .get
        case .gift(_, _):
            return .get
        case .useGift(_, _, _, _):
            return .post
        case .tablesManager(_, _, _,_):
            return .get
        case .notesByFood(_, _):
            return .get
        case .getVATDetail(_, _):
            return .get
            //=========== API REPORT ========
        case .report_revenue_by_time(_, _, _, _, _, _):
            return .get
        case .report_revenue_activities_in_day_by_branch(_, _, _, _, _, _):
            return .get
            
        case .report_revenue_fee_profit(_, _, _, _, _, _):
            return .get
        case .report_revenue_by_category(_, _, _, _, _, _):
            return .get
        case .report_revenue_by_employee(_, _, _, _, _, _, _):
            return .get
        case .report_business_analytics(_, _, _, _, _, _, _, _, _, _, _, _, _):
            return .get
        case .report_revenue_by_all_employee(_, _, _, _, _, _):
            return .get
      
        case .cancelExtraCharge(branch_id: let branch_id, order_id: let order_id, reason: let reason, order_extra_charge: let order_extra_charge, let quantity):
            return .post
            
        case .report_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return .get
        case .report_cancel_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return .get
        case .report_gifted_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return .get
        case .report_discount(_,_,_,_,_,_):
            return .get
        case .report_VAT(_,_,_,_,_,_):
            return .get
        case .report_area_revenue(_,_,_,_,_,_):
            return .get
        case .report_table_revenue(_,_,_,_,_,_,_):
            return .get
            
        case .updateOtherFeed(_, _, _, _):
            return .get
            
        case .getAdditionFee(_):
            return .get
        case .updateAdditionFee(_,_,_,_,_,_,_,_,_,_,_,_,_):
            return .post
        case .cancelAdditionFee(_, _, _, _):
            return .post

        case .updateOtherFee(_,_,_,_,_,_,_,_,_,_):
            return .post

        case .moveExtraFoods(branch_id: let branch_id, order_id: let order_id, target_order_id: let target_order_id, foods: let foods):
            return .post
        case .getFoodsBookingStatus(_):
            return .get
        case .updateBranch(_):
            return .post
            
        //API REPORT SEEMT
        case .getReportOrderRestaurantDiscountFromOrder(_, _, _, _, _, _):
            return .get //@
            
        case .getOrderReportFoodCancel(_, _, _, _, _, _, _):
            return .get //@
        case .getOrderReportFoodGift(_, _, _, _, _, _, _, _):
            return .get//@
            
        case .getRestaurantRevenueCostProfitEstimation(_,_,_,_,_,_):
            return .get
            
        case .getOrderReportTakeAwayFood(_, _, _, _, _, _, _, _, _, _, _, _):
            return .get
            
        case .getOrderCustomerReport(_,_,_,_,_,_):
            return .get
        case .getReportRevenueGenral(_, _, _, _, _, _):
            return .get
            
        case .getReportRevenueArea(_, _, _, _, _, _):
            return .get
            
        case .getReportSurcharge(_, _, _, _, _, _):
            return .get
            
        case .getReportRevenueProfitFood(_, _, _, _, _, _, _, _, _):
            return .get
            
        case .getRestaurantOtherFoodReport(_, _, _, _, _, _, _, _, _):
            return .get
            
        case .getRestaurantVATReport(_, _, _, _, _, _):
            return .get
            
        case .getWarehouseSessionImportReport(_, _, _, _, _, _):
            return .get
            
        case .getRenueByEmployeeReport(_, _, _, _, _, _):
            return .get//@
            
        case .getRestaurantRevenueDetailByBrandId(_,_,_,_,_,_):
            return .get
            
        case .getRestaurantRevenueDetailByBranch(_,_,_,_,_,_):
            return .get
            
        case .getRestaurantRevenueCostProfitSum(_,_,_,_,_,_):
            return .get
            
        case .getRestaurantRevenueCostProfitReality(_,_,_,_,_,_):
            return .get
            
        case .getInfoBranches(_):
            return .get
        case .healthCheckChangeDataFromServer(_,_,_):
            return .get
            
        case .getLastLoginDevice(_,_):
            return .get
            
        case .postCreateOrder(_,_,_):
            return .post
            
        case .getBranchRights(_,_):
            return .get
            
        case .getTotalAmountOfOrders(_,_,_,_,_,_,_,_):
            return .get
         
        case .postApplyExtraChargeOnTotalBill(_,_,_):
            return .post
        
        case .postPauseService(_,_,_):
            return .post
            
        case .postUpdateService(_,_,_,_,_,_):
            return .post
        
        case .getActivityLog(_,_,_,_,_,_,_,_):
            return .get
            
        case .postApplyOnlyCashAmount(_):
            return .post
        case  .getApplyOnlyCashAmount(_):
            return .get
            
        case .getVersionApp(_, _, _, _, _):
            return .get
            
        case .postApplyTakeAwayTable(_):
            return .post
            
        case .postCreateTableList(_,_,_):
            return .post
            
        case .getPrintItem(_,_,_):
            return .get
        }
    }
    
    func headerJava(ProjectId:Int = Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method:Int = Constants.METHOD_TYPE.GET) -> [String : String]{
        
        var projectId =  Constants.PROJECT_IDS.PROJECT_ID_ORDER

        if(ProjectId == projectId){
            if(ManageCacheObject.getSetting().branch_type ==  BRANCH_TYPE_LEVEL_ONE){
                projectId =  Constants.PROJECT_IDS.PROJECT_ID_ORDER_SMALL
            }else{
                projectId =  Constants.PROJECT_IDS.PROJECT_ID_ORDER
            }
        }else{
            projectId = ProjectId
        }
        
        if  ManageCacheObject.isLogin(){
            return ["Authorization": String(format: "Bearer %@", ManageCacheObject.getCurrentUser().access_token), "ProjectId":String(format: "%d", projectId), "Method":String(format: "%d", Method)]
        }else{
            if ManageCacheObject.getConfig().api_key != nil{
                return ["Authorization": String(format: "Basic %@", ManageCacheObject.getConfig().api_key), "ProjectId":String(format: "%d", projectId), "Method":String(format: "%d", Method)]
            }else{
                return ["ProjectId":String(format: "%d", projectId), "Method":String(format: "%d", Method)]
            }

        }
    }
    
    func headerNode(ProjectId:Int = Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method:Int = Constants.METHOD_TYPE.GET) -> [String : String]{
        if  ManageCacheObject.isLogin(){
            return ["Authorization": String(format: "Bearer %@", ManageCacheObject.getCurrentUser().access_token), "ProjectId":String(format: "%d", ProjectId), "Method":String(format: "%d", Method)]
        }else{
            return ["Authorization": String(format: "%@", ManageCacheObject.getConfig().api_key), "ProjectId":String(format: "%d", ProjectId), "Method":String(format: "%d", Method)]
            
        }
    }
    
   
    
    var headers: [String : String]? {
        switch self {
        case .sessions:
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.GET)
        case .config(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.GET)
        case .checkVersion:
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.GET)
        case .regisDevice(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.POST)
        case .login(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.POST)
        case .setting(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.GET)
        case .areas(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .tables(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .brands(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .branches(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_DASHBOARD, Method: Constants.METHOD_TYPE.GET)
        case .orders(_, _, _, _,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .order(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .foods(_,_,_,_,_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .addFoods(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .addGiftFoods(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .kitchenes(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .vats:
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
            
        case .addOtherFoods(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .addNoteToOrderDetail(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .reasonCancelFoods(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .cancelFood(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .updateFoods(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .ordersNeedMove(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .moveFoods(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .getOrderDetail(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .openTable(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .discount(_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .moveTable(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .mergeTable(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .profile(_, _):
            return headerJava()
        case .extra_charges(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .addExtraCharge(_, _, _,_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .returnBeer(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .reviewFood(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .getFoodsNeedReview(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .updateCustomerNumberSlot(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .requestPayment(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .completedPayment(_, _, _, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .tablesManagement(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .createArea(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .foodsManagement(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)

        case .categoriesManagement(_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .notesManagement(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .createTable(_, _, _, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .prints(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .openSession(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .workingSessions(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_DASHBOARD, Method: Constants.METHOD_TYPE.GET)
        case .checkWorkingSessions:
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_DASHBOARD, Method: Constants.METHOD_TYPE.GET)
        case .sharePoint(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .employeeSharePoint(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .currentPoint(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .assignCustomerToBill(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .applyVAT(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .fees(_, _, _, _, _, _, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .createFee(_, _, _, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .foodsNeedPrint(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .requestPrintChefBar(_,_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .updateReadyPrinted(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .employees(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .kitchens(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .updateKitchen(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .updatePrinter(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .createNote(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .createCategory(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .ordersHistory(_, _, _, _, _, _,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .units:
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .createFood(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .generateFileNameResource(_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_UPLOAD_SERVICE, Method: Constants.METHOD_TYPE.POST)
            
        case .updateFood(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .cities(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .updateCategory(_, _, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .districts(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .wards(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
            
        case .updateProfile(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .updateProfileInfo(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .changePassword(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .closeTable(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .feedbackDeveloper(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .sentError(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .workingSessionValue:
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
            
        case .closeWorkingSession(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .assignWorkingSession(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .forgotPassword(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.POST)
            
        case .verifyOTP(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.POST)
        case .verifyPassword(_, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.POST)
        case .notes(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .gift(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .useGift(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .tablesManager(_, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
            
        case .notesByFood(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .getVATDetail(_, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
            //=========== API REPORT ========
        case .report_revenue_by_time(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_revenue_activities_in_day_by_branch(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_revenue_fee_profit(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_revenue_by_category(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_revenue_by_employee(_, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_business_analytics(_, _, _, _, _, _, _, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
            
        case .report_revenue_by_all_employee(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .cancelExtraCharge(branch_id: let branch_id, order_id: let order_id, reason: let reason, order_extra_charge: let order_extra_charge, let quantity):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .report_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_cancel_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_gifted_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_discount(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_VAT(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_area_revenue(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
        case .report_table_revenue(_,_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
            
            
        case .updateOtherFeed(_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .getAdditionFee(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .updateAdditionFee(_,_,_,_,_,_,_,_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .cancelAdditionFee(_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .updateOtherFee(_,_,_,_,_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
 
        case .moveExtraFoods(branch_id: let branch_id, order_id: let order_id, target_order_id: let target_order_id, foods: let foods):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        case .getFoodsBookingStatus(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        case .updateBranch(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
          // API REPORT SEEMT
        case .getReportOrderRestaurantDiscountFromOrder(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)//@
            
        case .getOrderReportFoodCancel(_, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)//@
            
        case .getOrderReportFoodGift(_, _, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)
            
        case .getRestaurantRevenueCostProfitEstimation(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)
            
        case .getOrderCustomerReport(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)
            
        case .getReportRevenueGenral(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT, Method: Constants.METHOD_TYPE.GET)
            
        case .getReportRevenueArea(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
            
        case .getReportSurcharge(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)
            
        case .getReportRevenueProfitFood(_, _, _, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT, Method: Constants.METHOD_TYPE.GET)
            
        case .getRestaurantOtherFoodReport(_, _, _, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)
            
        case .getRestaurantVATReport(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)
            
        case .getWarehouseSessionImportReport(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT)
            
        case .getRenueByEmployeeReport(_, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT)
            
        case .getRestaurantRevenueDetailByBrandId(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT)
            
        case .getRestaurantRevenueDetailByBranch(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT)
            
        case .getRestaurantRevenueCostProfitSum(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT)
            
        case .getOrderReportTakeAwayFood(_, _, _, _, _, _, _, _, _, _, _, _):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_BUSINESS_REPORT)//@
            
        case .getRestaurantRevenueCostProfitReality(_,_,_,_,_,_):
            return headerNode(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_FINANCE_REPORT)
            
        case .getInfoBranches(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
            
        case .healthCheckChangeDataFromServer(_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_HEALTH_CHECK_SERVICE, Method: Constants.METHOD_TYPE.GET)
            
        case .getLastLoginDevice(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_OAUTH, Method: Constants.METHOD_TYPE.GET)
            
        case .postCreateOrder(_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
            
            
        case .getBranchRights(_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_DASHBOARD, Method: Constants.METHOD_TYPE.GET)
            
            
        case .getTotalAmountOfOrders(_,_,_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.GET)
        
        case .postApplyExtraChargeOnTotalBill(_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
            
        case .postPauseService(_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .postUpdateService(_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
        
        case .getActivityLog(_,_,_,_,_,_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_LOG, Method: Constants.METHOD_TYPE.GET)
        
        case .postApplyOnlyCashAmount(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_DASHBOARD, Method: Constants.METHOD_TYPE.POST)
        case  .getApplyOnlyCashAmount(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_DASHBOARD, Method: Constants.METHOD_TYPE.GET)
            
        case .getVersionApp(_, _, _, _, _):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_VERSION_APP)
       
        case .postApplyTakeAwayTable(_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .postCreateTableList(_,_,_):
            return headerJava(ProjectId: Constants.PROJECT_IDS.PROJECT_ID_ORDER, Method: Constants.METHOD_TYPE.POST)
            
        case .getPrintItem(_,_,_):
            return headerJava(ProjectId: 1407, Method: Constants.METHOD_TYPE.GET)
        }
        
        
    }
    var parameters: [String: Any]? {
        switch self {
        case .sessions:
            return [ "device_uid":Utils.getUDID()]
            
        case .config(let restaurant_name):
            return ["project_id": Constants.apiKey, "device_uid": Utils.getUDID(), "restaurant_name": restaurant_name]

        case .checkVersion:
            return ["os_name":Utils.getOSName()]
            
            
        case .regisDevice(let deviceRequest):
            return ["device_uid": deviceRequest.device_uid, "push_token": deviceRequest.push_token, "app_type": deviceRequest.app_type, "os_name":Utils.getOSName(), "platform_type":Utils.getPlatFormType()]
            
        case .login(let username, let password):
            return ["username": username, "password": Utils.encoded(str: password), "device_uid":Utils.getUDID(), "app_type":Utils.getAppType(), "push_token": ManageCacheObject.getPushToken()]
            
        case .setting(let branch_id):
            return ["branch_id": branch_id, "udid":Utils.getUDID(), "app_type":Utils.getAppType()]
            
        case .areas(let branch_id, let status):
            return ["branch_id": branch_id, "status": status]
            
        case .tables(let branch_dd, let area_id, let status, let exclude_table_id, let order_statuses):
            return ["branch_id": branch_dd, "area_id": area_id, "status":status, "exclude_table_id":exclude_table_id, "order_statuses":order_statuses, "is_active": ""]
            
        case .brands(let key_search, let status):
            return ["key_search": key_search, "status":status]
            
        case .branches(let brand_id, let status):
            return ["restaurant_brand_id": brand_id, "status": status]
            
        case .orders(let userId, let order_status, let key_word, let branch_id,let is_take_away):
            return ["employee_id": userId, "order_status": order_status, "key_word": key_word, "branch_id":branch_id, "is_take_away":is_take_away]
            
        case .order(let order_id, let branch_id):
            return ["id": order_id, "branch_id": branch_id]
            
        case .foods(let branch_id, let area_id, let category_id, let category_type, let is_allow_employee_gift, let is_sell_by_weight, let is_out_stock, let keyword, let limit, let page):
            
            return [
                "branch_id":branch_id,
                "area_id": area_id,
                "category_id": category_id,
                "category_type": category_type,
                "is_allow_employee_gift": is_allow_employee_gift,
                "is_sell_by_weight": is_sell_by_weight,
                "is_out_stock": is_out_stock,
                "key_search": keyword,
                "is_get_restaurant_kitchen_place": ALL,
                "status":ACTIVE,
                "limit": limit,
                "page": page
            ]
            
        case .addFoods(let branch_id, let order_id, let foods, let is_use_point):
            
            return ["branch_id": branch_id,"order_id": order_id, "foods": foods.toJSON(), "is_use_point": is_use_point]
            
        case .addGiftFoods(let branch_id, let order_id, let foods, let is_use_point):
            
            return ["branch_id": branch_id,"order_id": order_id, "foods": foods.toJSON(), "is_use_point": is_use_point]
            
        case .kitchenes(let branch_id, let brand_id, let status):
            
            return ["branch_id": branch_id, "brand_id": brand_id, "status": status]
            
        case .vats:
            
            return [:]
            
        case .addOtherFoods(let branch_id, let order_id, let food):
            
            return ["branch_id": branch_id,"order_id": order_id, "price": food.price, "quantity": food.quantity, "note":food.note, "restaurant_vat_config_id": food.restaurant_vat_config_id, "restaurant_kitchen_place_id":food.restaurant_kitchen_place_id, "food_name": food.food_name, "is_allow_print":food.is_allow_print]
            
            
        case .addNoteToOrderDetail(let branch_id, let order_detail_id, let note):
            
            return ["branch_id": branch_id,"id": order_detail_id, "note": note]
            
        case .reasonCancelFoods(let branch_id):
            
            return ["branch_id": branch_id]
            
        case .cancelFood(let branch_id, let order_id, let reason, let order_detail_id, let quantity):
            return["branch_id": branch_id,"id": order_id, "reason":reason,"order_detail_id": order_detail_id, "quantity":quantity]
            
        case .updateFoods(let branch_id, let order_id, let foods):
            return["branch_id": branch_id,"id": order_id, "order_details":foods.toJSON()]
           
        case .ordersNeedMove(let branch_id, let order_id, let food_status):
            return ["id": order_id, "branch_id": branch_id, "food_status": food_status]
            
        case .moveFoods(let branch_id, let order_id, let destination_table_id, let target_table_id, let foods_move):
            return ["from_order_id": order_id, "destination_table_id":destination_table_id, "to_table_id": target_table_id,  "branch_id": branch_id, "list_food": foods_move.toJSON()]
            
        case .getOrderDetail(let order_id, let branch_id, let is_print_bill, let food_status):
            return ["id": order_id,"branch_id": branch_id,  "is_print_bill": is_print_bill, "food_status": food_status]
            
        case .openTable(let table_id):
            
            return ["table_id": table_id]
            
        case .discount(_,let branch_id, let food_discount_percent, let drink_discount_percent, let total_amount_discount_percent, let note):
            return ["branch_id": branch_id,
                    "food_discount_percent": food_discount_percent,
                    "drink_discount_percent": drink_discount_percent,
                    "total_amount_discount_percent": total_amount_discount_percent,
                    "note": note]
            
        case .moveTable(let branch_id,  let destination_table_id, let target_table_id):
            
            return ["branch_id": branch_id, "id": destination_table_id, "table_id": target_table_id]
            
            
        case .mergeTable(let branch_id,  let destination_table_id, let target_table_ids):
            
            return ["branch_id": branch_id, "destination_table_id": destination_table_id, "table_ids": target_table_ids]
            
        case .profile(let branch_id,  let employee_id):
            
            return ["branch_id": branch_id, "id": employee_id]
            
        case .extra_charges(let restaurant_brand_id, let branch_id,  let status):
            
            return ["restaurant_brand_id":restaurant_brand_id, "status": status]
            
        case .addExtraCharge(let branch_id, let order_id,  let extra_charge_id, let name, let price, let quantity, let note ):
            
            return ["branch_id":branch_id, "order_id": order_id, "extra_charge_id": extra_charge_id , "name": name , "price": price , "quantity": quantity, "note": note]
            
        case .returnBeer(let branch_id, let order_id,  let quantity, let order_detail_id, let note):
            
            return ["branch_id":branch_id, "id": order_id, "quantity": quantity, "order_detail_id":order_detail_id, "note":note]
            
        case .reviewFood(let order_id,  let review_data):
            
            return ["order_id": order_id, "review_data": review_data.toJSON()]
            
        case .getFoodsNeedReview(let branch_id, let order_id):
            
            return ["branch_id":branch_id,"order_id": order_id]
        case .updateCustomerNumberSlot(let branch_id, let order_id, let customer_slot_number):
            
            return ["branch_id":branch_id,"order_id": order_id, "customer_slot_number":customer_slot_number]
            
        case .requestPayment(let branch_id, let order_id, let payment_method, let is_include_vat):
            
            return ["branch_id":branch_id,"order_id": order_id, "payment_method":payment_method, "is_include_vat":is_include_vat]
            
        case .completedPayment(let branch_id, let order_id, let cash_amount, let bank_amount, let transfer_amount, let payment_method_id, let tip_amount):
            
            return ["branch_id":branch_id,"order_id": order_id, "cash_amount":cash_amount, "bank_amount":bank_amount, "transfer_amount":transfer_amount, "payment_method_id":payment_method_id, "tip_amount":tip_amount]
            
        case .tablesManagement(let branch_id, let area_id, let status):
            
            return ["branch_id":branch_id,"area_id": area_id, "status":status]
            
        case .createArea(let branch_id, let area):
            return [
                "branch_id":branch_id,
                "name": area.name,
                "status":area.status,
                "id": area.id
            ]
            
        case .foodsManagement(let branch_id, let is_addition, let status, let category_types, let restaurant_kitchen_place_id):
            
            return ["branch_id":branch_id, "is_addition": is_addition, "status": status,"category_types": category_types,"restaurant_kitchen_place_id": restaurant_kitchen_place_id]

        case .categoriesManagement(let brand_id, let status, let category_types):
            
            return ["restaurant_brand_id":brand_id,"status": status,"category_types":category_types]
            
        case .notesManagement(let branch_id, let status):
            
            return ["branch_id":branch_id,"status": status]
            
        case .createTable(let branch_id, let table_id, let table_name, let area_id, let total_slot, let is_active, let status):
            
            return ["branch_id":branch_id,
                    "table_id":table_id,
                    "table_name":table_name,
                    "area_id":area_id,
                    "total_slot":total_slot,
                    "is_active":is_active,
                    "status":status]
            
        case .prints(let branch_id, let is_have_printer, let is_print_bill, let status):
            
            return ["branch_id":branch_id, "is_have_printer": is_have_printer, "is_print_bill": is_print_bill, "status": status]
            
        case .openSession(let before_cash, let branch_working_session_id):
            
            return ["before_cash":before_cash, "branch_working_session_id": branch_working_session_id]
            
        case .workingSessions(let branch_id, let employee_id):
            
            return ["branch_id":branch_id, "employee_id": employee_id]
            
        case .checkWorkingSessions:
            return [:]
        case .sharePoint(let order_id, let employee_list):
            
            return ["order_id":order_id, "employee_list": employee_list.toJSON()]
            
        case .employeeSharePoint(let branch_id, let order_id):
            
            return ["branch_id":branch_id, "order_id": order_id]
            
        case .currentPoint(let employee_id):
            
            return ["employee_id":employee_id]
            
        case .assignCustomerToBill(let order_id, let qr_code):
            
            return ["order_id":order_id, "qr_code": qr_code]
            
        case .applyVAT(let branch_id, let order_id, let is_apply_vat):
            
            return ["branch_id":branch_id, "order_id":order_id, "is_apply_vat":is_apply_vat]
      
        case .fees(let branch_id, let restaurant_budget_id, let from, let to, let type, let is_take_auto_generated, let order_session_id, let report_type, let addition_fee_statuses, let is_paid_debt):
            
            return ["branch_id":branch_id,
                    "restaurant_budget_id":restaurant_budget_id,
                    "from":from,
                    "to":to,
                    "type":type,
                    "is_take_auto_generated":is_take_auto_generated,
                    "order_session_id":order_session_id,
                    "report_type":report_type,
                    "addition_fee_statuses": addition_fee_statuses,
                    "is_paid_debt": is_paid_debt]
            
        case .createFee(let branch_id, let type, let amount, let title, let note, let date, let addition_fee_reason_type_id):
            
            return [  "type": type,
                     "amount": amount,
                     "title": title,
                     "note": note,
                     "date": date,
                     "paymentMethodEnum": "CASH",
                     "branch_id": branch_id,
                     "is_count_to_revenue": 1,
                     "payment_method_id": 1,
                     "object_id": 5,
                     "object_name": title,
                     "object_type": 5,
                     "is_paid_debt": 1,
                     "addition_fee_reason_type_id":addition_fee_reason_type_id,
                     "supplier_order_ids": [],
                     "image_urls": []
            ]
            
        case .foodsNeedPrint(let order_id):
            
            return ["order_id":order_id]
            
        case .requestPrintChefBar(let order_id, let branch_id, let print_type):
            return ["id":order_id, "branch_id":branch_id, "type":print_type]
        case .updateReadyPrinted(let order_id, let order_detail_ids):
            return ["order_id":order_id, "order_detail_ids":order_detail_ids, "branch_id": ManageCacheObject.getCurrentBranch().id]
        case .employees(let branch_id, let is_for_share_point):
            return ["branch_id":branch_id, "is_for_share_point":is_for_share_point]
        case .kitchens(let branch_id, let status):
            return ["branch_id":branch_id, "status":status]
        case .updateKitchen(let branch_id, let kitchen):
            return ["branch_id":branch_id,
                    "name":kitchen.name,
                    "id":kitchen.id,
                    "type": kitchen.type,
                    "description":kitchen.description,
                    "printer_name":kitchen.printer_name,
                    "printer_ip_address":kitchen.printer_ip_address,
                    "printer_port":kitchen.printer_port,
                    "printer_paper_size":kitchen.printer_paper_size,
                    "print_number":kitchen.print_number,
                    "is_have_printer":kitchen.is_have_printer,
                    "is_print_each_food":kitchen.is_print_each_food,
                    "status":kitchen.status,
                    "printer_type":kitchen.printer_type
            ]
            
        case .updatePrinter(let printer):
            return [
                "id": printer.id,
                "restaurant_kitchen_place_id": printer.restaurant_id,
                "printer_name": printer.printer_name,
                "printer_ip_address": printer.printer_ip_address,
                "printer_port": printer.printer_port,
                "printer_paper_size": printer.printer_paper_size,
                "is_have_printer": 1,
                "is_print_bill": 1,
                "status": ACTIVE,
                "printer_type": PRINT_TYPE_ADD_FOOD
            ]
        case .createNote(let branch_id, let noteRequest, let is_deleted):
            return [
                "id": noteRequest.id,
                "content": noteRequest.content,
                "delete": is_deleted,
                "branch_id": branch_id
            ]
        case .createCategory(let name, let code,let description, let category_type, let status):
            return [
                "name":name,
                "code":code,
                "restaurant_brand_id": ManageCacheObject.getCurrentUser().restaurant_brand_id,
                "description":description,
                "category_type":category_type+1,
                "status":status,
                "id":0
            ]
        case .ordersHistory(let brand_id,let branch_id,let id, let report_type,let time, let limit, let page, let key_search,let is_take_away_table, let is_take_away):
            return [
                "id":id,
                "report_type":report_type,
                "time": time,
                "limit":limit,
                "restaurant_brand_id":brand_id,
                "branch_id":branch_id,
                "order_status": String(format: "%d,%d,%d", ORDER_STATUS_COMPLETE, ORDER_STATUS_DEBT_COMPLETE, ORDER_STATUS_CANCEL),
                "page":page,
                "key_search":key_search,
                "is_take_away_table":is_take_away_table,
                "is_take_away": is_take_away
            ]
        case .units:
            return [
                :
            ]
            
        case .createFood(let branch_id, let food):
            return [
                "id":food.id,
                "restaurant_brand_id":ManageCacheObject.getCurrentBrand().id,
                "branch_id":branch_id,
                "category_id":food.category_id,
                "avatar":food.avatar,
                "avatar_thump":food.avatar_thump,
                "description":food.description,
                "name":food.name,
                "price":food.price,
                "is_bbq":food.is_bbq,
                "unit":food.unit,
                "is_allow_print":food.is_allow_print,
                "is_allow_print_stamp":food.is_allow_print_stamp,
                "is_addition":food.is_addition,
                "code":food.code,
                "is_sell_by_weight":food.is_sell_by_weight,
                "is_allow_review":food.is_allow_review,
                "is_take_away":food.is_take_away,
                "is_addition_like_food":food.is_addition_like_food,
                "food_material_type":food.food_material_type,
                "food_addition_ids":food.food_addition_ids,
                "status":food.status,
                "temporary_price": food.temporary_price,
                "temporary_percent": food.temporary_percent,
                "temporary_price_from_date": food.temporary_price_from_date,
                "temporary_price_to_date": food.temporary_price_to_date,
                "promotion_percent": food.promotion_percent,
                "promotion_from_date": food.promotion_from_date,
                "promotion_to_date": food.promotion_to_date,
                "restaurant_vat_config_id": food.restaurant_vat_config_id,
                "restaurant_kitchen_place_id":food.restaurant_kitchen_place_id
            ]
            
        case .generateFileNameResource(let medias):
            return ["medias": medias.toJSON()]
        case .updateFood(let branch_id, let food):
            return [
                "id":food.id,
                "restaurant_brand_id":ManageCacheObject.getCurrentBrand().id,
                "branch_id":branch_id,
                "category_id":food.category_id,
                "avatar":food.avatar,
                "avatar_thump":food.avatar_thump,
                "description":food.description,
                "name":food.name,
                "price":food.price,
                "is_bbq":food.is_bbq,
                "unit":food.unit,
                "is_allow_print":food.is_allow_print,
                "is_allow_print_stamp":food.is_allow_print_stamp,
                "is_addition_like_food":food.is_addition_like_food,
                "is_addition":food.is_addition,
                "code":food.code,
                "is_sell_by_weight":food.is_sell_by_weight,
                "is_allow_review":food.is_allow_review,
                "is_take_away":food.is_take_away,
                "food_material_type":food.food_material_type,
                "food_addition_ids":food.food_addition_ids,
                "status":food.status,
                "temporary_price": food.temporary_price,
                "temporary_percent": food.temporary_percent,
                "temporary_price_from_date": food.temporary_price_from_date,
                "temporary_price_to_date": food.temporary_price_to_date,
                "promotion_percent": food.promotion_percent,
                "promotion_from_date": food.promotion_from_date,
                "promotion_to_date": food.promotion_to_date,
                "restaurant_vat_config_id": food.restaurant_vat_config_id,
                "restaurant_kitchen_place_id":food.restaurant_kitchen_place_id
            ]
        case .updateCategory(let id, let name, let code,let description, let category_type, let status):
            return [
                "id":id,
                "name":name,
                "code":code,
                "restaurant_brand_id": ManageCacheObject.getCurrentUser().restaurant_brand_id,
                "description":description,
                "category_type":category_type,
                "status":status
            ]
        case .cities(let limit):
            return ["limit":limit, "country_id": ACTIVE]
        case .districts(let city_id, let limit):
            return ["city_id": city_id, "limit":limit]
            
        case .wards(let district_id, let limit):
            return ["district_id": district_id, "limit": limit]
            
        case .wards(let district_id, let limit):
            return ["district_id": district_id, "limit": limit]
            
        case .updateProfile(let profileRequest):
            return [ "name": profileRequest.name,
                     "employee_id": profileRequest.id,
                     "gender": profileRequest.gender,
                     "birthday": profileRequest.birthday,
                     "phone_number": profileRequest.phone_number,
                     "address": profileRequest.address,
                     "avatar": profileRequest.avatar,
                     "email": profileRequest.email,
                     "city_id": profileRequest.city_id,
                     "district_id": profileRequest.district_id,
                     "ward_id": profileRequest.ward_id,
                     "node_token": profileRequest.node_token]
            
        case .updateProfileInfo(let infoRequest):
            return [ "employee_id": infoRequest.employee_id,
                     "city_id": infoRequest.city_id,
                     "district_id": infoRequest.district_id,
                     "ward_id": infoRequest.ward_id,
                     "street_name": infoRequest.street_name]
            
        case .changePassword(let employee_id, let old_password, let new_password, let node_access_token):
            return [ "id": employee_id,
                     "old_password": Utils.encoded(str: old_password),
                     "new_password": Utils.encoded(str: new_password),
                     "node_access_token": node_access_token]
            
            
        case .closeTable(let table_id):
            return [ "id": table_id, "branch_id":ManageCacheObject.getCurrentBranch().id]
       
            
        case .feedbackDeveloper(let email, let name, let phone, let type, let describe):
            return [ "email": email, "name":name , "phone":phone , "type":type , "describe":describe]
            
            
        case .sentError(let email, let name, let phone, let type, let describe):
            return [ "email": email, "name":name , "phone":phone , "type":type , "describe":describe]
            
        case .workingSessionValue:
            return [ : ]
            
        case .closeWorkingSession(let closeWorkingSessionRequest):
            return [ "real_amount": closeWorkingSessionRequest.real_amount, "cash_value":closeWorkingSessionRequest.cash_value.toJSON()]
            
        case .assignWorkingSession(let branch_id, let order_session_id):
            return [ "branch_id": branch_id, "order_session_id":order_session_id]
        case .forgotPassword(let username):
            return [ "username": username]
            
        case .verifyOTP(let restaurant_name, let user_name, let verify_code):
            return [ "restaurant_name": restaurant_name, "user_name": user_name, "verify_code":verify_code]
        
        case .verifyPassword( let user_name, let verify_code, let new_password):
            return [ "username": user_name, "verify_code": verify_code, "new_password":Utils.encoded(str: new_password), "app_type":Utils.getAppType(), "device_uid":Utils.getUDID()]
        case .notes( let branch_id):
            return [ "branch_id": branch_id]
            
        case .gift( let qr_code_gift, let branch_id):
            return [ "qr_code_gift": qr_code_gift, "branch_id": branch_id]
        case .useGift(let branch_id, let order_id,  let customer_gift_id, let customer_id):
            return [ "branch_id": branch_id, "orderId":order_id, "customer_gift_id": customer_gift_id, "customer_id": customer_id]
        case .tablesManager( let area_id, let branch_id, let status, let is_deleted):
            return [ "area_id": area_id, "branch_id": branch_id, "status":status , "is_deleted":is_deleted]
            
        case .notesByFood(let order_detail_id, let branch_id):
            return [ "food_id": order_detail_id, "branch_id": branch_id]
        case .getVATDetail(let order_id, let branch_id):
            return [ "order_id": order_id, "branch_id": branch_id]
            
        case .updateBranch(let branch):
            return [
                "city_id": branch.city_id,
                "country_name": branch.country_name,
                "street_name": branch.street_name,
                "phone": branch.phone,
                "ward_name": branch.ward_name,
                "district_id": branch.district_id,
                "lng": branch.lng,
                "image_logo_url": branch.image_logo_url,
                "city_name": branch.city_name,
                "ward_id": branch.ward_id,
                "address_note": branch.address_note,
                "banner_image_url": branch.banner_image_url,
                "name": branch.name,
                "district_name": branch.district_name,
                "lat": branch.lat
            ]
            //=========== API REPORT ========
            
        case .report_revenue_by_time(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
            return ["restaurant_brand_id": restaurant_brand_id, "branch_id": branch_id, "report_type": report_type, "date_string": date_string, "from_date": from_date, "to_date": to_date]
        
        case .report_revenue_activities_in_day_by_branch(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
            return ["restaurant_brand_id": restaurant_brand_id, "branch_id": branch_id, "report_type": report_type, "date_string": date_string, "from_date": from_date, "to_date": to_date]
            
        case .report_revenue_fee_profit(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
            return ["restaurant_brand_id": restaurant_brand_id, "branch_id": branch_id, "report_type": report_type, "date_string": date_string, "from_date": from_date, "to_date": to_date]
                
        case .report_revenue_by_category(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return ["restaurant_brand_id": restaurant_brand_id, "branch_id": branch_id, "report_type": report_type, "date_string": date_string, "from_date": from_date, "to_date": to_date]
            
        case .report_revenue_by_employee(let employee_id, let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
            return ["restaurant_brand_id": restaurant_brand_id, "branch_id": branch_id, "report_type": report_type, "date_string": date_string, "from_date": from_date, "to_date": to_date, "employee_id": ManageCacheObject.getCurrentUser().id]
            
        case .report_business_analytics(let restaurant_brand_id, let branch_id, let category_id, let category_types, let report_type, let date_string, let from_date,  let to_date, let is_cancelled_food, let is_combo, let is_gift, let is_goods, let is_take_away_food):
                return ["branch_id": branch_id,
                        "restaurant_brand_id": restaurant_brand_id,
                        "category_id": category_id,
                        "category_types": category_types,
                        "from_date": from_date,
                        "is_cancelled_food": is_cancelled_food,
                        "is_combo": is_combo,
                        "is_gift": is_gift,
                        "is_goods": is_goods,
                        "is_take_away_food": is_take_away_food,
                        "date_string": date_string,
                        "to_date": to_date,
                        "report_type": report_type]
        
        case .report_revenue_by_all_employee(restaurant_brand_id: let restaurant_brand_id, branch_id: let branch_id, report_type: let report_type, date_string: let date_string, from_date: let from_date, to_date: let to_date):
           
            return ["restaurant_brand_id": restaurant_brand_id, "branch_id": branch_id, "report_type": report_type, "date_string": date_string, "from_date": from_date, "to_date": to_date]
       
        case .cancelExtraCharge(branch_id: let branch_id, order_id: let order_id, reason: let reason, order_extra_charge: let order_extra_charge, let quantity):
            return["branch_id": branch_id,"id": order_id, "reason": reason,  "order_extra_charge": order_extra_charge, "quantity": quantity]
            
        case .report_food(
            let restaurant_brand_id,
            let branch_id,
            let report_type,
            let date_string,
            let from_date,
            let to_date,
            let category_id,
            let is_combo,
            let is_goods,
            let is_cancelled_food,
            let is_gift,
            let is_take_away_food
        ):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date,
                "is_goods": is_goods,
                "is_cancelled_food": is_cancelled_food,
                "is_combo": is_combo,
                "is_gift": is_gift,
                "category_id": category_id,
                "is_take_away_food": is_take_away_food
                
            ]
        
        case .report_cancel_food(
            let restaurant_brand_id,
            let branch_id,
            let report_type,
            let date_string,
            let from_date,
            let to_date,
            let category_id,
            let is_combo,
            let is_goods,
            let is_cancelled_food,
            let is_gift,
            let is_take_away_food
        ):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date,
                "is_goods": is_goods,
                "is_cancelled_food": is_cancelled_food,
                "is_combo": is_combo,
                "is_gift": is_gift,
                "category_id": category_id,
                "is_take_away_food": is_take_away_food
                
            ]
        case .report_gifted_food(
            let restaurant_brand_id,
            let branch_id,
            let report_type,
            let date_string,
            let from_date,
            let to_date,
            let category_id,
            let is_combo,
            let is_goods,
            let is_cancelled_food,
            let is_gift,
            let is_take_away_food
        ):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date,
                "is_goods": is_goods,
                "is_cancelled_food": is_cancelled_food,
                "is_combo": is_combo,
                "is_gift": is_gift,
                "category_id": category_id,
                "is_take_away_food": is_take_away_food
                
            ]
        case .report_discount(
            let restaurant_brand_id,
            let branch_id,
            let report_type,
            let date_string,
            let from_date,
            let to_date
        ):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date
            ]
            
        case .report_VAT(
            let restaurant_brand_id,
            let branch_id,
            let report_type,
            let date_string,
            let from_date,
            let to_date
        ):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date]
            
        case .report_area_revenue(let restaurant_brand_id,let branch_id,let report_type,let date_string,let from_date,let to_date):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date]
        
        case .report_table_revenue(let restaurant_brand_id,let branch_id,let area_id,let report_type,let date_string,let from_date,let to_date):
            return[
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "area_id":area_id,
                "report_type": report_type,
                "date_string": date_string,
                "from_date":from_date,
                "to_date":to_date]
            
            
            
        case .updateOtherFeed(_, let branch_id, let brand_id, let status):
            return[
                "branch_id": branch_id,
                "brand_id": brand_id,
                "status": status]
        
        case .getAdditionFee(_):
            return [:]
           
        case .updateAdditionFee(let id, let date, let note, let amount, let is_count_to_revenue, let object_type, let type, let payment_method_id, let cancel_reason, let branch_id, let object_name, let addition_fee_status, let addition_fee_reason_type_id):
            return[
                "id": id,
                "date": date,
                "note": note,
                "amount": amount,
                "is_count_to_revenue": is_count_to_revenue,
                "object_type": object_type,
                "type": type,
                "payment_method_id": payment_method_id,
                "cancel_reason": cancel_reason,
                "branch_id": branch_id,
                "addition_fee_status": addition_fee_status,
                "object_name": object_name,
                "addition_fee_reason_type_id" : addition_fee_reason_type_id
            ]
        case .cancelAdditionFee( let id, let cancel_reason, let branch_id, let addition_fee_status):
            return[
                "id": id,
                "cancel_reason": cancel_reason,
                "branch_id": branch_id,
                "addition_fee_status": addition_fee_status
            ]
        case .updateOtherFee(let id, let date, let note, let amount, let is_count_to_revenue, let payment_method_id ,  let branch_id, let object_name,let addition_fee_status, let addition_fee_reason_type_id):
                    return[
                        "id": id,
                        "date": date,
                        "note": note,
                        "amount": amount,
                        "is_count_to_revenue": is_count_to_revenue,
                        "payment_method_id": payment_method_id,
                        "branch_id": branch_id,
                        "addition_fee_status": addition_fee_status,
                        "object_name": object_name,
                        "addition_fee_reason_type_id" : addition_fee_reason_type_id
                    ]
        
//        case .moveExtraFoods(branch_id: let branch_id, order_id: let order_id, destination_table_id: let destination_table_id, target_table_id: let target_table_id, foods: let foods):
//            return ["from_order_id": order_id, "destination_table_id":destination_table_id, "to_table_id": target_table_id,  "branch_id": branch_id, "list_extra_charge": foods.toJSON()]
        case .moveExtraFoods(branch_id: let branch_id, order_id: let order_id,let target_order_id, foods: let foods):
            return ["order_id": target_order_id, "branch_id": branch_id, "list_extra_charge": foods.toJSON()]
        case .getFoodsBookingStatus(order_id: let order_id):
                return ["order_id": order_id]
            
            // API REPORT SEEMT
        case .getReportOrderRestaurantDiscountFromOrder(let restaurant_brand_id,  let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ] //@
                case .getOrderReportFoodCancel(let restaurant_brand_id, let branch_id, let type, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "type": type,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                    
                case .getOrderReportFoodGift(let restaurant_brand_id, let branch_id, let type_sort, let is_group, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "type_sort": type_sort,
                        "is_group": is_group,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getOrderReportTakeAwayFood(let restaurant_brand_id, let branch_id, let report_type, let date_string, let food_id, let is_gift, let is_cancel_food, let key_search, let from_date, let to_date, let page, let limit):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "food_id": food_id,
                        "is_gift": is_gift,
                        "is_cancel_food": is_cancel_food,
                        "key_search": key_search,
                        "from_date": from_date,
                        "to_date": to_date,
                        "page": page,
                        "limit": limit
                    ]
                    //@
                case .getRestaurantRevenueCostProfitEstimation(let restaurant_brand_id, let branch_id, let report_type,let date_string,let from_date,let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date,
                    ]
                case .getOrderCustomerReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getReportRevenueGenral(let restaurant_brand_id,  let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getReportRevenueArea(let restaurant_brand_id,  let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getReportSurcharge(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getReportRevenueProfitFood(let restaurant_brand_id, let branch_id, let category_types, let food_id, let is_goods, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "category_types": category_types,
                        "food_id": food_id,
                        "is_goods": is_goods,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getRestaurantOtherFoodReport(let restaurant_brand_id, let branch_id, let category_types, let food_id, let is_goods, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "category_types": category_types,
                        "food_id": food_id,
                        "is_goods": is_goods,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ]
                case .getRestaurantVATReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "report_type":report_type,
                        "date_string":date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ]
                case .getWarehouseSessionImportReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "report_type":report_type,
                        "date_string":date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ]
                case .getRenueByEmployeeReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                    return [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "report_type":report_type,
                        "date_string":date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ]
                case .getRestaurantRevenueDetailByBrandId(let restaurant_brand_id, let branch_id, let report_type,let from_date, let to_date, let date_string):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "from_date": from_date,
                        "to_date": to_date,
                        "date_string":date_string
                    ]
                case .getRestaurantRevenueDetailByBranch(let restaurant_brand_id, let branch_id, let report_type,let from_date, let to_date, let date_string):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "from_date": from_date,
                        "to_date": to_date,
                        "date_string":date_string
                    ]
                case .getRestaurantRevenueCostProfitSum(let restaurant_brand_id, let branch_id, let report_type,let date_string,let from_date,let to_date):
                    return [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date,
                    ]
             case .getRestaurantRevenueCostProfitReality(let restaurant_brand_id, let branch_id, let report_type,let date_string,let from_date,let to_date):
            return [
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "report_type": report_type,
                "date_string":date_string,
                "from_date": from_date,
                "to_date": to_date,
            ]
        case .getInfoBranches(_):
            return [ : ]
            
        case .healthCheckChangeDataFromServer(let branch_id, let restaurant_brand_id, let restaurant_id):
            return [
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "restaurant_id": restaurant_id,
                
            ]
            

        case .getLastLoginDevice(let device_uid,let app_type):
            return [
                "device_uid": device_uid,
                "app_type": app_type
            ]
        
        case .postCreateOrder(let branch_id,let table_id,let note):
            return [
                "branch_id": branch_id,
                "table_id": table_id,
                "note": note
            ]
     
        case .getBranchRights(let restaurant_brand_id,let employee_id):
            return [
                "restaurant_brand_id": restaurant_brand_id,
                "employee_id": employee_id
            ]
            
            
        case .getTotalAmountOfOrders(let restaurant_brand_id,let branch_id,let is_take_away_table,let order_status,let key_search,let employee_id, let is_take_away,let report_type):
            return [
                "restaurant_brand_id": restaurant_brand_id,
                "branch_id": branch_id,
                "is_take_away_table":is_take_away_table,
                "order_status":order_status,
                "key_search":key_search,
                "employee_id":employee_id,
                "is_take_away":is_take_away,
                "report_type":report_type
            ]
        
        case .postApplyExtraChargeOnTotalBill(_,let branch_id, let total_amount_extra_charge_percent):
            return [
                "branch_id": branch_id,
                "total_amount_extra_charge_percent": total_amount_extra_charge_percent
            ]
            
            
        case .postPauseService(_,let branch_id, let order_detail_id):
            return ["branch_id": branch_id, "order_detail_id":order_detail_id]
            
            
        case .postUpdateService(_,let branch_id, let order_detail_id, let start_time, let end_time, let note):
            return [
                "branch_id": branch_id,
                "order_detail_id": order_detail_id,
                "start_time": start_time,
                "end_time": end_time,
                "note": note
            ]
            
        
            
        case .getActivityLog(let object_id, let type, let key_search, let object_type, let from, let to, let page, let limit):
            return [
                "object_id": object_id,
                "type": type,
                "key_search": key_search,
                "object_type": object_type,
                "from": from,
                "to": to,
                "page": page,
                "limit": limit
            ]
            
            
        case .postApplyOnlyCashAmount(_):
            return [:]
            
        case .getApplyOnlyCashAmount(_):
            return [:]
        
        case .getVersionApp(let os_name, let key_search, let is_require_update, let limit, let page):
            return [
                "os_name": os_name,
                "key_search": key_search,
                "is_require_update": is_require_update,
                "limit": limit,
                "page": page
            ]
            
        case .postApplyTakeAwayTable(_):
            return [:]
            
        case .postCreateTableList(let branch_id, let area_id, let tables):
            return [
                "branch_id": branch_id,
                "area_id": area_id,
                "tables": tables.toJSON()
            ]
            
            
        case .getPrintItem(let type_print, let restaurant_id, let branch_id):
            return [
                "type_print": type_print,
                "restaurant_id": restaurant_id,
                "branch_id": branch_id
            ]
            
        }

  }
    
    /// The parameter encoding. `URLEncoding.default` by default.
    private func encoding(_ httpMethod: HTTPMethod) -> ParameterEncoding {
        var encoding : ParameterEncoding = JSONEncoding.prettyPrinted
        if httpMethod == .get{
            encoding = URLEncoding.default
        }
        return encoding
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    
//    var sampleData: Data {
//        return "".data(using: String.Encoding.utf8)!
//    }
    
    var sampleData: Data {
           return Data()
    }

    
    var task: Task {
//        dLog(headers)
        switch self {
        case .sessions:
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .config:
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .orders(_, _, _, _,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .checkVersion:
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .regisDevice(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
        case .login(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .setting(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .areas(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .tables(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .brands(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .branches(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .order(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .foods(_,_,_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .addFoods(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .addGiftFoods(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .kitchenes(_, _, _):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .vats:
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .addOtherFoods(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .addNoteToOrderDetail(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .reasonCancelFoods(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .cancelFood(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .updateFoods(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .ordersNeedMove(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .moveFoods(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .getOrderDetail(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .openTable(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .discount(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .moveTable(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .mergeTable(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .profile(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .extra_charges(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .addExtraCharge(_, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .returnBeer(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .reviewFood(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .getFoodsNeedReview(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .updateCustomerNumberSlot(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .requestPayment(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .completedPayment(_, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .tablesManagement(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .createArea(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .foodsManagement(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))

        case .categoriesManagement(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .notesManagement(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .createTable(_, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .prints(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .openSession(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .workingSessions(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .checkWorkingSessions:
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .sharePoint(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .employeeSharePoint(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .currentPoint(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .assignCustomerToBill(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .applyVAT(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .fees(_, _, _, _, _, _, _, _, _, _):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .createFee(_, _, _, _, _, _, _):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .foodsNeedPrint(_):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .requestPrintChefBar(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .updateReadyPrinted(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .employees(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .kitchens(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .updateKitchen(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .updatePrinter(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .createNote(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .createCategory(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .ordersHistory(_, _, _, _, _,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .units:
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .createFood(_, _):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .generateFileNameResource(_):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .updateFood(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .updateCategory(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .cities:
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .districts(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .wards(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .updateProfile(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .updateProfileInfo(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .changePassword(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .closeTable(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .feedbackDeveloper(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .sentError(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .workingSessionValue:
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .closeWorkingSession(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .assignWorkingSession(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .forgotPassword(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .verifyOTP(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
        case .verifyPassword(_, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .notes(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .gift(_, _):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .useGift(_, _, _, _):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .tablesManager(_, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .notesByFood(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .getVATDetail(_, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            //=========== API REPORT ========
            
        case .report_revenue_by_time(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .report_revenue_activities_in_day_by_branch(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .report_revenue_fee_profit(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .report_revenue_by_category(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .report_revenue_by_employee(_, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_business_analytics(_, _, _, _, _, _, _, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_revenue_by_all_employee(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .cancelExtraCharge(branch_id: let branch_id, order_id: let order_id, reason: let reason, order_extra_charge: let order_extra_charge, let quantity):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .report_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_cancel_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_gifted_food(_,_,_,_,_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_discount(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_VAT(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .report_area_revenue(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .report_table_revenue(_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .updateOtherFeed(_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .getAdditionFee(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .updateAdditionFee(_,_,_,_,_,_,_,_,_,_,_,_,_):
            
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .moveExtraFoods(branch_id: let branch_id, order_id: let order_id,target_order_id: let target_order_id, foods: let foods):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
        case .updateOtherFee(_,_,_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .cancelAdditionFee(id: let id, cancel_reason: let cancel_reason, branch_id: let branch_id, addition_fee_status: let addition_fee_status):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .getFoodsBookingStatus(order_id: let order_id):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .updateBranch(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            // API REPORT SEEMT
        case .getReportOrderRestaurantDiscountFromOrder(_, _, _, _, _, _):
                   return .requestParameters(parameters: parameters!,encoding: self.encoding(.get))
            
        case .getOrderReportFoodCancel(_, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        case .getOrderReportFoodGift(_, _, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getOrderReportTakeAwayFood(_, _, _, _, _, _, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))//@
            
        case .getRestaurantRevenueCostProfitEstimation(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getOrderCustomerReport(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getReportRevenueGenral(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!,encoding: self.encoding(.get))
            
        case .getReportRevenueArea(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!,encoding: self.encoding(.get))
            
        case .getReportSurcharge(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getReportRevenueProfitFood(_, _, _, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!,encoding: self.encoding(.get))
            
        case .getRestaurantOtherFoodReport(_, _, _, _, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getRestaurantVATReport(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getWarehouseSessionImportReport(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getRenueByEmployeeReport(_, _, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getRestaurantRevenueDetailByBrandId(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getRestaurantRevenueDetailByBranch(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getRestaurantRevenueCostProfitSum(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getRestaurantRevenueCostProfitReality(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getInfoBranches(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .healthCheckChangeDataFromServer(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))


        case .getLastLoginDevice(_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
        case .postCreateOrder(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .getBranchRights(_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
        
            
        case .getTotalAmountOfOrders(_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        
        case .postApplyExtraChargeOnTotalBill(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .postPauseService(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .postUpdateService(_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
        
        case .getActivityLog(_,_,_,_,_,_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .postApplyOnlyCashAmount(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .getApplyOnlyCashAmount(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .getVersionApp(_, _, _, _, _):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
        case .postApplyTakeAwayTable(_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
        case .postCreateTableList(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.post))
            
            
        case .getPrintItem(_,_,_):
            return .requestParameters(parameters: parameters!, encoding: self.encoding(.get))
            
            
            
        }
    }
        
}

    let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions:.requestBody)
    let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)

    let endpointClosure = { (target: ManagerConections) -> Endpoint in
                let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
                return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-Type": "application/json"])
            }



    

    let appServiceProvider = MoyaProvider<ManagerConections>(endpointClosure: endpointClosure,
                                                             session: DefaultAlamofireSession.shared,
                                                             plugins: [NetworkActivityPlugin(networkActivityClosure: { (activity, target) in
                switch activity{
                    
                case .began:
//                    print("Network Activity began")
                    
                    DispatchQueue.main.async {
                        if let visibleViewCtrl = UIApplication.shared.keyWindow?.rootViewController {
                            // do whatever you want with your `visibleViewCtrl`
                            JHProgressHUD.sharedHUD.showInView(visibleViewCtrl.view)
                        }
                    }
                    
                   
                    
                    
                case .ended:
//                    print("Network Activity ended")
                    DispatchQueue.main.async {
                        if let visibleViewCtrl = UIApplication.shared.keyWindow?.rootViewController {
                            // do whatever you want with your `visibleViewCtrl`
                            JHProgressHUD.sharedHUD.hide()
                        }
                    }
                }
            })])

class DefaultAlamofireSession: Alamofire.Session {
    static let shared: DefaultAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireSession(configuration: configuration)
    }()
}

