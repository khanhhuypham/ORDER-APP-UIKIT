//
//  Configs.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 14/01/2023.
//

import UIKit


//======== Role Name ========
var OWNER = "OWNER"
var FOOD_MANAGER = "FOOD_MANAGER"
var GENERAL_MANAGER = "GENERAL_MANAGER"
var CHEF_MANAGER = "CHEF_MANAGER"
var ACCOUNTING_MANAGER = "ACCOUNTING_MANAGER"
var CANCEL_COMPLETED_FOOD = "CANCEL_COMPLETED_FOOD"
var EMPLOYEE_MANAGER = "EMPLOYEE_MANAGER"
var RESTAURANT_MANAGER = "RESTAURANT_MANAGER"
var CASHIER_ACCESS = "CASHIER_ACCESS"
var TICKET_MANAGEMENT = "TICKET_MANAGEMENT"

var DISCOUNT_FOOD = "DISCOUNT_FOOD"
var DISCOUNT_ORDER = "DISCOUNT_ORDER"
var ADD_FOOD_NOT_IN_MENU = "ADD_FOOD_NOT_IN_MENU"
var BRANCH_MANAGER = "BRANCH_MANAGER"
var AREA_TABLE_MANAGER = "AREA_TABLE_MANAGER"
var CANCEL_DRINK = "CANCEL_DRINK"
var NEWS_MANAGER = "NEWS_MANAGER"
var UNREACHABLE_NETWORK = "UNREACHABLE_NETWORK"
var REACHABLE_NETWORK = "REACHABLE_NETWORK"
var ACTION_ON_FOOD_AND_TABLE = "ACTION_ON_FOOD_AND_TABLE"
var ORDER_FOOD = "ORDER_FOOD"
var SHARE_POINT = "SHARE_POINT_IN_BILL"

var VIEW_ALL = "VIEW_ALL"
// ========= Define ORDER STATUS ============
var ORDER_STATUS_OPENING = 0 //ĐANG PHỤC VỤ
var ORDER_STATUS_REQUEST_PAYMENT = 1 // YÊU CẦU THANH TOÁN
var ORDER_STATUS_WAITING_MERGED=3
var ORDER_STATUS_WAITING_WAITING_COMPLETE=4// CHỜ THU TIỀN
var ORDER_STATUS_COMPLETE=2// HOAN TAT
var ORDER_STATUS_DEBT_COMPLETE=5// HOAN TAT & NO BILL 
var ORDER_STATUS_CANCEL=8 // ĐÃ HUỶ
// ========= Define ORDER DETAIL STATUS ============
var PENDING = 0; //Mon moi goi
var COOKING = 1; // Dang nau
var DONE = 2; // Hoan tat mon
var NOT_ENOUGH = 3; // het mon
var CANCEL_FOOD = 4; // Huy mon
var SERVICE_BLOCK_USING = 7 // dịch vụ đang sử dụng
var SERVICE_BLOCK_STOPPED = 8 //  dịch vụ đã ngưng

// ========= Define CATEGORY TYPE ============
var CATEGORY_OF_FOOD = 1
var CATEGORY_OF_DRINK = 2
var CATEGORY_OF_OTHER = 3


// ========= Define FOOD TYPE ============
var FOOD = 1
var DRINK = 2
var OTHER=3
var SEAFOOD=4
var SERVICE=5


var ADD_GIFT = 1
var ADD_FOOD = 0
var ADD_ALL_FOOD = -1
var ALL = -1

var SELL_BY_WEIGHT = 1; //
var TYPE_BEER = 2; // Beer
var TYPE_OTHER = 3; // Khac
var TYPE_COOKED = 1; //Mon nau
var TYPE_GRILL = 2; // Mon nuong
var TYPE_SEA_FOOD = 3; // Hai san tuoi song





// =========== DEFINE GIẢI PHÁP BÁN HÀNG =========
var BRANCH_TYPE_LEVEL_ONE = 1
var BRANCH_TYPE_LEVEL_TWO = 2
var BRANCH_TYPE_LEVEL_THREE = 3


//=========== BRANCH TYPE OPTION ========
var BRANCH_TYPE_OPTION_ONE = 1// OPTION 1
var BRANCH_TYPE_OPTION_TWO = 2// OPTION 4
var BRANCH_TYPE_OPTION_THREE = 3// OPTION 3

// =========== DEFINE GIẢI PHÁP QUẢN TRỊ =========
var GPQT_LEVEL_ONE = 1
var GPQT_LEVEL_TWO = 2
var GPQT_LEVEL_THREE = 3
var GPQT_LEVEL_FOUR = 4
var GPQT_LEVEL_FIVE = 5
var GPQT_LEVEL_SIX = 6
var GPQT_LEVEL_SEVEN = 7
var GPQT_LEVEL_EIGHT = 8
var GPQT_LEVEL_NINE = 9

// ========= Define STATUS  ============
var ACTIVE = 1
var DEACTIVE = 0


// ========= Define MEDIA TYPE  ============
var TYPE_VIDEO = 1
var TYPE_IMAGE = 0
var TYPE_AUDIO = 2
var TYPE_FILE = 3
var TYPE_LINK = 4


// ========= Define STATUS TABLE ============
var STATUS_TABLE_USING = 2
var STATUS_TABLE_CLOSED = 0
var STATUS_TABLE_BOOKING = 1
var STATUS_TABLE_MERGED = 3

// ========= Define STATUS BOOKING ============
let STATUS_BOOKING_COMPLETED = 4// hoàn tất
let STATUS_BOOKING_CANCEL = 5 // hủy
let STATUS_BOOKING_EXPIRED = 8// Hết hạn
let STATUS_BOOKING_WAITING_CONFIRM = 1// đang chờ nhà hàng xác nhận
let STATUS_BOOKING_WAITING_SETTUP = 2// Chờ setup
let STATUS_BOOKING_SET_UP = 9// đã set up chờ nhận khách
let STATUS_BOOKING_WAITING_COMPLETE = 3 // đơn hàng đã bắt đầu, chờ hoàn tất hóa đơn
let STATUS_BOOKING_CONFIRMED = 7 // Đã xác nhận


//=========== Config Printer ========
var KEY_PRINTER_BILL = "KEY_PRINTER_BILL"
var KEY_CHEF_BARS = "KEY_CHEF_BARS"
//var KEY_FOOD_APP_PRINTER = "KEY_FOOD_APP_PRINTER"
//var KEY_CHEF_BAR_STATUS_ACTIVE = "KEY_CHEF_BAR_STATUS_ACTIVE"
//var KEY_PRINTER_BILL_STATUS_ACTIVE = "KEY_PRINTER_BILL_STATUS_ACTIVE"

var KEY_PRINTER_CHEF = "KEY_PRINTER_CHEF"
var KEY_PRINTER_BAR = "KEY_PRINTER_BAR"
var PRINTER_PORT = 9100

var PRINT_TYPE_ADD_FOOD = 0
var PRINT_TYPE_UPDATE_FOOD = 1
var PRINT_TYPE_CANCEL_FOOD = 2
var PRINT_TYPE_RETURN_FOOD = 3



var REPORT_TYPE_TODAY = 1 //lấy theo ngày
var REPORT_TYPE_YESTERDAY = 9  // lấy theo ngày hôm qua
var REPORT_TYPE_THIS_WEEK = 2 // lấy theo tuần
var REPORT_TYPE_THIS_MONTH = 3 // lấy theo tháng
var REPORT_TYPE_THREE_MONTHS = 4 // lấy theo 3 tháng gần nhất
var REPORT_TYPE_THIS_YEAR = 5 // lấy theo năm
var REPORT_TYPE_LAST_YEAR = 11//Lấy theo năm trước
var REPORT_TYPE_THREE_YEAR = 6// lấy theo 3 năm gần nhất
var REPORT_TYPE_LAST_MONTH = 10 // lấy theo tháng trước
var REPORT_TYPE_ALL_YEAR = 8 // lấy tất cả thời gian

var APP_STORE_URL = "https://apps.apple.com/vn/app/techres-order-g%E1%BB%8Di-m%C3%B3n/id1468724786"

// ============ WORKINGSESSION TYPE ==========
var  CLOSE_SHIFT = 1; // Bắt buộc đóng ca trước khi làm việc
var  OPENED_SHIFT = 2; // Ca làm việc không phải của nó mở
var  EXPIRED_SHIFT = 3; // Ca làm việc hết hạn

var  CLOSE_SHIFT_LOGOUT = 0; // Đóng ca và đăng xuất
var  CLOSE_SHIFT_CONTINUE = 1; // Đóng ca và tiếp tục làm việc

var BAR = 0
var CHEF = 1
var CASHIER = 2
var TEM = 4
var SEA_FOOD = 3


var PRINTER_WIFI = 0
var PRINTER_BLUETOOTH = 4
var PRINTER_SUNMI = 2
var PRINTER_IMIN = 1
var PRINTER_USB = 3
