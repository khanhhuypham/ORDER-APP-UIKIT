//
//  HandlerDelegate.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit

protocol BrandDelegate {
    func callBackChooseBrand(brand:Brand)
}
protocol TechresDelegate {
    func callBackReload()
}
protocol BranchDelegate {
    func callBackChooseBranch(branch:Branch)
}
protocol CalculatorMoneyDelegate {
    func callBackCalculatorMoney(amount:Int, position:Int)
}
protocol CaculatorInputQuantityDelegate {
    func callbackCaculatorInputQuantity(number:Float, position:Int,id:Int)
}
protocol ArrayChooseViewControllerDelegate {
    func selectAt(pos: Int)
}

protocol chooseItemDelegate {
    func selectItem(id:Int)
}


protocol ArrayChooseVATViewControllerDelegate {
    func selectVATAt(pos: Int)
}
protocol NotFoodDelegate {
    func callBackNoteFood(pos:Int, id:Int, note:String)
}

protocol ReasonCancelFoodDelegate {
    func removeItem(item:OrderItem)
    //Khi nhấn Huỷ thì gọi hàm delegate này
    func cancel(item:OrderItem)
}
protocol ReturnBeerDelegate {
    func callBackReturnBeer(note:String,order_detail_id:Int)
}
protocol MoveFoodDelegate {
    func callBackComfirmSelectTableNeedMoveFood(order_id: Int, destination_table_name:String, target_table_name:String, destination_table_id:Int, target_table_id:Int, target_order_id: Int)
}

protocol OrderMoveFoodDelegate {
    func callBackToSplitItem(destination_order:Order,target_order:Order,only_one:Int,isTargetActive:Int)
}

protocol ArrayChooseReasonDiscountViewControllerDelegate {
    func selectReasonDiscount(pos: Int)
}

protocol OrderActionViewControllerDelegate {
    func callBackToGetOption(option:OrderAction)
}


protocol MoveTableDelegate {
    func callBackComfirmMoveTable(destination_table:Table, target_table:Table)
}



protocol UpdateCustomerSloteDelegate {
    func callbackPeopleQuantity(number_slot:Int)
}



protocol QRCodeCashbackBillDelegate {
    func callBackQRCodeCashbackBill(order_id:Int, qrcode:String)
}
protocol DialogConfirmDelegate{
    func accept()
    func cancel()
}


protocol PopupPaymentMethodDelegate{
    func callBackToGetPaymentMethod(paymentMethod:Int)
}


protocol DialogConfirmClosedWorkingSessionDelegate{
    func closedWorkingSession()
    func cancelClosedWorkingSession()
}


protocol ArrayChooseUnitViewControllerDelegate {
    func selectUnitAt(pos: Int)
}


protocol MonthSelectDelegate {
    func selected(month:Int, year:Int)
}

protocol AdditionDelegate{
    func additionQuantity(quantity:Int, row:Int, itemIndex:Int, countGift: Int, food_addition_type:Int)

}


protocol UsedGiftDelegate{
    func callBackUsedGift(order_id:Int)
}


protocol AccountInforDelegate{
    func callBackToAcceptSelectedArea(selectedArea:[String:Area])
}

protocol MaterialDelegate{
    func callBackNoteDelete(note: String)
}

protocol ArrayShowDropdownViewControllerDelegate {
    func selectAt(pos: Int)
}


protocol BLEInvestigatorViewControllerDelegate {
    func getSelectedBLEDevice(device: CBPeripheral)
}

protocol DevModeDelegate {
    func callbackSetUpDevMode(pass_word: String)
}


protocol EnterPercentDelegate {
    func callbackToGetPercent(id:Int,percent: Int)
}

protocol EnterPercentForBuffetDelegate {
    func callbackToGetBuffet(buffet:Buffet)
}


protocol dateTimePickerDelegate {
    func callbackToGetDateTime(didSelectDate:Date)
}


protocol DialogEnterOTPDelegate {
    func callbackToGetAccessToken(accessToken:String,phoneNumber:String)
}

