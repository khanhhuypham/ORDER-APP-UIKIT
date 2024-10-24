//
//  DiscountViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import JonAlert
//MARK: CALL API GET DATA FROM SERVER

enum Direction : String {
    
    case north, east, south, west,wests,westss,westsss
    
    static var allValues = [Direction.north, .east, .south, .west, .wests, .westss, .westsss]
    
}

extension DiscountViewController {
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    func showChooseReasonDiscount(btn:UIButton){
       

        let listIcon = ["baseline_account_balance_black_48pt","baseline_account_balance_black_48pt","baseline_account_balance_black_48pt","baseline_account_balance_black_48pt"]
           
      
        let controller = ArrayChooseDiscountReasonViewController(Direction.allValues)
        
        controller.list_icons = listIcon
        controller.listString = listName
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        controller.delegate = self
        
        showPopup(controller, sourceView: btn)
    }
}
extension DiscountViewController: ArrayChooseReasonDiscountViewControllerDelegate{
    func selectReasonDiscount(pos: Int) {
        /*
            discountReasonType là loại lý do giảm giá
            type = 1 -> discount trên tổng bill
            type = 2 -> discount theo từng loại món
         */
        if viewModel.discountReasonType.value == 1{
            btnDiscountReasonOnBill.setAttributedTitle(getAttribute(content:listName[pos]), for: .normal)
            self.viewModel.note.accept(listName[pos])
        }else if viewModel.discountReasonType.value == 2{
            btnDiscountReasonByCategory.setAttributedTitle(getAttribute(content:listName[pos]), for: .normal)
            self.viewModel.note.accept(listName[pos])
        }
    }
}
extension DiscountViewController{
    func applyDiscount(){
        viewModel.discount().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                
                self.dismiss(animated: true,completion: {
                    self.completion()
                })
               
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
}
