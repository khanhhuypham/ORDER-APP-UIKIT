//
//  OpenWorkingSessionViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
//MARK: -- CALL API 
extension OpenWorkingSessionViewController {

    func openSession(){
        viewModel.openSession().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                JonAlert.showSuccess(message: "Mở ca thành công...",duration: 2.0)
                self.viewModel.makePopViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    

    
}
extension OpenWorkingSessionViewController:CalculatorMoneyDelegate {
    func presentModalCaculatorInputMoneyViewController() {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
            caculatorInputMoneyViewController.checkMoneyFee = 1000
            caculatorInputMoneyViewController.limitMoneyFee = 99999999
            caculatorInputMoneyViewController.total_amount = self.viewModel.before_cash.value
            caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
            caculatorInputMoneyViewController.delegate = self
            present(nav, animated: true, completion: nil)

    }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
   
        viewModel.before_cash.accept(amount)
        
        
        let attr:NSAttributedString = Utils.setAttributesForBtn(
            content: Utils.stringVietnameseMoneyFormatWithNumber(amount: Float( String(format: "%d", amount))!),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: ColorUtils.black()
            ]
        )
        
        btnInputMoney.setAttributedTitle(attr,for: .normal)

    }
}
