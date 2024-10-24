//
//  APIEndPoint.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//


import Foundation
import UIKit

public struct APIEndPoint {
    private static let version = "v11"
    private static let report_api_version = "v2"
    private static let upload_api_version = "v2"
    private static let version_oauth_service = "v10"
    private static let log_api_version = "v2"
    
    //VERSION SEEMT
    private static let version_report_service = "v2"
    private static let version_upload_service = "v2"
    private static let version_check_data = "v1"
    
    //VERSION CHAT
    private static let version_chat_service = "v1"
  
    
    private static let dashboard_version = "v12"
    
    
    static let REALTIME_SERVER = environmentMode.realTimeUrl
    static let GATEWAY_SERVER_URL = environmentMode.baseUrl
    static let REALTIME_CHAT_SERVER = environmentMode.realTimeChatUrl

    struct Name {
        static let urlSessions = String(format: "/api/%@/sessions", version_oauth_service)
        static let urlConfig = String(format: "/api/%@/configs", version_oauth_service)
        static let urlRegisterDevice =  String(format: "/api/%@/register-device", version_oauth_service)
        static let urlCheckVersion = String(format: "/api/%@/check-version", version_oauth_service)
       
        static let urlLogin = String(format: "/api/%@/employees/login", version_oauth_service)
        static let urlSetting = String(format: "/api/%@/employees/settings", version_oauth_service)
        static let urlGetLastLoginDevice = String(format: "/api/%@/employees/device/last-login", version_oauth_service)
        
        
        static let urlgetBranchRights = String(format: "api/%@/restaurant-resource-privilege-maps",version)
        static let urlBrands = String(format: "api/%@/restaurant-brands",dashboard_version)
        static let urlBranches = String(format: "/api/%@/branches", dashboard_version)
        static let urlBranchesInfo = "/api/\(version)/branches/%d"
        static let urlOrder = "/api/\(version)/orders/%d"
        
        //Define Area Screen
        static let urlAreas =  String(format: "/api/%@/areas", version )
        static let urlTables =  String(format: "/api/%@/tables",version)
        
        
        //Define Order Screen
        static let urlOrders = String(format: "/api/%@/orders",version )
        
        static let urlOrderDetail = "/api/\(version)/orders/%d"
        
        //Define Food Screen
        static let urlFoods = String(format: "/api/%@/foods/menu", version)// V5 mới có món kèm trong gọi món
        
        static let urlAddFoodsToOrder = "/api/\(version)/orders/%d/add-food"
        static let urlAddGiftFoodsToOrder = "/api/\(version)/orders/%d/gift-food"
        static let urlKitchenes = String(format: "/api/%@/restaurant-kitchen-places",version )
        static let urlVAT = String(format: "/api/%@/restaurant-vat-configs",version )
        
        static let urlAddOtherFoodsToOrder = "/api/\(version)/orders/%d/add-special-food"
        static let urlAddNoteToOrderDetail = "/api/\(version)/order-details/%d/note"
        static let urlReasonCancelFoods = String(format: "/api/%@/orders/cancel-reasons",version )
        static let urlCancelFood = "/api/\(version)/orders/%d/cancel-order-detail"
        static let urlCancelExtraCharge = "/api/\(version)/order-extra-charges/%d/cancel-extra-charge"
        static let urlUpdateFood = "/api/\(version)/orders/%d/update-multi-order-detail"
        static let urlOrderNeedMove =  "/api/\(version)/orders/%d/order-detail-move"
        static let urlMoveFoods =  "/api/\(version)/tables/%d/move-food"
        static let urlOrderDetailPayment =  "/api/\(version)/orders/%d"
        static let urlOpenTable =  "/api/\(version)/tables/%d/open"
        static let urlDiscount = "/api/\(version)/orders/%d/apply-discount"
        static let urlMoveTable = "/api/\(version)/tables/%d/move"
        
        static let urlMergeTable = "/api/\(version)/tables/%d/merge"
        static let urlProfile = "/api/\(version)/employees/%d"
        
        static let urlExtraCharges = "/api/\(version)/restaurant-extra-charges"
        static let urlAddExtraCharges = "/api/\(version)/order-extra-charges/%d/add-extra-charges"
        static let urlReturnBeer = "/api/\(version)/orders/%d/return-beer"

        static let urlReviewFood = "/api/\(version)/orders/%d/review-order-details"
        static let urlGetFoodsNeedReview = "/api/\(version)/orders/%d/customer-review"
        static let urlUpdateCustomerNumberSlot = "/api/\(version)/orders/%d/update-customer-slot-number"
        static let urlRequestPayment = "/api/\(version)/orders/%d/request-payment"
        static let urlCompletedPayment = "/api/\(version)/orders/%d/complete"
       
        static let urlTablesManagement = String(format:"/api/%@/tables/manage",version)
        static let urlTableManage = String(format: "/api/%@/tables/manage", version)
        
        static let urlCreateArea = String(format: "/api/%@/areas/manage",version )
        
        static let urlAllFoodsManagement = String(format: "/api/%@/foods/branch",version )
        static let urlAllNotesManagement = "/api/\(version)/order-detail-notes"
        static let urlAllCategoriesManagement = "/api/\(version)/categories"
        
        static let urlPrinters = String(format: "/api/%@/restaurant-kitchen-printers",version )
        
        static let urlOpenWorkingSession = String(format: "/api/%@/order-session/open-session",version )
        static let urlWorkingSession = "/api/\(version)/employees/%d/branch-working-sessions"
        static let urlCheckWorkingSessions = String(format: "/api/%@/order-session/check-working-session",version )
        static let urlSharePoint = "/api/\(version)/orders/%d/share-point"
        
        static let urlCurrentPoint = "/api/\(version)/employees/%d/next-salary-target"
        
        static let urlAssignCustomerToBill = "/api/\(version)/orders/%d/assign-to-customer"
        static let urlApplyVAT = "/api/\(version)/orders/%d/apply-vat"
        static let urlFees = String(format: "/api/%@/addition-fees",version )
        static let urlCreateFee = String(format: "/api/%@/addition-fees/create",version )
        
        static let urlFoodsNeedPrint = String(format: "/api/%@/orders/is-print",version )
        static let urlRequestPrintChefBar = "/api/\(version)/orders/%d/print"
        static let urlUpdateReadyPrinted = String(format: "/api/%@/orders/is-print",version )
        static let urlEmployees = String(format: "/api/%@/employees",version )
        static let urlKitchens = String(format: "/api/%@/restaurant-kitchen-places",version )
        static let urlUpdateKitchen = "/api/\(version)/restaurant-kitchen-places/%d"
        static let urlUpdatePrinter = "/api/\(version)/restaurant-kitchen-printers/%d/update"
        static let urlCreateUpdateNote = String(format:"/api/%@/order-detail-notes/manage",version )
        static let urlCreateCategory = String(format: "/api/%@/categories/create",version )
        static let urlOrdersHistory = "/api/\(version)/employees/%d/orders-history"
        static let urlUnits = String(format: "/api/%@/foods/unit",version )
        static let urlUpdateCategory = "/api/\(version)/categories/%d/update"
        
        static let urlCreateFood = String(format: "/api/%@/foods/create",version )
        static let urlEditFood =  "/api/\(version)/foods/%d/update"
        static let urlCities = String(format: "/api/%@/administrative-units/cities",version )
        static let urlDistrict = String(format: "/api/%@/administrative-units/districts",version )
        static let urlWards = String(format: "/api/%@/administrative-units/wards",version )
        static let urlUpdateProfile = "/api/\(version)/employees/%d/change-profile"
        static let urlUpdateProfileInfo = "/api/\(version)/employee-profile/%d"
        
        static let urlChangePassword = "/api/\(version)/employees/%d/change-password"
        static let urlCloseTable = "/api/\(version)/tables/%d/close"
        
        static let urlFeedbackAndSentError = String(format: "/api/%@/employees/feedback",version )
        static let urlWorkingSessionValue = String(format: "/api/%@/order-session/working-session-value",version )
        static let urlCloseWorkingSession = String(format: "/api/%@/order-session/close-session",version )
        
        static let urlAssignWorkingSession = String(format: "/api/%@/order-session-employee/create",dashboard_version )
        
        static let urlForgotPassword = String(format: "/api/%@/employees/forgot-password",version_oauth_service )
        static let urlVerifyOTP = String(format: "/api/%@/employees/verify-code", version_oauth_service)
        static let urlVerifyPassword = String(format: "/api/%@/employees/verify-change-password", version_oauth_service)
        //static let urlNotes = String(format: "/api/%@/food-notes", version)
        static let urlNotes = String(format: "/api/%@/order-detail-notes", version)// tagview
        
        static let urlGift = String(format: "/api/%@/customer-gifts/qr-code-gift", version)
        static let urlUseGift = "/api/\(version)/orders/%d/use-customer-gift-food"
     
        
        static let urlNotesByFood = "/api/\(version)/food-notes/by-food-id/%d"
        static let urlVATDetails = "/api/\(version)/orders/%d/order-detail-by-vat-percent"
       
        static let urlGenerateLink = "/api/\(upload_api_version)/media/generate"
        static let urlUpdateOtherFeed = "/api/\(version)/addition-fees/%d"
        
        static let urlGetAdditionFee = "/api/\(version)/addition-fees/%d"
        static let urlUpdateAdditionFee = "/api/\(version)/addition-fees/%d/update"
        static let urlCancelAdditionFee = "/api/\(version)/addition-fees/%d/change-status" // chi phí nguyên liệu và chi phí khác
        static let urlUpdateOtherFee = "/api/\(version)/addition-fees/%d/update" // update chi phí khác

        static let urlMoveExtraFoods =  "/api/\(version)/order-extra-charges/%d/move"
        
        static let urlGetFoodsBookingStatus = "api/\(version)/order-details/%d/booking" //v4 lấy danh sách food khi trạng thái bàn booking
        
        static let urlUpdateBranch = "api/\(version)/branches/%d" // update branch

        static let urlHealthCheckChangeFromServer = "/api/\(version_check_data)/food-health-check/check" // Kiểm tra xem server cho thay đổi món ăn không để lấy menu mới về
        
        static let urlHealthCheckForBuffet = "/api/\(version_check_data)/food-menu-buffet/check" // Kiểm tra xem server cho thay đổi món ăn trong vé buffet không để lấy menu mới về
        
        static let urlPostCreateOrder = "api/\(version)/orders/create" // api tao đơn hang
        
        static let urlGetTotalAmountOfOrders = "api/\(version)/orders/total-amount" // api lấy tổng giá trị của tất cả đơn hàng của quán
        
        static let urlPostApplyExtraChargeOnTotalBill = "/api/\(version)/orders/%d/apply-extra-charge" // api app dụng áp dụng phụ thu trên tổng bill
        
        static let urlPostPauseService = "/api/\(version)/order-details/service/%d/pause" // api tạm ngưng và tiếp tục dịch vụ
        
        static let urlPostUpdateService = "/api/\(version)/order-details/service/%d/update" // api cập nhật service
        
        static let urlGetActivityLog = "/api/\(log_api_version)/logs/activity" // api cập nhật service
        
        static let urlPostApplyOnlyCashAmount = "/api/\(dashboard_version)/branches/%d/setting/is-apply-only-cash-amount" // api cập nhật service
        static let urlGetApplyOnlyCashAmount = "/api/\(dashboard_version)/branches/%d/setting/is-apply-only-cash-amount" // api cập nhật service
        static let urlInformationApp = "/api/public/versions" // Lấy danh sách cập nhật của ứng dụng
        
        static let urlPostApplyTakeAwayTable = "/api/\(version)/branches/%d/setting/is-apply-take-away-table"
        static let urlPostCreateTableList = "/api/\(version)/tables/create/list"
       
        static let urlGetPrintItem = "/api/print/v2" // Lấy danh sách cập nhật của ứng dụng
        
        static let urlgetBrandSetting = "/api/\(dashboard_version)/restaurant-brands/%d/setting"
        
        static let urlSendToKitchen = "/api/\(version)/order-details/send-to-kitchen"

        static let urlGetRestaurantBrandBankAccount = "/api/\(version)/restaurant-brand-bank-accounts"
        
        static let urlGetBankList = "/api/\(version)/restaurant-brand-bank-accounts/bank-list"
        
        static let urlGetBrandBankAccount = "/api/\(version)/restaurant-brand-bank-accounts/default"
        
        static let urlPostCreateBrandBankAccount = "/api/\(version)/restaurant-brand-bank-accounts/create"
        
        static let urlPostUpdateteBrandBankAccount = "/api/\(version)/restaurant-brand-bank-accounts/%d/update"
        static let urlPostDiscountOrderItem = "/api/\(version)/order-details/%d/discount"

        static let urlGetBuffetTickets = "/api/\(version)/buffet-ticket"
        static let urlGetDetailOfBuffetTicket = "/api/\(version)/foods/menu-buffet"
        static let urlGetFoodsOfBuffetTicket = "/api/\(version)/buffet-ticket/foods"
        static let urlPostCreateBuffetTicket = "/api/\(version)/order-buffets/create"
        static let urlPostUpdateBuffetTicket = "/api/\(version)/order-buffets/%d/update"
        static let urlPostCancelBuffetTicket = "/api/\(version)/order-buffets/%d/cancel"
        
        static let urlPostRemovePrintedItem = "/api/print/key/remove"
        
    }	
    
    
    struct AppFood {
        
        //VERSION APP FOOD
        private static let version_app_food = "v1"
        static let urlGetChannelFoodOrder = "/api/\(version_app_food)/channel-order-foods/list"
        static let urlGetOrderDetailOfChannelFood = "/api/\(version_app_food)/channel-order-foods/order-detail"
        static let urlGetDetailOfChannelOrderFoodToken = "/api/\(version_app_food)/channel-order-food-token/%d/detail"
        
        static let urlPostCreateTokenOfChannelFoodOrder = "/api/\(version_app_food)/channel-order-food-token/create"
        static let urlPostUpdateTokenOfChannelFoodOrder = "/api/\(version_app_food)/channel-order-food-token/update/%d"
        
        static let urlPostChangeConnectOfChannelOrderFoodToken = "/api/\(version_app_food)/channel-order-food-token/change-connection/%d"
        
        static let urlPostGofoodLoginRequest = "/goid/login/request"
        static let urlPostGoFoodToken = "/goid/token"
        
        static let urlGetOrderListOfFoodAp = "/api/\(version_app_food)/channel-order-foods/orders"
        static let urlGetOrderDetailOfFoodApp = "/api/\(version_app_food)/channel-order-foods/order-detail"
        static let urlPostConfirmOrderOfFoodApp = "/api/\(version)/order-channel-foods/%d/confirm"
        static let urlPostBatchConfirmOrderOfFoodApp = "/api/\(version)/order-channel-foods/batch-confirm"
    
        static let urlGetBranchFoodApp = "/api/\(dashboard_version)/branch-channel-food-branch-maps/list"
        static let urlPostAssignBranchFoodApp = "/api/\(dashboard_version)/branch-channel-food-branch-maps/assign"
        
        
        static let urlGetCommissionOfFoodApp = "/api/\(version_app_food)/branch-channel-food-commission-percent-maps/list"
        static let urlPostSetCommissionForFoodApp = "/api/\(version_app_food)/branch-channel-food-commission-percent-maps/setting"
        static let urlGetOrderHistoryOfFoodApp = "/api/\(version_app_food)/channel-order-foods/order/history"
        static let urlGetOrderHistoryDetailOfFoodApp = "/api/\(version_app_food)/channel-order-foods/order-detail"
        static let urlGetRevenueSumaryReportOfFoodApp = "/api/\(version_app_food)/channel-order-foods/revenue-sumary"
        
        
        static let urlPosRefreshOrderOfFoodApp = "/api/\(version_app_food)/channel-order-foods/order/refresh"
        static let urlGetConfirmedOrderOfFoodApp = "/api/\(version_app_food)/channel-order-foods/orders"
        static let urlGetChannelOrderFoodTokenList = "/api/\(version_app_food)/channel-order-food-token/list"
        static let urlGetChannelOrderFoodInforList = "/api/\(version_app_food)/channel-order-food-information/list"
        static let urlGetBranchesOfChannelOrderFood = "/api/\(version_app_food)/channel-order-foods/branches"
        
 
        
        static let urlGetAssignedBranchOfFoodApp = "/api/\(dashboard_version)/branch-channel-food-branch-maps/list-assigned"
    
        static let urlPostAssignBrachOfFoodApp = "/api/\(dashboard_version)/branch-channel-food-branch-maps/assign-multiple"
        
    }
    
    

    struct Chat {
 
        static let urlPostCreateGroupSuppport = "/api/\(version_chat_service)/conversation/create-group-support"
        static let urlGetMessageList = "/api/\(version_chat_service)/message/list-message"
        static let urlListMedia = "/api/\(version_upload_service)/media-store/list-media" // API Lấy danh sách Ảnh, Video, File, Link
    }
    
    
    struct NameReportEndPoint {
        
        // ========= API REPORT ==========
        
        static let urlReportRevenueByBrand = "/api/\(report_api_version)/order-restaurant-current-day"
        static let urlReportRevenueByTime = "/api/\(report_api_version)/order-restaurant-revenue-report"
        static let urlReportRevenueActivitiesInDayByBrand = String(format: "/api/\(report_api_version)/order-restaurant-revenue-cost-customer-by-branch")
        
        
        static let urlReportRevenueFeeProfit = "/api/\(report_api_version)/order-revenue-cost-profit-by-branch"
        static let urlReportRevenueByCategory = "/api/\(report_api_version)/order-restaurant-revenue-by-category"
        static let urlReportRevenueByEmployee = "/api/\(report_api_version)/order-revenue-current-by-employee"
        static let urlReportBusinessAnalytics = "/api/\(report_api_version)/order-restaurant-revenue-by-food"
        
        static let urlReportRevenueByAllEmployees = "/api/\(report_api_version)/order-restaurant-revenue-by-employee"
        
        static let urlReportFoods = "/api/\(report_api_version)/order-report-food"
        static let urlReportCancelFoods = "/api/\(report_api_version)/order-report-food-cancel"
        static let urlReportGiftedFoods = "/api/\(report_api_version)/order-report-food-gift"
        static let urlReportDiscount = "/api/\(report_api_version)/order-restaurant-discount-from-order"
        static let urlReportVAT = "/api/\(report_api_version)/window-order-report-data/vat"
        static let urlReportAreaRevenue = "/api/\(report_api_version)/window-area-revenue-rank"
        static let urlReportTableRevenue = "/api/\(report_api_version)/order-restaurant-revenue-by-table"
        
        
        //api report seemt====================
        static let urlOrderReportFood = "/api/\(version_report_service)/order-report-food" // Báo cáo món ăn, đồ uống, món khác
        static let urlOrderReportFoodCancel = "/api/\(version_report_service)/order-report-food-cancel" // Báo cáo món huỷ //@2
        static let urlOrderReportFoodGift = "/api/\(version_report_service)/order-report-food-gift" // Báo cáo món tặng //@3
        static let urlOrderReportFoodTakeAway = "/api/\(version_report_service)/order-report-food-take-away" // Báo cáo món ăn mang về //@4
        static let urlGetRevenueDetailByBrandId = "/api/\(version_upload_service)/order-restaurant-revenue-detail-by-restaurant-brand" // Doanh thu bán hàng trong ngày theo thương hiệu //@6
        static let urlGetRevenueDetailByBranch = "/api/\(version_upload_service)/order-restaurant-revenue-by-branch" // Doanh thu bán hàng trong ngày theo chi nhánh //@7
        static let urlGetRestaurantRevenueCostProfitEstimation = "/api/\(version_report_service)/order-restaurant-revenue-cost-profit/estimate" // Báo cáo doanh thu chi phí lợi nhuận ước tính //@8
        static let urlGetRestaurantRevenueCostProfitSum = "/api/\(version_report_service)/order-restaurant-revenue-cost-profit-synthetic" // Báo cáo doanh thu chi phí lợi nhuận tổng //@9
        // ============================ HẢI THANH API REPORT ============================
        static let urlReportOrderRestaurantDiscountFromOrder = "/api/\(version_report_service)/order-restaurant-discount-from-order" // Báo cáo lấy chi tiết các khoản chi phí của nhà hàng || Báo cáo giảm giá //@10
        static let urlReportRevenueGenral = "/api/\(version_report_service)/order-restaurant-revenue-report" // Báo cáo lấy doanh thu nhà hàng theo chi nhánh //@11
        static let urlReportRevenueArea = "/api/\(version_report_service)/order-restaurant-revenue-by-area" // Báo cáo lợi nhuận bán hàng theo khu vực //@12
        static let urlReportSurcharge = "/api/\(version_report_service)/order-restaurant-order-extra-charge" // Báo cáo phụ thu //@13
        static let urlRestaurantVATReport = "/api/\(version_report_service)/window-order-report-data/vat" // Báo cáo VAT //@14
        static let urlOrderCustomerReport = "/api/\(version_report_service)/order-customer-report" // Báo cáo lấy chi tiết các khoản chi phí của nhà hàng //@15
        // ========= API P&L REPORT ==========
        static let urlRestaurantPLReport = "/api/\(version_report_service)/restaurant-p-and-l-report" // Báo cáo P&L //@16
        // ========= API INVENTORY REPORT ==========
        static let urlWarehouseSessionImportReport = "/api/\(version_report_service)/warehouse-session-import" // Báo cáo nhập kho//@17
        
        // ========= API REVENUE EMPLOYEE REPORT ==========
        static let urlRenueByEmployeeReport = "/api/\(version_report_service)/order-restaurant-revenue-by-employee" //Báo cáo doanh thu nhân viên //@18
        static let urlReportOtherFood = "/api/\(version_report_service)/order-restaurant-revenue-by-food" // Báo cáo lợi nhuận món ăn //@
        static let urlReportRevenueProfitFood = "/api/\(version_report_service)/order-report-food" // Báo cáo lợi nhuận món ăn //@

        static let urlGetRestaurantRevenueCostProfitReality = "/api/\(version_report_service)/order-restaurant-revenue-cost-profit/reality" // Báo cáo doanh thu chi phí lợi nhuận thực tế
        
        static let urlGetFoodAppReport = "/api/\(version_report_service)/food-channel-revenue" // Báo cáo doanh thu của các đối tác trên app food
    }
    
    struct SOCKET_GATEWAY {
        static let CHAT_DOMAIN = "http://172.16.2.240:9013"
    }
    
    
    
    struct TECHRESSHOP {
        static let version_TECHRES_SHOP_service = "v1"
        
        static let urlGetTechresShopDeviceList = "/api/\(version)/restaurant-order-device-requests/list-product" // Báo cáo doanh thu của các đối tác trên app food
        static let urlPostCreateTechresShopOrder = "/api/\(version)/restaurant-order-device-requests/create-product-order" // Báo cáo doanh thu của các đối tác trên app food
        static let urlGetTechresShopOrder = "/api/\(version)/restaurant-order-device-requests/list-product-order" // Báo cáo doanh thu của các đối tác trên app food
        static let urlGetTechresShopOrderDetail = "/api/\(version)/restaurant-order-device-requests/%d/detail-product-order" // Báo cáo doanh thu của các đối tác trên app food
   
        
    }
    
  
}





struct CHAT_SOCKET_KEY {
    static let version_socket = "v1"
    
    static let JOIN_ROOM = "join-room"
    static let LISTEN_JOIN_ROOM = "listen-join-room"
    static let LEAVE_ROOM = "leave-room"
    
    static let LISTEN_MESSAGE_TEXT = "listen-message-text-\(version_socket)"
    static let LISTEN_MESSAGE_IMAGE = "listen-message-image-\(version_socket)"
    static let LISTEN_MESSAGE_VIDEO = "listen-message-video-\(version_socket)"
    static let LISTEN_MESSAGE_FILE = "listen-message-file-\(version_socket)"
    static let LISTEN_MESSAGE_STICKER = "listen-message-sticker-\(version_socket)"
    static let LISTEN_MESSAGE_REVOKE = "listen-message-revoke-\(version_socket)"
    static let LISTEN_MESSAGE_AUDIO = "listen-message-audio-\(version_socket)"
    static let LISTEN_MESSAGE_REACTION = "listen-reaction-message-\(version_socket)"
    static let LISTEN_MESSAGE_PINDED = "listen-message-pinned-\(version_socket)"
    static let LISTEN_MESSAGE_REMOVE_PINDED = "listen-message-remove-pinned-\(version_socket)"
    static let LISTEN_MESSAGE_REPLY = "listen-message-reply-\(version_socket)"
    static let LISTEN_MESSAGE_CREATE_VOTE = "listen-message-create-vote-\(version_socket)"
    static let LISTEN_MESSAGE_VOTE = "listen-message-vote-\(version_socket)"
    static let LISTEN_MESSAGE_CHANGE_VOTE = "listen-message-change-vote-\(version_socket)"
    static let LISTEN_MESSAGE_BLOCK_VOTE = "listen-message-block-vote-\(version_socket)"
    static let LISTEN_CREATE_REMINDER = "listen-create-reminder-\(version_socket)"
    static let LISTEN_USER_CANCEL_REMINDER = "listen-cancel-reminder-\(version_socket)"
    static let LISTEN_USER_REJECT_REMINDER = "listen-user-reject-reminder-\(version_socket)"
    static let LISTEN_USER_JOIN_REMINDER = "listen-user-join-reminder-\(version_socket)"
    static let LISTEN_MESSAGE_REMINDER = "listen-message-reminder-\(version_socket)"
    static let LISTEN_SETTING_CONVERSATION = "listen-setting-conversation-\(version_socket)"
    static let LISTEN_NEW_CONVERSATION = "listen-new-conversation-\(version_socket)"
    static let LISTEN_ADD_MEMBER_CONVERSATION = "listen-add-member-conversation-\(version_socket)"
    static let LISTEN_REMOVE_MEMBER_CONVERSATION = "listen-remove-member-conversation-\(version_socket)"
    static let LISTEN_DISBAND_CONVERSATION = "listen-disband-conversation-\(version_socket)"
    static let LISTEN_OUT_CONVERSATION = "listen-out-conversation-\(version_socket)"
    static let LISTEN_UPDATE_NAME_CONVERSATION = "listen-update-name-conversation-\(version_socket)"
    static let LISTEN_UPDATE_AVATAR_CONVERSATION = "listen-update-avatar-conversation-\(version_socket)"
    static let LISTEN_ADD_DEPUTY_CONVERSATION = "listen-add-deputy-conversation-\(version_socket)"
    static let LISTEN_REMOVE_DEPUTY_CONVERSATION = "listen-remove-deputy-conversation-\(version_socket)"
    static let LISTEN_TYPING_ON_MESSAGE = "listen-typing-on-\(version_socket)"
    static let LISTEN_TYPING_OFF_MESSAGE = "listen-typing-off-\(version_socket)"
    static let LISTEN_MESSAGE_ORDER = "listen-message-order-\(version_socket)"
    static let LISTEN_MY_NOTIFY = "listen-my-notify-\(version_socket)"
    static let LISTEN_FINISH_SUPPORT = "listen-finish-support-\(version_socket)"
    
    static let MESSAGE_TEXT = "message-text-\(version_socket)"
    static let MESSAGE_IMAGE = "message-image-\(version_socket)"
    static let MESSAGE_VIDEO = "message-video-\(version_socket)"
    static let MESSAGE_AUDIO = "message-audio-\(version_socket)"
    static let MESSAGE_STICKER = "message-sticker-\(version_socket)"
    static let MESSAGE_ROVOKER = "message-revoke-\(version_socket)"
    static let MESSAGE_PINNED = "message-pinned-\(version_socket)"
    static let MESSAGE_REMOVE_PINNED = "message-remove-pinned-\(version_socket)"
    static let MESSAGE_REPLY = "message-reply-\(version_socket)"
    static let MESSAGE_FILE = "message-file-\(version_socket)"
    static let MESSAGE_REACTION = "reaction-message-\(version_socket)"
    static let TYPING_ON_MESSAGE = "typing-on-\(version_socket)"
    static let TYPING_OFF_MESSAGE = "typing-off-\(version_socket)"
    static let MESSAGE_ORDER = "message-order-\(version_socket)"
    
    static let SOCKET_MESSAGE_ERROR = "socket-error-\(version_socket)"
}

