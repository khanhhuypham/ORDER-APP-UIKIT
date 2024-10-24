//
//  CreateAreaViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import JonAlert
import RxSwift

//MARK: CALL API
extension CreateAreaViewController {
    
    func presentConfirmPopup(content:String,confirmClosure:(()-> Void)? = nil,cancelClosure:(()-> Void)? = nil) {
        let vc = PopupConfirmViewController()
        vc.confirmClosure = confirmClosure
        vc.cancelClosure = cancelClosure
        vc.content = content
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func createArea(is_confirmed:Int? = nil){
        viewModel.createArea(is_confirmed: is_confirmed).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                JonAlert.showSuccess(
                    message: self.viewModel.area.value.id > 0 ? "Cập nhật khu vực thành công" : "Tạo khu vực thành công",
                    duration: 2.0
                )
                
                (self.completeHandler ?? {})()
                
                self.actionDismiss("")
            }else if response.code == RRHTTPStatusCode.multipleChoices.rawValue {
                
                self.presentConfirmPopup(
                    content: "Khu vực hiện có bàn đang hoạt động. Bạn muốn tắt toàn bộ bàn của khu vực này",
                    confirmClosure:{
                        self.createArea(is_confirmed: ACTIVE)
                    },
                    cancelClosure: {
                        self.actionDismiss("")
                    }
                )
                
            }else{

                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }

        }).disposed(by: rxbag)
    }

}
