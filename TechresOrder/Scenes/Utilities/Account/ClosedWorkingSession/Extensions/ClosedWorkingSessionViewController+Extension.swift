//
//  ClosedWorkingSessionViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert

extension ClosedWorkingSessionViewController {
    
    
    func checkWorkingSession(){
        viewModel.checkWorkingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
              
                if let workingSession  = Mapper<CheckWorkingSession>().map(JSONObject: response.data){
                    
                    self.viewModel.checkWorkingSession.accept(workingSession)
                }

            }
        }).disposed(by: rxbag)
  }
    
    
    
    
    func workingSessionValue(){
            viewModel.workingSessionValue().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let workingSessionValue = Mapper<WorkingSessionValue>().map(JSONObject: response.data) {
                        
                        self.setupData(workingSessionValue: workingSessionValue)
                    }
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình thêm món.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
    func closeWorkingSession(){
            viewModel.closeWorkingSession().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){

                    JonAlert.showSuccess(message: "Chốt ca thành công", duration: 2.0)
                    
                    self.viewModel.makePopViewController()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                        self.delegate?.callBackReload()
                    }
                    
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình thêm món.", duration: 2.0)

                }
             
            }).disposed(by: rxbag)
        }
}

extension ClosedWorkingSessionViewController {
    func setupData(workingSessionValue:WorkingSessionValue){
        
        //TỔNG HỢP
        txtTotalReceipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_receipt_amount_final!)
        sum_cashAmountOfFirstShift.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.before_cash!)
        sum_totalRevenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.cash_amount!)
        sum_Receipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_cash_amount_by_addition_fee!)
        sum_deposit.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_amount!)
        sum_topUpCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_amount!)
        sum_totalCashReceived.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount_final!)
        sum_totalCashPaid.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_cost_final!)
        sum_returnedDeposit.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_cash_amount!)
        sum_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_cash_amount_by_addition_fee!)
        sum_tip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - workingSessionValue.total_receipt_amount_final!)
        
        
        //TIỀN ĐẶT CỌC
        deposit_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_amount!)
        deposit_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_cash_amount!)
        deposit_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_bank_amount!)
        deposit_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_transfer_amount!)
        deposit_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_wallet_amount!)
        
        
        //TIỀN TRẢ CỌC
        returnedDeposit_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_amount!)
        returnedDeposit_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_cash_amount!)
        returnedDeposit_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_transfer_amount!)
        
        //TỔNG NẠP THẺ
        topUpCard_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_amount!)
        topUpCard_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_cash_amount!)
        topUpCard_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_bank_amount!)
        topUpCard_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_transfer_amount!)
        topUpCard_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_wallet_amount!)
        
        //TỔNG PHIẾU THI
        receipt_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_total_amount_by_addition_fee!)
        receipt_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_cash_amount_by_addition_fee!)
        receipt_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_bank_amount_by_addition_fee!)
        receipt_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_transfer_amount_by_addition_fee!)
        receipt_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_wallet_amount_by_addition_fee!)
        
        //TỔNG PHIẾU CHI
        payment_TotalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_total_amount_by_addition_fee!)
        payment_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_cash_amount_by_addition_fee!)
        payment_tip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        payment_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_transfer_amount_by_addition_fee!)
        
        
        //TỔNG DOANH THU BÁN HÀNG
       
        sale_total.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount!)
        sale_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.cash_amount!)
        sale_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.bank_amount!)
        sale_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.transfer_amount!)
        sale_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.wallet_amount!)
        sale_debtAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.debt_amount!)
        sale_topUpCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_used_amount!)
        sale_tip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        
       
     
   
        
    }
}
/*
 deposit_amount: tiền đặt cọc
 deposit_cash_amount: tiền mặt của tiền đặt cọc
 deposit_bank_amount: tiền thẻ của tiền đặt cọc
 deposit_transfer_amount: tiền chuyển khoản của tiền đặt cọc

 return_deposit_amount: tiền trả cọc
 return_deposit_cash_amount:  tiền mặt của tiền trả cọc
 return_deposit_bank_amount:  _____________________
 return_deposit_transfer_amount: chuyển khoản của tiền trả cọc   
 total_top_up_card_amount: Tổng nạp thẻ
 total_top_up_card_cash_amount: Tiền mặt của nạp thẻ
 total_top_up_card_bank_amount: Tiền thẻ của nạp thẻ
 total_top_up_card_transfer_amount: Tiền chuyển khoản của nạp thẻ  
 in_total_amount_by_addition_fee: Tổng phiếu thu
 in_cash_amount_by_addition_fee: Tiền mặt của phiếu thu
 in_bank_amount_by_addition_fee: Tiền thẻ của phiếu thu
 in_transfer_amount_by_addition_fee: Tiền chuyển khoản của phiếu thu


 out_total_amount_by_addition_fee: Tổng phiếu chi
 out_cash_amount_by_addition_fee: Tiền mặt của phiếu chi
 out_bank_amount_by_addition_fee:  Tiền thẻ của phiếu chi
 out_transfer_amount_by_addition_fee: Tiền chuyển khoản của phiếu chi


 // TỔNG DOANH THU BÁN HÀNG
 total_amount: Tổng doanh thu bán hàng
 cash_amount: Tổng tiền mặt  (DOANH THU BÁN HÀNG)
 bank_amount: Tổng tiền thẻ tín dụng của (DOANH THU BÁN HÀNG)
 transfer_amount: Tổng chuyển khoản của (DOANH THU BÁN HÀNG)
 debt_amount: Tổng nợ hàng của (DOANH THU BÁN HÀNG)
 total_top_up_used_amount:
 tip_amount: Tiền tiếp trả lại cho khách
 before_cash: tiền đầu ca
 total_cost_final: Tổng chi tiền mặt
 total_amount_final: Tổng thu tiền mặt
 total_receipt_amount_final: Tổng tiền mặt nhận

 wallet_amount:
 in_wallet_amount_by_addition_fee:
 out_wallet_amount_by_addition_fee:
 deposit_wallet_amount:
 return_deposit_wallet_amount:
 total_top_up_card_wallet_amount:
*/
