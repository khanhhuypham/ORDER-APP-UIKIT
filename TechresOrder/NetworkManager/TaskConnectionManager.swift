//
//  TaskConnectionManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//

import UIKit
import Moya
import Alamofire
extension ConnectionManager {
    
    /// The parameter encoding. `URLEncoding.default` by default.
    private func encoding(_ httpMethod: HTTPMethod) -> ParameterEncoding {
        var encoding : ParameterEncoding = JSONEncoding.prettyPrinted
        if httpMethod == .get{
            encoding = URLEncoding.default
        }
        return encoding
    }
    
    var task: Task {
        dLog(headers)
        switch self {
            case .sessions:
                return .requestParameters(parameters: [
                    "device_uid":Utils.getUDID()
                ], encoding: self.encoding(.get))
                
            case .config(let restaurant_name):
                return .requestParameters(parameters: [
                    "project_id": Constants.apiKey,
                    "device_uid": Utils.getUDID(),
                    "restaurant_name": restaurant_name
                ], encoding: self.encoding(.get))
                
          
        
            case .checkVersion:
                return .requestParameters(parameters: [
                    "os_name":Utils.getOSName()
                ],encoding: self.encoding(.get))
                
            case .regisDevice(let deviceRequest):
                return .requestParameters(
                    parameters: [
                        "device_uid": deviceRequest.device_uid,
                        "push_token": deviceRequest.push_token,
                        "app_type": deviceRequest.app_type,
                        "os_name":Utils.getOSName(),
                        "platform_type":Utils.getPlatFormType()
                    ],
                    encoding: self.encoding(.post)
                )
            
            case .login(let username, let password):
               
                return .requestParameters(
                    parameters: [
                        "username": username,
                        "password": Utils.encoded(str: password),
                        "device_uid":Utils.getUDID(),
                        "app_type":Utils.getAppType(),
                        "push_token": ManageCacheObject.getPushToken()
                    ], 
                    encoding: self.encoding(.post)
                )
                
            case .setting(let branch_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "udid":Utils.getUDID(),
                        "app_type":Utils.getAppType()
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .areas(let branch_id, let status):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
            
            
            case .tables(let branch_dd, let area_id, let status, let exclude_table_id, let order_statuses,let buffet_ticket_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_dd,
                        "area_id": area_id,
                        "status":status,
                        "exclude_table_id":exclude_table_id,
                        "order_statuses":order_statuses,
                        "is_active": "",
                        "buffet_ticket_id": buffet_ticket_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            
            
            case .brands(let key_search, let status):
                return .requestParameters(
                    parameters: [
                        "key_search": key_search,
                        "status":status
                    ],
                    encoding: self.encoding(.get)
                )
            
            
            case .branches(let brand_id, let status):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": brand_id,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .orders(let userId, let order_status, let key_word, let branch_id,let is_take_away):
                return .requestParameters(
                    parameters: [
                        "employee_id": userId,
                        "order_status": order_status,
                        "key_word": key_word,
                        "branch_id":branch_id,
                        "is_take_away":is_take_away
                    ],
                    encoding: self.encoding(.get))
            
            case .order(let order_id, let branch_id):
                return .requestParameters(
                    parameters: [
                        "id": order_id,
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .foods(let branch_id, let area_id, let category_id, let category_type, let is_allow_employee_gift, let is_sell_by_weight, let is_out_stock, let keyword, let limit, let page):
                return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .addFoods(let branch_id, let order_id, let foods, let is_use_point):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_id": order_id,
                        "foods": foods.toJSON(),
                        "is_use_point": is_use_point
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .addGiftFoods(let branch_id, let order_id, let foods, let is_use_point):
            
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_id": order_id,
                        "foods": foods.toJSON(),
                        "is_use_point": is_use_point
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .kitchenes(let branch_id, let brand_id, let status):
                
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "brand_id": brand_id,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .vats:
                return .requestParameters(
                    parameters:[:],
                    encoding: self.encoding(.get)
                )
                
            case .addOtherFoods(let branch_id, let order_id, let food):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_id": order_id,
                        "price": food.price,
                        "quantity": food.quantity,
                        "note":food.note,
                        "restaurant_vat_config_id": food.restaurant_vat_config_id,
                        "restaurant_kitchen_place_id":food.restaurant_kitchen_place_id,
                        "food_name": food.food_name,
                        "is_allow_print":food.is_allow_print
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .addNoteToOrderDetail(let branch_id, let order_detail_id, let note):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "id": order_detail_id,
                        "note": note
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .reasonCancelFoods(let branch_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .cancelFood(let branch_id, let order_id, let reason, let order_detail_id, let quantity):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "id": order_id,
                        "reason":reason,
                        "order_detail_id": order_detail_id,
                        "quantity":quantity
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .updateFoods(let branch_id, let order_id, let foods):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "id": order_id,
                        "order_details":foods.toJSON()
                    ],
                    encoding: self.encoding(.post))
                
            case .ordersNeedMove(let branch_id, let order_id, let food_status):
                return .requestParameters(
                    parameters: [
                        "id": order_id,
                        "branch_id": branch_id,
                        "food_status": food_status
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .moveFoods(let branch_id, let order_id, let destination_table_id, let target_table_id, let foods_move):
                return .requestParameters(
                    parameters: [
                        "from_order_id": order_id,
                        "destination_table_id":destination_table_id,
                        "to_table_id": target_table_id,
                        "branch_id": branch_id,
                        "list_food": foods_move.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .getOrderDetail(let order_id, let branch_id, let is_print_bill, let food_status):
                return .requestParameters(
                    parameters: [
                        "id": order_id,
                        "branch_id": branch_id,
                        "is_print_bill": is_print_bill,
                        "food_status": food_status
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .openTable(let table_id):
                return .requestParameters(
                    parameters: [
                        "table_id": table_id
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .discount(_,let branch_id, let food_discount_percent, let drink_discount_percent, let total_amount_discount_percent, let note):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "food_discount_percent": food_discount_percent,
                        "drink_discount_percent": drink_discount_percent,
                        "total_amount_discount_percent": total_amount_discount_percent,
                        "note": note
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .moveTable(let branch_id,  let destination_table_id, let target_table_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "id": destination_table_id,
                        "table_id": target_table_id
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .mergeTable(let branch_id,  let destination_table_id, let target_table_ids):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "destination_table_id": destination_table_id,
                        "table_ids": target_table_ids
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .profile(let branch_id,  let employee_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "id": employee_id
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .extra_charges(let restaurant_brand_id, let branch_id,  let status):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id":restaurant_brand_id,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .addExtraCharge(let branch_id, let order_id,  let extra_charge_id, let name, let price, let quantity, let note):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id": order_id,
                        "extra_charge_id": extra_charge_id ,
                        "name": name ,
                        "price": price ,
                        "quantity": quantity,
                        "note": note
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .returnBeer(let branch_id, let order_id,  let quantity, let order_detail_id, let note):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "id": order_id,
                        "quantity": quantity,
                        "order_detail_id":order_detail_id,
                        "note":note
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .reviewFood(let order_id,  let review_data):
                return .requestParameters(
                    parameters: [
                        "order_id": order_id,
                        "review_data": review_data.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .getFoodsNeedReview(let branch_id, let order_id):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id": order_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .updateCustomerNumberSlot(let branch_id, let order_id, let customer_slot_number):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id": order_id,
                        "customer_slot_number":customer_slot_number
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .requestPayment(let branch_id, let order_id, let payment_method, let is_include_vat):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id": order_id,
                        "payment_method":payment_method,
                        "is_include_vat":is_include_vat
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .completedPayment(let branch_id, let order_id, let cash_amount, let bank_amount, let transfer_amount, let payment_method_id, let tip_amount):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id": order_id,
                        "cash_amount":cash_amount,
                        "bank_amount":bank_amount,
                        "transfer_amount":transfer_amount,
                        "payment_method_id":payment_method_id,
                        "tip_amount":tip_amount
                    ],
                    encoding: self.encoding(.post)
                )
                

            
            case .createArea(let branch_id, let area, let is_confirmed):
                var parameter:[String:Any] = [
                    "id": area.id,
                    "branch_id":branch_id,
                    "name": area.name,
                    "status":area.status,
                ]
                if is_confirmed != nil{
                    parameter.updateValue(is_confirmed, forKey: "is_confirmed")
                }
                
                return .requestParameters(parameters: parameter,encoding: self.encoding(.post))

            
            case .foodsManagement(let branch_id, let is_addition, let status, let category_types, let restaurant_kitchen_place_id):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "is_addition": is_addition,
                        "status": status,
                        "category_types": category_types,
                        "restaurant_kitchen_place_id": restaurant_kitchen_place_id
                    ],
                    encoding: self.encoding(.get)
                )

            case .categoriesManagement(let brand_id, let status, let category_types):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id":brand_id,
                        "status": status,
                        "category_types":category_types
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .notesManagement(let branch_id, let status):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .createTable(let branch_id, let table_id, let table_name, let area_id, let total_slot, let status):
                 return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "table_id":table_id,
                        "table_name":table_name,
                        "area_id":area_id,
                        "total_slot":total_slot,
                        "status":status
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .prints(let branch_id, let is_have_printer, let is_print_bill, let status):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "is_have_printer": is_have_printer,
                        "is_print_bill": is_print_bill,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .openSession(let before_cash, let branch_working_session_id):
                 return .requestParameters(
                    parameters: [
                        "before_cash":before_cash,
                        "branch_working_session_id": branch_working_session_id
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .workingSessions(let branch_id, let employee_id):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "employee_id": employee_id
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .checkWorkingSessions:
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.get)
                )
                
            case .sharePoint(let order_id, let employee_list):
                 return .requestParameters(
                    parameters: [
                        "order_id":order_id,
                        "employee_list": employee_list.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .employeeSharePoint(let branch_id, let order_id):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id": order_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .currentPoint(let employee_id):
                return .requestParameters(
                    parameters: [
                        "employee_id":employee_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .assignCustomerToBill(let order_id, let qr_code):
                 return .requestParameters(
                    parameters: [
                        "order_id":order_id,
                        "qr_code": qr_code
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .applyVAT(let branch_id, let order_id, let is_apply_vat):
                 return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "order_id":order_id,
                        "is_apply_vat":is_apply_vat
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .fees(let branch_id, let restaurant_budget_id, let from, let to, let type, let is_take_auto_generated, let order_session_id, let report_type, let addition_fee_statuses, let is_paid_debt):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "restaurant_budget_id":restaurant_budget_id,
                        "from":from,
                        "to":to,
                        "type":type,
                        "is_take_auto_generated":is_take_auto_generated,
                        "order_session_id":order_session_id,
                        "report_type":report_type,
                        "addition_fee_statuses": addition_fee_statuses,
                        "is_paid_debt": is_paid_debt
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .createFee(let branch_id, let type, let amount, let title, let note, let date, let addition_fee_reason_type_id):
                
                 return .requestParameters(
                    parameters: [
                        "type": type,
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
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .foodsNeedPrint(let order_id):
                return .requestParameters(
                    parameters: [
                        "order_id":order_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .requestPrintChefBar(let order_id, let branch_id, let print_type):
                 return .requestParameters(
                    parameters: [
                        "id":order_id,
                        "branch_id":branch_id,
                        "type":print_type
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .updateReadyPrinted(let order_id, let order_detail_ids):
                 return .requestParameters(
                    parameters: [
                        "order_id":order_id,
                        "order_detail_ids":order_detail_ids,
                        "branch_id": ManageCacheObject.getCurrentBranch().id
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .employees(let branch_id, let is_for_share_point):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "is_for_share_point":is_for_share_point
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .kitchens(let branch_id, let status):
                return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "status":status
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .updateKitchen(let branch_id, let kitchen):
                 return .requestParameters(
                    parameters: [
                        "branch_id":branch_id,
                        "name":kitchen.name,
                        "id":kitchen.id,
                        "type": kitchen.type.rawValue,
                        "description":kitchen.description,
                        "printer_name":kitchen.printer_name,
                        "printer_ip_address":kitchen.printer_ip_address,
                        "printer_port":kitchen.printer_port,
                        "printer_paper_size":kitchen.printer_paper_size,
                        "print_number":kitchen.print_number,
                        "is_have_printer":kitchen.is_have_printer,
                        "is_print_each_food":kitchen.is_print_each_food,
                        "status":kitchen.status,
                        "printer_type":kitchen.connection_type.rawValue
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .updatePrinter(let printer):
                 return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .createNote(let branch_id, let noteRequest, let is_deleted):
                 return .requestParameters(
                    parameters: [
                        "id": noteRequest.id,
                        "content": noteRequest.content,
                        "delete": is_deleted,
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .createCategory(let name, let code,let description, let category_type, let status):
                 return .requestParameters(
                    parameters: [
                        "name":name,
                        "code":code,
                        "restaurant_brand_id": ManageCacheObject.getCurrentUser().restaurant_brand_id,
                        "description":description,
                        "category_type":category_type,
                        "status":status,
                        "id":0
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .ordersHistory(let brand_id,let branch_id,let id, let report_type,let time, let limit, let page, let key_search,let is_take_away_table, let is_take_away):
                return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .units:
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.get)
                )
                
            case .createFood(let branch_id, let food):
                 return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .generateFileNameResource(let medias):
                 return .requestParameters(
                    parameters: [
                        "medias": medias.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .updateFood(let branch_id, let food):
                 return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .updateCategory(let id, let name, let code,let description, let category_type, let status):
                 return .requestParameters(
                    parameters: [
                        "id":id,
                        "name":name,
                        "code":code,
                        "restaurant_brand_id": ManageCacheObject.getCurrentUser().restaurant_brand_id,
                        "description":description,
                        "category_type":category_type,
                        "status":status
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .cities(let limit):
                return .requestParameters(
                    parameters: [
                        "limit":limit,
                        "country_id": ACTIVE
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .districts(let city_id, let limit):
                return .requestParameters(
                    parameters: [
                        "city_id": city_id,
                        "limit":limit
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .wards(let district_id, let limit):
                return .requestParameters(
                    parameters: [
                        "district_id": district_id,
                        "limit": limit
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .updateProfile(let profileRequest):
                 return .requestParameters(
                    parameters: [
                        "name": profileRequest.name,
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
                        "node_token": profileRequest.node_token
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .updateProfileInfo(let infoRequest):
                 return .requestParameters(
                    parameters: [
                        "employee_id": infoRequest.employee_id,
                         "city_id": infoRequest.city_id,
                         "district_id": infoRequest.district_id,
                         "ward_id": infoRequest.ward_id,
                         "street_name": infoRequest.street_name
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .changePassword(let employee_id, let old_password, let new_password, let node_access_token):
                 return .requestParameters(
                    parameters: [
                        "id": employee_id,
                        "old_password": Utils.encoded(str: old_password),
                        "new_password": Utils.encoded(str: new_password),
                        "node_access_token": node_access_token
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .closeTable(let table_id):
                 return .requestParameters(
                    parameters: [
                        "id": table_id,
                        "branch_id":ManageCacheObject.getCurrentBranch().id
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .feedbackDeveloper(let email, let name, let phone, let type, let describe):
                 return .requestParameters(
                    parameters: [
                        "email": email,
                        "name":name ,
                        "phone":phone ,
                        "type":type ,
                        "describe":describe
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .sentError(let email, let name, let phone, let type, let describe):
                 return .requestParameters(
                    parameters: [
                        "email": email,
                        "name":name ,
                        "phone":phone ,
                        "type":type ,
                        "describe":describe
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .workingSessionValue:
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.get)
                )
                
            case .closeWorkingSession(let closeWorkingSessionRequest):
                 return .requestParameters(
                    parameters: [
                        "real_amount": closeWorkingSessionRequest.real_amount,
                        "cash_value":closeWorkingSessionRequest.cash_value.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .assignWorkingSession(let branch_id, let order_session_id):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_session_id":order_session_id
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .forgotPassword(let username):
            
                var payload:String = ""
            
                do {
                    let publicKey = try Utils.createPublicKey(from: ManageCacheObject.getConfig().rpk_public_key)
                    // Tạo đối tượng Dictionary
                    let jsonObject: [String: Any] = [
                        "username": username
                    ]
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                       // Chuyển đổi Data thành String để xem nội dung JSON
                       if let jsonString = String(data: jsonData, encoding: .utf8) {
                           let data = try Utils.encrypt(plainText: jsonString, publicKey: publicKey)
                           payload = data.base64EncodedString()
                       }
                } catch {
                    dLog("Error creating public key: \(error)")
                }
                  
            
                 return .requestParameters(
                    parameters: [
                        "payload": payload
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .verifyOTP(let restaurant_name, let user_name, let verify_code):
                 return .requestParameters(
                    parameters: [
                        "restaurant_name": restaurant_name,
                        "user_name": user_name,
                        "verify_code":verify_code
                    ],
                    encoding: self.encoding(.post)
                )
            case .verifyPassword(let user_name, let verify_code, let new_password):
                 return .requestParameters(
                    parameters: [
                        "username": user_name,
                        "verify_code": verify_code,
                        "new_password":Utils.encoded(str: new_password),
                        "app_type":Utils.getAppType(),
                        "device_uid":Utils.getUDID()
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .notes( let branch_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .gift(let qr_code_gift, let branch_id):
                return .requestParameters(
                    parameters: [
                        "qr_code_gift": qr_code_gift,
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .useGift(let branch_id, let order_id,  let customer_gift_id, let customer_id):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "orderId":order_id,
                        "customer_gift_id": customer_gift_id,
                        "customer_id": customer_id
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .tablesManager(let area_id, let branch_id, let status, let is_deleted):
                return .requestParameters(
                    parameters: [
                        "area_id": area_id,
                        "branch_id": branch_id,
                        "status":status ,
                        "is_deleted":is_deleted
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .notesByFood(let order_detail_id, let branch_id):
                return .requestParameters(
                    parameters: [
                        "food_id": order_detail_id,
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .getVATDetail(let order_id, let branch_id):
                return .requestParameters(
                    parameters: [
                        "order_id": order_id,
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
                
                //=========== API REPORT ========
                
            case .report_revenue_by_time(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .report_revenue_activities_in_day_by_branch(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .report_revenue_fee_profit(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .report_revenue_by_category(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .report_revenue_by_employee(let employee_id, let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date,
                        "employee_id": ManageCacheObject.getCurrentUser().id
                    ],
                    encoding: self.encoding(.get)
                )
            
            
            case .report_business_analytics(let restaurant_brand_id, let branch_id, let category_id, let category_types, let report_type, let date_string, let from_date,  let to_date, let is_cancelled_food, let is_combo, let is_gift, let is_goods, let is_take_away_food):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
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
                        "report_type": report_type
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .report_revenue_by_all_employee(restaurant_brand_id: let restaurant_brand_id, branch_id: let branch_id, report_type: let report_type, date_string: let date_string, from_date: let from_date, to_date: let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .cancelExtraCharge(branch_id: let branch_id, order_id: let order_id, reason: let reason, order_extra_charge: let order_extra_charge, let quantity):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "id": order_id,
                        "reason": reason,
                        "order_extra_charge": order_extra_charge,
                        "quantity": quantity
                    ],
                    encoding: self.encoding(.post)
                )
                
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
                return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.get)
                )
            
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
                return .requestParameters(
                    parameters: [
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
                        
                    ],
                    encoding: self.encoding(.get)
                )
            
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
                return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .report_discount(
                let restaurant_brand_id,
                let branch_id,
                let report_type,
                let date_string,
                let from_date,
                let to_date
            ):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .report_VAT(
                let restaurant_brand_id,
                let branch_id,
                let report_type,
                let date_string,
                let from_date,
                let to_date
            ):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .report_area_revenue(let restaurant_brand_id,let branch_id,let report_type,let date_string,let from_date,let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .report_table_revenue(let restaurant_brand_id,let branch_id,let area_id,let report_type,let date_string,let from_date,let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "area_id":area_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .updateOtherFeed(_, let branch_id, let brand_id, let status):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "brand_id": brand_id,
                        "status": status
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .getAdditionFee(_):
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.get)
                )
            
            case .updateAdditionFee(let id, let date, let note, let amount, let is_count_to_revenue, let object_type, let type, let payment_method_id, let cancel_reason, let branch_id, let object_name, let addition_fee_status, let addition_fee_reason_type_id):
                 return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .moveExtraFoods(branch_id: let branch_id, order_id: let order_id,let target_order_id, foods: let foods):
                 return .requestParameters(
                    parameters: [
                        "order_id": target_order_id,
                        "branch_id": branch_id,
                        "list_extra_charge": foods.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
            case .updateOtherFee(let id, let date, let note, let amount, let is_count_to_revenue, let payment_method_id ,  let branch_id, let object_name,let addition_fee_status, let addition_fee_reason_type_id):
                 return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .cancelAdditionFee(let id, let cancel_reason, let branch_id, let addition_fee_status):
                 return .requestParameters(
                    parameters: [
                        "id": id,
                        "cancel_reason": cancel_reason,
                        "branch_id": branch_id,
                        "addition_fee_status": addition_fee_status
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .getFoodsBookingStatus(order_id: let order_id):
                return .requestParameters(
                    parameters: [
                        "order_id": order_id
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .updateBranch(let branch):
                 return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.post)
                )
                
                // API REPORT SEEMT
            case .getReportOrderRestaurantDiscountFromOrder(let restaurant_brand_id,  let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getOrderReportFoodCancel(let restaurant_brand_id, let branch_id, let type, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "type": type,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .getOrderReportFoodGift(let restaurant_brand_id, let branch_id, let type_sort, let is_group, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "type_sort": type_sort,
                        "is_group": is_group,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getOrderReportTakeAwayFood(let restaurant_brand_id, let branch_id, let report_type, let date_string, let food_id, let is_gift, let is_cancel_food, let key_search, let from_date, let to_date, let page, let limit):
                return .requestParameters(
                    parameters: [
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
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantRevenueCostProfitEstimation(let restaurant_brand_id, let branch_id, let report_type,let date_string,let from_date,let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date,
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getOrderCustomerReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getReportRevenueGenral(let restaurant_brand_id,  let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getReportRevenueArea(let restaurant_brand_id,  let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getReportSurcharge(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getReportRevenueProfitFood(let restaurant_brand_id, let branch_id, let category_types, let food_id, let is_goods, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "category_types": category_types,
                        "food_id": food_id,
                        "is_goods": is_goods,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantOtherFoodReport(let restaurant_brand_id, let branch_id, let category_types, let food_id, let is_goods, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "category_types": category_types,
                        "food_id": food_id,
                        "is_goods": is_goods,
                        "report_type": report_type,
                        "date_string": date_string,
                        "from_date": from_date,
                        "to_date": to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantVATReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "report_type":report_type,
                        "date_string":date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getWarehouseSessionImportReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "report_type":report_type,
                        "date_string":date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRenueByEmployeeReport(let restaurant_brand_id, let branch_id, let report_type, let date_string, let from_date, let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "report_type":report_type,
                        "date_string":date_string,
                        "from_date":from_date,
                        "to_date":to_date
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantRevenueDetailByBrandId(let restaurant_brand_id, let branch_id, let report_type,let from_date, let to_date, let date_string):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "from_date": from_date,
                        "to_date": to_date,
                        "date_string":date_string
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantRevenueDetailByBranch(let restaurant_brand_id, let branch_id, let report_type,let from_date, let to_date, let date_string):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "from_date": from_date,
                        "to_date": to_date,
                        "date_string":date_string
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantRevenueCostProfitSum(let restaurant_brand_id, let branch_id, let report_type,let date_string,let from_date,let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date,
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getRestaurantRevenueCostProfitReality(let restaurant_brand_id, let branch_id, let report_type,let date_string,let from_date,let to_date):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "report_type": report_type,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date": to_date,
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getInfoBranches(_):
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.get)
                )
                
            case .healthCheckChangeDataFromServer(let branch_id, let restaurant_brand_id, let restaurant_id):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "restaurant_id": restaurant_id,
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .healthCheckForBuffet(let restaurant_brand_id, let branch_id, let restaurant_id,let buffet_ticket_id):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id":restaurant_brand_id,
                        "branch_id":branch_id,
                        "restaurant_id":restaurant_id,
                        "buffet_ticket_id":buffet_ticket_id
                    ],
                    encoding: self.encoding(.get)
                )

            case .getLastLoginDevice(let device_uid,let app_type):
                return .requestParameters(
                    parameters: [
                        "device_uid": device_uid,
                        "app_type": app_type
                    ],
                    encoding: self.encoding(.get)
                )
                
                
            case .postCreateOrder(let branch_id,let table_id,let note):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "table_id": table_id,
                        "note": note
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .getBranchRights(let restaurant_brand_id,let employee_id):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "employee_id": employee_id
                    ],
                    encoding: self.encoding(.get)
                )
            
                
            case .getTotalAmountOfOrders(let restaurant_brand_id,let branch_id,let is_take_away_table,let order_status,let key_search,let employee_id, let is_take_away,let report_type):
                return .requestParameters(
                    parameters: [
                        "restaurant_brand_id": restaurant_brand_id,
                        "branch_id": branch_id,
                        "is_take_away_table":is_take_away_table,
                        "order_status":order_status,
                        "key_search":key_search,
                        "employee_id":employee_id,
                        "is_take_away":is_take_away,
                        "report_type":report_type
                    ],
                    encoding: self.encoding(.get)
                )
                
            
            case .postApplyExtraChargeOnTotalBill(_,let branch_id, let total_amount_extra_charge_percent):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "total_amount_extra_charge_percent": total_amount_extra_charge_percent
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .postPauseService(_,let branch_id, let order_detail_id):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_detail_id":order_detail_id
                    ],
                    encoding: self.encoding(.post)
                )
                
            case .postUpdateService(_,let branch_id, let order_detail_id, let start_time, let end_time, let note):
                 return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_detail_id": order_detail_id,
                        "start_time": start_time,
                        "end_time": end_time,
                        "note": note
                    ],
                    encoding: self.encoding(.post)
                )
            
            case .getActivityLog(let object_id, let type, let key_search, let object_type, let from, let to, let page, let limit):
                return .requestParameters(
                    parameters: [
                        "object_id": object_id,
                        "type": type,
                        "key_search": key_search,
                        "object_type": object_type,
                        "from": from,
                        "to": to,
                        "page": page,
                        "limit": limit
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .postApplyOnlyCashAmount(_):
                 return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.post)
                )
                
            case .getApplyOnlyCashAmount(_):
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.get)
                )
                
            case .getVersionApp(let os_name, let key_search, let is_require_update, let limit, let page):
                return .requestParameters(
                    parameters: [
                        "os_name": os_name,
                        "key_search": key_search,
                        "is_require_update": is_require_update,
                        "limit": limit,
                        "page": page
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .postApplyTakeAwayTable(_):
                return .requestParameters(
                    parameters: [:],
                    encoding: self.encoding(.post)
                )
                
            case .postCreateTableList(let branch_id, let area_id, let tables):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "area_id": area_id,
                        "tables": tables.toJSON()
                    ],
                    encoding: self.encoding(.post)
                )
                
                
            case .getPrintItem(let type_print, let restaurant_id, let branch_id):
                return .requestParameters(
                    parameters: [
                        "type_print": type_print,
                        "restaurant_id": restaurant_id,
                        "branch_id": branch_id
                    ],
                    encoding: self.encoding(.get)
                )
                
            case .getBrandSetting(_):
                return .requestParameters(parameters:[:],encoding: self.encoding(.get))
            
            case .getSendToKitchen(let branch_id, let order_id):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_id": order_id
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .postSendToKitchen(let branch_id, let order_id,let item_ids):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "order_id": order_id,
                        "order_detail_ids": item_ids
                    ],
                    encoding: self.encoding(.post)
                    
                )
            
            
        case .getBankAccount(let brand_id, let type, let status):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id": brand_id,
                    "type": type,
                    "status": status
                ],
                encoding: self.encoding(.get)
            )
            
            
            
        case .getBankList:
            return .requestParameters(parameters: [:],encoding: self.encoding(.get))
            
            
        case .getBrandBankAccount(let order_id, let brand_id):
            return .requestParameters(
                parameters: [
                    "order_id": order_id,
                    "restaurant_brand_id": brand_id
                ],
                encoding: self.encoding(.get)
            )
            
            
        case .postCreateBrandBankAccount(let brand_id,let bankAccount):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id": brand_id,
                    "bank_identify_id": bankAccount.bank_identify_id,
                    "bank_name": bankAccount.bank_name,
                    "bank_number": bankAccount.bank_number,
                    "bank_account_name": bankAccount.bank_account_name,
                    "is_default": 1,
                    "type": 0,
                    "is_use_static_qr": 0
                ],
                encoding: self.encoding(.post)
            )
                
        case .postUpdateteBrandBankAccount(let brand_id, let bankAccount):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id": brand_id,
                    "bank_identify_id": bankAccount.bank_identify_id,
                    "bank_name": bankAccount.bank_name,
                    "bank_number": bankAccount.bank_number,
                    "bank_account_name": bankAccount.bank_account_name,
                    "is_default": 1,
                    "type": 0,
                    "is_use_static_qr": 0
                ],
                encoding: self.encoding(.post)
            )
            
            
            
        case .getBuffetTickets(let brand_id, let status, let key_search, let limit, let page):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id": brand_id,
                    "status": status,
                    "key_search":key_search,
                    "limit": limit,
                    "page": page
                ],
                encoding: self.encoding(.get)
            )
            
            
      
            
        case .getDetailOfBuffetTicket(let branch_id, let category_id, let buffet_ticket_id, let key_search, let limit, let page):
            return .requestParameters(
                parameters: [
                    "branch_id": branch_id,
                    "category_id": category_id,
                    "buffet_ticket_id": buffet_ticket_id,
                    "key_search": key_search,
                    "limit": limit,
                    "page": page
                ],
                encoding: self.encoding(.get))
        
        case .getFoodsOfBuffetTicket(let brand_id, let buffet_ticket_id):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id": brand_id,
                    "buffet_ticket_id": buffet_ticket_id
                ],
                encoding: self.encoding(.get)
            )
            
            case .postCreateBuffetTicket(let branch_id,let order_id,let buffet_id,let  adult_quantity,let adult_discount_percent,let child_quantity, let chilren_discount_percent):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "buffet_ticket_id": buffet_id,
                        "order_id": order_id,
                        "cash_amount": 0,
                        "bank_amount": 0,
                        "transfer_amount": 0,
                        "e_wallet_amount": 0,
                        "adult_quantity": adult_quantity,
                        "adult_discount_percent": adult_discount_percent,
                        "child_quantity": child_quantity,
                        "child_discount_percent": chilren_discount_percent
                    ],
                    encoding: self.encoding(.post)
                )
                
            
            case .postUpdateBuffetTicket(let branch_id,let order_id,let buffet):
                return .requestParameters(
                    parameters: [
                        "branch_id": branch_id,
                        "buffet_ticket_id": buffet.buffet_ticket_id,
                        "order_id": order_id,
                        "cash_amount": 0,
                        "bank_amount": 0,
                        "transfer_amount": 0,
                        "e_wallet_amount": 0,
                        
                        "adult_quantity": buffet.adult_quantity,
                        "adult_discount_percent":buffet.adult_discount_percent,
                        
                        "child_quantity": buffet.child_quantity,
                        "child_discount_percent":buffet.child_discount_percent,
                        
                        
                    ],
                    encoding: self.encoding(.post)
                )
            
            
            case .postCancelBuffetTicket(_):
                return .requestParameters(parameters: [:],encoding: self.encoding(.post))
            
                
            case .postDiscountOrderItem(let branchId,_,let orderItem):
                return .requestParameters(
                    parameters: [
                        "branch_id": branchId,
                        "discount_percent": orderItem.discount_percent,
                        "order_detail_id": orderItem.id,
                      
                    ],encoding: self.encoding(.post)
                )
            
            // MARK: API for chat
            
            case .postCreateGroupSuppport:
                return .requestParameters(parameters: [:],encoding: self.encoding(.post))
            
            case .getMessageList(let conversation_id, let arrow, let limit, let position):
                return .requestParameters(
                    parameters: [
                        "conversation_id" : conversation_id,
                        "arrow":arrow,
                        "limit":limit,
                        "position":position
                    ],
                    encoding: self.encoding(.get)
                )
            
        case .getListMedia(let type, let  media_type, let  object_id, let  from, let  to, let  limit, let  position):
                return .requestParameters(parameters: [
                    "type": type,
                    "media_type": media_type,
                    "object_id": object_id,
                    "from": from,
                    "to": to,
                    "limit": limit,
                    "position": position,
                ],encoding: self.encoding(.get))
            
            
        case .postRemovePrintedItem(let branch_id,let key):
            return .requestParameters(parameters: ["branch_id": branch_id,"key": key],encoding: self.encoding(.post))
            

//=======================================================================================================================================================================================================
            
        
        // MARK: API for APP FOOD
        case .getChannelFoodOrder(let restaurant_id, let brand_id, let channel_order_food_id, let is_connect, let key_search):
            return .requestParameters(
                parameters: [
                    "restaurant_id": restaurant_id,
                    "restaurant_brand_id": brand_id,
                    "channel_order_food_id": channel_order_food_id,
                    "is_connect": is_connect,
                    "key_search": key_search
                ],
                encoding: self.encoding(.get))
                
            
            
            
        case .getOrderDetailOfChannelFood(let id, let is_app_food, let customer_order_status, let channel_order_food_id, let order_id, let brand_id, let restaurant_id):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "is_app_food": is_app_food,
                    "customer_order_status": customer_order_status,
                    "channel_order_food_id": channel_order_food_id,
                    "order_id": order_id,
                    "brand_id": brand_id,
                    "restaurant_id": restaurant_id
                ],
                encoding: self.encoding(.get))
        
        case .getDetailOfChannelOrderFoodToken(let id):
            return .requestParameters(parameters: [:],encoding: self.encoding(.get))
            
        case .postCreateTokenOfChannelFoodOrder(
            let restaurant_id,
            let restaurant_brand_id,
            let channel_order_food_id,
            let access_token,
            let username,
            let password,
            let x_merchant_token,
            let quantity_account
        ):
            return .requestParameters(
                parameters: [
                    "restaurant_id": restaurant_id,
                    "restaurant_brand_id": restaurant_brand_id,
                    "channel_order_food_id": channel_order_food_id,
                    "access_token": access_token,
                    "username": username,
                    "password": password,
                    "x_merchant_token": x_merchant_token,
                    "device_id": UIDevice.current.identifierForVendor?.uuidString,
                    "device_brand": UIDevice.current.model,
                    "quantity_account":quantity_account
                ],
                encoding: self.encoding(.post))
        
        case .postUpdateTokenOfChannelFoodOrder(_, let access_token, let username, let password,let x_merchant_token):
            return .requestParameters(
                parameters: [
                    "access_token": access_token,
                    "username": username,
                    "password": password,
                    "x_merchant_token": x_merchant_token,
                    "device_id": UIDevice.current.identifierForVendor?.uuidString,
                    "device_brand": UIDevice.current.model
                ],
                encoding: self.encoding(.post))
        
        case .postChangeConnectOfChannelOrderFoodToken(let id,let quantity_account):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "quantity_account": quantity_account
                ],
                encoding: self.encoding(.post)
            ) 
        
        case .getUserInforOfShopee(_):
            return .requestParameters(
                parameters: [:],
                encoding: self.encoding(.post)
            )
            
            
            
            
        case .postGoFoodLoginRequest(let phoneNumber):
            return .requestParameters(
                parameters: [
                    "country_code": "+84",
                    "client_secret": "sPC0qVk7gi76JUoGVfOfcgd7FfuaBv",
                    "phone_number": phoneNumber,
                    "client_id": "go-biz-mobile"
                ],
                encoding: self.encoding(.post)
            )
        
          
            
        case .postGoFoodToken(let otp,let otp_token):
            return .requestParameters(
                parameters: [
                    "grant_type":"otp",
                    "client_id":"go-biz-mobile",
                    "client_secret":"sPC0qVk7gi76JUoGVfOfcgd7FfuaBv",
                    "data":["otp":otp,"otp_token":otp_token]
                ],
                encoding: self.encoding(.post)
            )
            
            
            
        
        case .getOrderListOfFoodApp(
            let isAppFood,
            let branch_id,
            let restaurant_id,
            let area_id,
            let is_have_restaurant_order,
            let channel_order_food_id,
            let restaurant_brand_id,
            let customer_order_status
        ):
            return .requestParameters(
                parameters: [
                    "isAppFood":isAppFood,
                    "branch_id":branch_id,
                    "restaurant_id":restaurant_id,
                    "area_id":area_id,
                    "is_have_restaurant_order":is_have_restaurant_order,
                    "channel_order_food_id":channel_order_food_id,
                    "restaurant_brand_id":restaurant_brand_id,
                    "customer_order_status":customer_order_status
                ],
                encoding: self.encoding(.get)
            )
    
        case .getOrderDetailOfFoodApp(let orderId,let is_app_food):
            return .requestParameters(
                parameters:[
                    "is_app_food": is_app_food,
                    "id": orderId
                ],encoding: self.encoding(.get)
            )
       
        case .postConfirmOrderOfFoodApp(_):
            return .requestParameters(parameters: [:],encoding: self.encoding(.post))
            
        case .postBatchConfirmOrderOfFoodApp(let branch_id,let ids):
            return .requestParameters(parameters: [
                "branch_id":branch_id,
                "ids":ids
            ],encoding: self.encoding(.post))
        
        case .getFoodAppReport(let restaurant_brand_id,let branch_id,let report_type, let date_string,let from_date,let to_date):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id":restaurant_brand_id,
                    "branch_id":branch_id,
                    "report_type":report_type,
                    "date_string":date_string,
                    "from_date":from_date,
                    "to_date":to_date
                ],
                encoding: self.encoding(.get)
            )
            
            
            
            
        case .getBranchFoodApp(let channel_order_food_id, let restaurant_brand_id):
            return .requestParameters(
                parameters: [
                    "channel_order_food_id": channel_order_food_id,
                    "restaurant_brand_id": restaurant_brand_id
                ],
                encoding: self.encoding(.get)
            )
            
        case .postAssignBranchFoodApp(let branch_maps, let channel_order_food_id, let restaurant_brand_id):
            return .requestParameters(
                parameters: [
                    "branch_maps": branch_maps.toJSON(),
                    "channel_order_food_id":channel_order_food_id,
                    "restaurant_brand_id":restaurant_brand_id
                ],
                encoding: self.encoding(.post)
            )
            
            
        case .getCommissionOfFoodApp(let restaurant_id,let restaurant_brand_id):
            return .requestParameters(
                parameters: [
                    "restaurant_id": restaurant_id,
                    "restaurant_brand_id":restaurant_brand_id
                ],
                encoding: self.encoding(.get)
            )
        
        case .postSetCommissionForFoodApp(let id,let restaurant_id,let brand_id,let branch_id,let channel_order_food_id,let percent, let channel_order_food_token_id):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "restaurant_id":restaurant_id,
                    "restaurant_brand_id":brand_id,
                    "branch_id":branch_id,
                    "channel_order_food_id":channel_order_food_id,
                    "percent":percent,
                    "channel_order_food_token_id": channel_order_food_token_id
                ],
                encoding: self.encoding(.post)
            )
            
            
        case .getOrderHistoryOfFoodApp(let restaurant_id,let restaurant_brand_id, let branch_id, let food_channel_id, let report_type, let date_string):
            return .requestParameters(
                parameters: [
                    "restaurant_id": restaurant_id,
                    "restaurant_brand_id":restaurant_brand_id,
                    "branch_id":branch_id,
                    "food_channel_id":food_channel_id,
                    "report_type":report_type,
                    "date_string":date_string,
                    
                ],
                encoding: self.encoding(.get)
            )
            
            
        case .getOrderHistoryDetailOfFoodApp(let restaurant_id,let restaurant_brand_id,let id,let is_app_food):
            return .requestParameters(
                parameters: [
                    "restaurant_id": restaurant_id,
                    "restaurant_brand_id":restaurant_brand_id,
                   
                    "id":id,
                    "is_app_food":is_app_food,
                    
                ],
                encoding: self.encoding(.get)
            )
            
            
            
        case .getRevenueSumaryReportOfFoodApp(let restaurant_id, let restaurant_brand_id, let branch_id, let food_channel_id, let date_string, let report_type, let hour_to_take_report):
            return .requestParameters(
                parameters: [
                    "restaurant_id":restaurant_id,
                    "restaurant_brand_id":restaurant_brand_id,
                    "branch_id":branch_id,
                    "food_channel_id":food_channel_id,
                    "date_string":date_string,
                    "report_type":report_type,
                    "hour_to_take_report":hour_to_take_report
                ],
                encoding: self.encoding(.get)
            )
            
            
            
        case .postRefreshOrderOfFoodApp(let restaurant_id,let restaurant_brand_id, let branch_id, let channel_orders):
            return .requestParameters(
                parameters: [
                    "restaurant_id":restaurant_id,
                    "restaurant_brand_id":restaurant_brand_id,
                    "branch_id":branch_id,
                    "channel_orders":channel_orders
                ],
                encoding: self.encoding(.post)
            )
            
        case .getChannelOrderFoodTokenList(
            let brand_id,
            let channel_order_food_id,
            let channel_order_food_token_id,
            let is_connection

        ):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id":brand_id,
                    "channel_order_food_id":channel_order_food_id,
                    "channel_order_food_token_id":channel_order_food_token_id,
                    "is_connection":is_connection
                ],
                encoding: self.encoding(.get)
            )
        
            case .getChannelOrderFoodInforList(
                let restaurant_id,
                let brand_id,
                let branch_ids,
                let food_channel_id,
                let date_string,
                let from_date,
                let to_date,
                let report_date,
                let key_search,
                let limit,
                let page
            ):
                return .requestParameters(
                    parameters: [
                        "restaurant_id":restaurant_id,
                        "restaurant_brand_id":brand_id,
                        "branch_ids":branch_ids,
                        "food_channel_id":food_channel_id,
                        "date_string":date_string,
                        "from_date": from_date,
                        "to_date":to_date,
                        "report_date":report_date,
                        "key_search":key_search,
                        "limit":limit,
                        "page":page
                    ],
                    encoding: self.encoding(.get)
                )
            
            
        case .getBranchesOfChannelOrderFood(let brand_id,let branch_id,let channel_order_food_id):
            return .requestParameters(
                parameters: [
                    "restaurant_brand_id":brand_id,
                    "branch_id":branch_id,
                    "channel_order_food_id":channel_order_food_id,
                ],
                encoding: self.encoding(.get)
            )
            
            
        case .getAssignedBranchOfFoodApp(let branch_id, let channel_order_food_id):
            return .requestParameters(
                parameters: ["branch_id":branch_id, "channel_order_food_id":channel_order_food_id],
                encoding: self.encoding(.get)
            )
        
        case .postAssignBrachOfFoodApp(let branch_id, let channel_order_food_id, let branch_maps):
            return .requestParameters(
                parameters: [
                    "branch_id":branch_id,
                    "channel_order_food_id":channel_order_food_id,
                    "branch_maps":branch_maps,
                ],
                encoding: self.encoding(.post)
            )
        
                
        //=======================================================================================================================================================================================================
            // MARK: API for TECHRESSHOP
            
            case .getTechresShopDeviceList:
                return .requestParameters(parameters: [:],encoding: self.encoding(.get))
            
          
            
            case .postCreateTechresShopOrder(let note, let devices):
            
                var deviceList:[Any] = []
                for device in devices {
                    deviceList.append(
                        [
                            "product_id":device.id,
                            "quantity":device.quantity
                        ]
                    )
                }
            
                return .requestParameters(parameters: [
                    "note":note,
                    "other_products":deviceList
                ],encoding: self.encoding(.post))
            
            case .getTechresShopOrder(let product_order_status, let payment_status):
                return .requestParameters(
                    parameters: [
                        "product_order_status":product_order_status,
                        "payment_status":payment_status
                    ],
                    encoding: self.encoding(.get)
                )
            
            case .getTechresShopOrderDetail(let orderId):
                return .requestParameters(parameters: [:],encoding: self.encoding(.get))
            
            //==================================================================================================================================================================
            




            
            
            
            
            
        
        }
    }
}
