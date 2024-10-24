//
//  PathConnectionManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//

import UIKit

extension ConnectionManager {
    
    var baseURL: URL {
        
        switch self {
            case .postGoFoodLoginRequest,.postGoFoodToken:
                return URL(string: "https://goid.gojekapi.com")!
            
            case .getUserInforOfShopee(_):
                return URL(string: "https://app.partner.shopee.vn")!
            
            default:
                return URL(string: environmentMode.baseUrl)!
        }
        
        
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
                
            case .tables(_, _, _, _, _,_):
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
                
            case .moveFoods(_,_, let destination_table_id,_,_):
              
                return String(format: APIEndPoint.Name.urlMoveFoods, destination_table_id)
                
            case .getOrderDetail(let order_id,_,_,_):
                return String(format: APIEndPoint.Name.urlOrderDetailPayment, order_id)
                
                
            case .openTable(let table_id):
                return String(format: APIEndPoint.Name.urlOpenTable, table_id)
                
            case .discount(let order_id,_,_,_,_,_):
          
                return String(format: APIEndPoint.Name.urlDiscount, order_id)
                
            case .moveTable(_,let destination_table_id,_):
                return String(format: APIEndPoint.Name.urlMoveTable, destination_table_id)
                
            case .mergeTable(_, let destination_table_id,_):
                return String(format: APIEndPoint.Name.urlMergeTable, destination_table_id)
                
            case .profile(_,  let employee_id):
                return String(format: APIEndPoint.Name.urlProfile, employee_id)
                
                
            case .extra_charges(_, _, _):
                return APIEndPoint.Name.urlExtraCharges
                
            case .addExtraCharge(_,let order_id, _, _, _, _, _):
                return String(format: APIEndPoint.Name.urlAddExtraCharges, order_id)
                
                
            case .returnBeer(_,let order_id, _, _, _):
                return String(format: APIEndPoint.Name.urlReturnBeer, order_id)
                
                
            case .reviewFood(let order_id, _):
                return String(format: APIEndPoint.Name.urlReviewFood, order_id)
                
            case .getFoodsNeedReview(_,let order_id):
                return String(format: APIEndPoint.Name.urlGetFoodsNeedReview, order_id)
                
            case .updateCustomerNumberSlot(_,let order_id,_):
                return String(format: APIEndPoint.Name.urlUpdateCustomerNumberSlot, order_id)
                
            case .requestPayment(_,let order_id, _, _):
                return String(format: APIEndPoint.Name.urlRequestPayment, order_id)
                
            case .completedPayment(_,let order_id, _, _, _, _, _):
                return String(format: APIEndPoint.Name.urlCompletedPayment, order_id)
                
//            case .tablesManagement(_, _, _):
//                return APIEndPoint.Name.urlTablesManagement
//                
            case .createArea(_,_,_):
                return APIEndPoint.Name.urlCreateArea

            case .foodsManagement(_, _, _, _, _):
                return APIEndPoint.Name.urlAllFoodsManagement

                
            case .categoriesManagement(_,_,_):
                return APIEndPoint.Name.urlAllCategoriesManagement
                
            case .notesManagement(_, _):
                return APIEndPoint.Name.urlAllNotesManagement
                
            case .createTable(_, _, _, _, _, _):
                return APIEndPoint.Name.urlTablesManagement
                
          
            case .prints(_, _, _, _):
                return APIEndPoint.Name.urlPrinters
                
            case .openSession(_, _):
                return APIEndPoint.Name.urlOpenWorkingSession
                
            case .workingSessions(_,  let employee_id):
                return String(format: APIEndPoint.Name.urlWorkingSession, employee_id)
                
                
            case .checkWorkingSessions:
                return APIEndPoint.Name.urlCheckWorkingSessions
                
            case .sharePoint(let order_id, _):
                return String(format: APIEndPoint.Name.urlSharePoint, order_id)
                
            case .employeeSharePoint(_,let order_id):
                return String(format: APIEndPoint.Name.urlSharePoint, order_id)
                
            case .currentPoint(let employee_id):
                return String(format: APIEndPoint.Name.urlCurrentPoint, employee_id)
                
            case .assignCustomerToBill(let order_id, _):
                return String(format: APIEndPoint.Name.urlAssignCustomerToBill, order_id)
                
            case .applyVAT(_, let order_id, _):
                return String(format: APIEndPoint.Name.urlApplyVAT, order_id)
                
            case .fees(_, _, _, _, _, _, _, _, _, _):
                return APIEndPoint.Name.urlFees
                
            case .createFee(_, _, _, _, _, _, _):
                return APIEndPoint.Name.urlCreateFee
                
            case .foodsNeedPrint(_):
                return APIEndPoint.Name.urlFoodsNeedPrint
                
            case .requestPrintChefBar(let order_id, _, _):
                return String(format: APIEndPoint.Name.urlRequestPrintChefBar, order_id)
                
            case .updateReadyPrinted(_, _):
                return APIEndPoint.Name.urlUpdateReadyPrinted
                
            case .employees(_, _):
                return APIEndPoint.Name.urlEmployees
                
            case .kitchens(_, _):
                return APIEndPoint.Name.urlKitchens
                
            case .updateKitchen(_,  let kitchen):
                return String(format: APIEndPoint.Name.urlUpdateKitchen, kitchen.id)
                
            case .updatePrinter(let printer):
                return String(format: APIEndPoint.Name.urlUpdatePrinter,printer.id)
                
            case .createNote(_, _, _):
                return APIEndPoint.Name.urlCreateUpdateNote
                
            case .createCategory(_, _, _, _, _):
                return APIEndPoint.Name.urlCreateCategory
                
            case .ordersHistory(_, _, let id, _, _, _,_,_,_,_):
                return String(format: APIEndPoint.Name.urlOrdersHistory, id)
                
            case .units:
                return APIEndPoint.Name.urlUnits
                
            case .createFood(_, _):
                return APIEndPoint.Name.urlCreateFood
                
                
            case .generateFileNameResource(_):
                return APIEndPoint.Name.urlGenerateLink
                
            case .updateFood(_, let food):
                return String(format: APIEndPoint.Name.urlEditFood, food.id)
                
            case .updateCategory(let id, _, _, _, _, _):
                return String(format: APIEndPoint.Name.urlUpdateCategory, id)
                
            case .cities:
                return APIEndPoint.Name.urlCities
                
                
            case .districts(let city_id, _):
                return String(format: APIEndPoint.Name.urlDistrict, city_id)
                
            case .wards(let district_id, _):
                return String(format: APIEndPoint.Name.urlWards, district_id)
                
            case .updateProfile(let profileRequest):
                return String(format: APIEndPoint.Name.urlUpdateProfile, profileRequest.id)
                
            case .updateProfileInfo(let infoRequest):
                return String(format: APIEndPoint.Name.urlUpdateProfileInfo, infoRequest.employee_id)
                
                
            case .changePassword(let employee_id, _, _, _):
                return String(format: APIEndPoint.Name.urlChangePassword, employee_id)
                
            case .closeTable(let table_id):
                return String(format: APIEndPoint.Name.urlCloseTable, table_id)
                
                
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
                
            case .useGift(_,let order_id, _, _):
                return String(format: APIEndPoint.Name.urlUseGift, order_id)
                
            case .tablesManager(_, _, _, _):
                return APIEndPoint.Name.urlTableManage
                
            case .notesByFood(let order_detail_id, _):
                return String(format: APIEndPoint.Name.urlNotesByFood, order_detail_id)
           
            case .getVATDetail(let order_id, _):
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
            
            case .healthCheckForBuffet(_,_,_,_):
                return APIEndPoint.Name.urlHealthCheckForBuffet
                    
                
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
                excludedAPIString = APIEndPoint.Name.urlGetPrintItem
                return APIEndPoint.Name.urlGetPrintItem
            
            case .getBrandSetting(let brand_id):
                return String(format: APIEndPoint.Name.urlgetBrandSetting, brand_id)
            
            case .getSendToKitchen(_,_):
                return APIEndPoint.Name.urlSendToKitchen
            
            case .postSendToKitchen(_,_,_):
                return APIEndPoint.Name.urlSendToKitchen
            
            case .getBankAccount(_, _, _):
                return APIEndPoint.Name.urlGetRestaurantBrandBankAccount
            
            case .getBankList:
                return APIEndPoint.Name.urlGetBankList
            
            case .getBrandBankAccount(_,_):
                return APIEndPoint.Name.urlGetBrandBankAccount
            
            case .postCreateBrandBankAccount(_,_):
                return APIEndPoint.Name.urlPostCreateBrandBankAccount
                    
            case .postUpdateteBrandBankAccount(_,let bankAccount):
                return String(format: APIEndPoint.Name.urlPostUpdateteBrandBankAccount, bankAccount.id)
                
            
            case .getBuffetTickets(_,_,_,_,_):
                return APIEndPoint.Name.urlGetBuffetTickets
            
            case .getDetailOfBuffetTicket(_,_,_,_,_,_):
                return APIEndPoint.Name.urlGetDetailOfBuffetTicket
            
            case .getFoodsOfBuffetTicket(_,_):
                return APIEndPoint.Name.urlGetFoodsOfBuffetTicket
            
            case .postCreateBuffetTicket(_,_,_,_,_,_,_):
               return APIEndPoint.Name.urlPostCreateBuffetTicket
            
            case .postUpdateBuffetTicket(_,_,let buffet):
                return String(format: APIEndPoint.Name.urlPostUpdateBuffetTicket, buffet.id)
            
            case .postCancelBuffetTicket(let id):
                return String(format: APIEndPoint.Name.urlPostCancelBuffetTicket, id)
            
            case .postDiscountOrderItem(_,let orderId,_):
                return String(format: APIEndPoint.Name.urlPostDiscountOrderItem, orderId)
            
            
            // MARK: API for chat
            case .postCreateGroupSuppport:
                return APIEndPoint.Chat.urlPostCreateGroupSuppport
            case .getMessageList(_,_,_,_):
                return APIEndPoint.Chat.urlGetMessageList
            
            case .getListMedia(_, _, _, _, _, _, _):
                return APIEndPoint.Chat.urlListMedia
            
            case .postRemovePrintedItem(_,_):
                return APIEndPoint.Name.urlPostRemovePrintedItem
            
//==================================================================================================================================================================
            
            // MARK: API for APP FOOD
            case .getChannelFoodOrder(_,_,_,_,_):
                return APIEndPoint.AppFood.urlGetChannelFoodOrder
                
            case .getOrderDetailOfChannelFood(_,_,_,_,_,_,_):
                return APIEndPoint.AppFood.urlGetOrderDetailOfChannelFood
            
            case .getDetailOfChannelOrderFoodToken(let id):
                return String(format: APIEndPoint.AppFood.urlGetDetailOfChannelOrderFoodToken, id)
            
            case .postCreateTokenOfChannelFoodOrder(_,_,_,_,_,_,_,_):
                return String(format: APIEndPoint.AppFood.urlPostCreateTokenOfChannelFoodOrder)
        
            case .postUpdateTokenOfChannelFoodOrder(let id,_,_,_,_):
                return String(format: APIEndPoint.AppFood.urlPostUpdateTokenOfChannelFoodOrder, id)
                
            case .postChangeConnectOfChannelOrderFoodToken(let id,_):
                return String(format: APIEndPoint.AppFood.urlPostChangeConnectOfChannelOrderFoodToken, id)
            
            case .getUserInforOfShopee(_):
                return String(format:"/mss/app-api/PartnerRNServer/GetUserInfoForRn")
            
            case .postGoFoodLoginRequest(_):
                return APIEndPoint.AppFood.urlPostGofoodLoginRequest
            
            case .postGoFoodToken(_,_):
                return APIEndPoint.AppFood.urlPostGoFoodToken
            
            case .getOrderListOfFoodApp(_,_,_,_,_,_,_,_):
                excludedAPIString = APIEndPoint.AppFood.urlGetOrderListOfFoodAp
                return APIEndPoint.AppFood.urlGetOrderListOfFoodAp
        
            case .getOrderDetailOfFoodApp(_,_):
                excludedAPIString = APIEndPoint.AppFood.urlGetOrderDetailOfFoodApp
                return APIEndPoint.AppFood.urlGetOrderDetailOfFoodApp
    

            case .postConfirmOrderOfFoodApp(let orderId):
                excludedAPIString = String(format: APIEndPoint.AppFood.urlPostConfirmOrderOfFoodApp, orderId)
                return String(format: APIEndPoint.AppFood.urlPostConfirmOrderOfFoodApp, orderId)
            
            case .postBatchConfirmOrderOfFoodApp(let branch_id,_):
                excludedAPIString = String(format: APIEndPoint.AppFood.urlPostBatchConfirmOrderOfFoodApp)
                return String(format: APIEndPoint.AppFood.urlPostBatchConfirmOrderOfFoodApp)
        
            
            case .getFoodAppReport(_,_,_,_,_,_):
                return APIEndPoint.NameReportEndPoint.urlGetFoodAppReport
            
            
            case .getBranchFoodApp(_, _):
                return APIEndPoint.AppFood.urlGetBranchFoodApp
            
            case .postAssignBranchFoodApp(_,_,_):
                return APIEndPoint.AppFood.urlPostAssignBranchFoodApp
            
            
            case .getCommissionOfFoodApp(_,_):
                return APIEndPoint.AppFood.urlGetCommissionOfFoodApp
            
            case .postSetCommissionForFoodApp(_,_,_,_,_,_,_):
                return APIEndPoint.AppFood.urlPostSetCommissionForFoodApp
            
            case .getOrderHistoryOfFoodApp(_,_,_,_,_,_):
                return APIEndPoint.AppFood.urlGetOrderHistoryOfFoodApp
            
            case .getOrderHistoryDetailOfFoodApp(_,_,_,_):
                return APIEndPoint.AppFood.urlGetOrderHistoryDetailOfFoodApp
            
            case .getRevenueSumaryReportOfFoodApp(_,_,_,_,_,_,_):
                return APIEndPoint.AppFood.urlGetRevenueSumaryReportOfFoodApp
            
            case .postRefreshOrderOfFoodApp(_,_,_,_):
                return APIEndPoint.AppFood.urlPosRefreshOrderOfFoodApp
                
            case .getBranchesOfChannelOrderFood(_,_,_):
                return APIEndPoint.AppFood.urlGetBranchesOfChannelOrderFood
                
            case .getChannelOrderFoodTokenList(_,_,_,_):
                return APIEndPoint.AppFood.urlGetChannelOrderFoodTokenList
            
            case .getChannelOrderFoodInforList(_,_,_,_,_,_,_,_,_,_,_):
                return APIEndPoint.AppFood.urlGetChannelOrderFoodInforList
                
            case .getAssignedBranchOfFoodApp(_,_):
                return APIEndPoint.AppFood.urlGetAssignedBranchOfFoodApp
            
            case .postAssignBrachOfFoodApp(_,_,_):
                return APIEndPoint.AppFood.urlPostAssignBrachOfFoodApp
            
            //==================================================================================================================================================================
            // MARK: API for TECHRESSHOP
            
            case .getTechresShopDeviceList:
                return APIEndPoint.TECHRESSHOP.urlGetTechresShopDeviceList
            
            case .postCreateTechresShopOrder(_,_):
                return APIEndPoint.TECHRESSHOP.urlPostCreateTechresShopOrder
            
            case .getTechresShopOrder(_,_):
                return APIEndPoint.TECHRESSHOP.urlGetTechresShopOrder
            
            case .getTechresShopOrderDetail(let orderId):
                return String(format: APIEndPoint.TECHRESSHOP.urlGetTechresShopOrderDetail, orderId)
           
            
            //==================================================================================================================================================================
            
        }
    }
}
