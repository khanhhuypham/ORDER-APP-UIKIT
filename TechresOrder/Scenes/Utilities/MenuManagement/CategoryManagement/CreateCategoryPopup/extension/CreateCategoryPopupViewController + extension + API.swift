//
//  CreateCategoryViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/11/2023.
//

import UIKit
import JonAlert
extension CreateCategoryPopupViewController {
   
    func createCategory(){
        viewModel.createCategory().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Thêm danh mục thành công", duration: 2.0)
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
            }else{
                
                self.showErrorMessage(content: response.message ?? "")
                dLog(response.message)
            }
        }).disposed(by: rxbag)
    }
    
    func updateCategory(){
        viewModel.updateCategory().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Cập nhật danh mục thành công", duration: 2.0)
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
            }else{

                self.showErrorMessage(content: response.message ?? "")
                dLog(response.message ?? "")
            }
   
        }).disposed(by: rxbag)
    }
        
}
