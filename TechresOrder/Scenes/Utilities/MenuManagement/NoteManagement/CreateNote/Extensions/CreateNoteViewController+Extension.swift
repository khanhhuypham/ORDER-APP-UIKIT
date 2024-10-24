//
//  CreateNoteViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 01/02/2023.
//

import UIKit
import JonAlert

extension CreateNoteViewController{
    func createUpdateNote(){
        viewModel.createUpdateNote().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                self.delegate?.callBackReload()
                self.dismiss(animated: true)
                JonAlert.showSuccess(message:self.note.id > 0 ? "Chỉnh sửa thành công!" : "Tạo mới ghi chú thành công!")
    
            }else{
                JonAlert.showError(message: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
}
