//
//  ExtraFoodViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 21/01/2023.
//

import UIKit
import ObjectMapper
import JonAlert

extension ExtraFoodViewController {

    
    func getExtraCharges(){
        viewModel.getExtraCharges().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Get ExtraCharges Success...")
                if let extraCharges  = Mapper<ExtraCharge>().mapArray(JSONObject: response.data){
                  
                    var list:[ExtraCharge] = []
                    

                    for element in extraCharges {
                        list.append(ExtraCharge.init(
                            id: element.id,
                            name: element.name,
                            price: element.price,
                            quantity: 1,
                            description: element.description)
                        )
                    }
                    
                    list.append(ExtraCharge.init(id: 0, name: "Khác", price: 0, quantity: 1, description: ""))
                    self.setupMenu(list: list)
                }

            }
        }).disposed(by: rxbag)
        
    }
    
func addExtraCharge(){
        viewModel.addExtraCharge().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
            
                JonAlert.showSuccess(message: "Thêm phụ thu thành công...", duration: 2.0)
                self.popViewController()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi trong quá trình thêm món", duration: 3.0)
            }
         
        }).disposed(by: rxbag)
    }
}


//extension ExtraFoodViewController{
//    func presentModalCaculatorInputMoneyViewController() {
//        let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
//        caculatorInputMoneyViewController.checkMoneyFee = 100 // Chỉnh thành 100
//        caculatorInputMoneyViewController.limitMoneyFee = 500000000 // Chỉnh thành 500000000
//        caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
//        let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
//        // 1
//        nav.modalPresentationStyle = .overCurrentContext
//
//        
//        // 2
//        if #available(iOS 15.0, *) {
//            if let sheet = nav.sheetPresentationController {
//                
//                // 3
//                sheet.detents = [.large()]
//                
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//        // 4
//        caculatorInputMoneyViewController.delegate = self
//    //        newFeedBottomSheetActionViewController.newFeed = newFeed
//    //        newFeedBottomSheetActionViewController.index = position
//        present(nav, animated: true, completion: nil)
//
//    }

//}
//extension ExtraFoodViewController: CalculatorMoneyDelegate{
//    func callBackCalculatorMoney(amount: Int, position: Int) {
//        self.lbl_extra_charge_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(amount))
//        self.viewModel.price.accept(amount)
//        self.viewModel.quantity.accept(1)
//        
//    }
//}
