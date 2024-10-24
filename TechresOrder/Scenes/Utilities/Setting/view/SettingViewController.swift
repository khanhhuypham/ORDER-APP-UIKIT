//
//  SettingViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/12/2023.
//

import UIKit
import ObjectMapper
class SettingViewController: BaseViewController {
    var viewModel = SettingViewModel()
    var router = SettingRouter()
    
    
    @IBOutlet weak var paymentMethodSwitch: UISwitch!
    
    @IBOutlet weak var takeAwaySettingView: UIView!
    @IBOutlet weak var takeAwaySwitch: UISwitch!
    @IBOutlet weak var idleTimerSwitch: UISwitch!
    
    @IBOutlet weak var idleTimerView: UIView!
    
    @IBOutlet weak var btn_bank_account_setting: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        
        
//        paymentMethodSwitch.setOn(
//            ManageCacheObject.getPaymentMethod().is_apply_only_cash_amount_payment_method == ACTIVE ? false : true,
//            animated: true
//        )
        
        getCashAmountApplication()


        takeAwaySwitch.setOn(
            ManageCacheObject.getOrderMethod().is_have_take_away == ACTIVE ? true : false,
            animated: true
        )
        
        idleTimerSwitch.setOn(ManageCacheObject.getIdleTimerStatus(),animated: true)
        
        takeAwaySettingView.isHidden = permissionUtils.GPBH_1 ? false : true
        
        idleTimerView.isHidden =  permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1 ? false : true
        
        btn_bank_account_setting.isHidden = permissionUtils.GPBH_1 ? false : true
        
    }
    
    @IBAction func acionChangeStatusOfPaymentMethod(_ sender: UISwitch) {
        applyOnlyCashAmount()
    }
    
    @IBAction func actionChangeStatusOfOrderMethod(_ sender: Any) {
        applyTakeAwayTable()
    }
    
    @IBAction func actionChangeStatusOfIdleTimer(_ sender: UISwitch) {
        UIApplication.shared.isIdleTimerDisabled = sender.isOn
        ManageCacheObject.setIdleTimerStatus(sender.isOn)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionNavigateToBankAccountSetting(_ sender: Any) {
        viewModel.makeBankAccountSettingViewController()
    }
    
}

extension SettingViewController{
    
  

    func applyOnlyCashAmount(){
        viewModel.applyOnlyCashAmount().subscribe(onNext: {(response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let method = Mapper<PaymentMethod>().map(JSONObject: response.data){
                    
                    ManageCacheObject.setPaymentMethod(method)
                    
                    self.paymentMethodSwitch.setOn(
                        method.is_apply_only_cash_amount_payment_method == ACTIVE ? false : true,
                        animated: true
                    )
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.")
            }
        }).disposed(by: rxbag)
    }
    
    
    func getCashAmountApplication(){
        viewModel.getCashAmountApplication().subscribe(onNext: {(response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let method = Mapper<PaymentMethod>().map(JSONObject: response.data){
                    
                    ManageCacheObject.setPaymentMethod(method)
                    
                    self.paymentMethodSwitch.setOn(
                        method.is_apply_only_cash_amount_payment_method == ACTIVE ? false : true,
                        animated: true
                    )
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.")
            }
        }).disposed(by: rxbag)
    }
    
    
    func applyTakeAwayTable(){
        viewModel.applyTakeAwayTable().subscribe(onNext: {(response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let method = Mapper<OrderMethod>().map(JSONObject: response.data){
                    
                    ManageCacheObject.setOrderMethod(method)
                    
                    self.takeAwaySwitch.setOn(
                        method.is_have_take_away == ACTIVE ? true : false,
                        animated: true
                    )
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.")
            }
        }).disposed(by: rxbag)
    }
    
}


