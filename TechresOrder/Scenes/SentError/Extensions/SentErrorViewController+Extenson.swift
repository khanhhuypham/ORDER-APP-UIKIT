//
//  SentErrorViewController+Extenson.swift
//  TechresOrder
//
//  Created by Kelvin on 20/02/2023.
//

import UIKit
import JonAlert
extension SentErrorViewController {

    func sentError(){
        viewModel.sentError().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Sent Error Success...")
//                Toast.show(message: "Sent Error Success...", controller: self)
                JonAlert.showSuccess(message: "Sent Error Success...",duration: 2.0)
                self.navigationController?.popViewController(animated: true)
            }else{
//                Toast.show(message: response.message ?? "Sent Error có lỗi xảy ra", controller: self)
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message)
            }
        }).disposed(by: rxbag)
}
}
