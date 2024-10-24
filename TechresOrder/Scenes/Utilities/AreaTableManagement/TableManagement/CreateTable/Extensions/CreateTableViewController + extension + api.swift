//
//  CreateTableViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/04/2024.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert

extension CreateTableViewController{
    func createTable(){
        viewModel.createTable().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
            
                JonAlert.showSuccess(message: self.table.id > 0 ? "Cập nhật bàn thành công!" : "Thêm bàn mới thành công!", duration: 2.0)
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
            }else{

                JonAlert.showSuccess(message: response.message ?? "Tạo bàn thất bại", duration: 2.0)
                dLog(response.message)
            }

        }).disposed(by: rxbag)
    }
    
}
