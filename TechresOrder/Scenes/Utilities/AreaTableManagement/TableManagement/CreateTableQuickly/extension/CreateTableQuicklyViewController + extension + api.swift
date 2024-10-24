//
//  CreateTableQuicklyViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/01/2024.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension CreateTableQuicklyViewController {
    func createTableList(){
        viewModel.createTableList().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Tạo bàn thành công", duration: 2.0)
                self.dismiss(animated: true,completion: {
                    
                    (self.completeHandler ?? {})()
                    
                })
            }else if response.code == RRHTTPStatusCode.badRequest.rawValue{
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
  }
}


