//
//  CreateFeedViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit


extension CreateFeedRebuildViewController{
    func presentModalCaculatorInputMoneyViewController() {
        let vc = CaculatorInputMoneyViewController()
        vc.checkMoneyFee = 1000
        vc.limitMoneyFee = 1000000000
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: vc)
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
        vc.delegate = self

        present(nav, animated: true, completion: nil)

    }
}
    
    
    
extension CreateFeedRebuildViewController: CalculatorMoneyDelegate, dateTimePickerDelegate{
    
    func callbackToGetDateTime(didSelectDate: Date) {
        
        let dateString = TimeUtils.convertDateToString(from: didSelectDate, format:  dateFormatter.dd_mm_yyyy_hh_mm)
        
        lbl_date.text = dateString
        var fee = viewModel.fee.value
        fee.date = dateString
        viewModel.fee.accept(fee)
    }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
        self.textfield_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(amount))
        var fee = viewModel.fee.value
        fee.amount = Float(amount)
        viewModel.fee.accept(fee)
    }

    
}
