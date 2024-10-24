//
//  CreateFeedRebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit
import RxSwift
import JonAlert

extension CreateFeedRebuildViewController{
    func createFee(){
        viewModel.createFee().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                showSuccessMessage(content: "Thêm chi phí mới thành công...")
                viewModel.makePopViewController()
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        }).disposed(by: rxbag)
    }
    
}
