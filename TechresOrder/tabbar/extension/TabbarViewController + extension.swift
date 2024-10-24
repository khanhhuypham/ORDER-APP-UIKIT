//
//  TabbarViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/07/2024.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper
import JonAlert

extension TabbarViewController{
    
    func checkWorkingSession(){
        viewModel.checkWorkingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                if let workingSession  = Mapper<CheckWorkingSession>().map(JSONObject: response.data){
                                
    
                    switch workingSession.type {
                        case OPENED_SHIFT:
                            
                            self.presentModalDialogConfirm(
                                title: "THÔNG BÁO",
                                content: "Hiện tại ca làm việc đang mở. Nhấn nút \"Tiếp Tục\" để làm việc với ca hiện tại hoặc nhấn nút \"Đóng Ca\" để mở ca mới ",
                                titleOfBtnAccept: "Tiếp tục".uppercased(),
                                titleOfBtnCancel: "Dóng ca".uppercased(),
                                completion: {
                                    self.viewModel.order_session_id.accept(workingSession.order_session_id)
                                    self.assignWorkingSession()
                                },cancel: {
                                    let vc = ClosedWorkingSessionRouter().viewController as! ClosedWorkingSessionViewController
                                    vc.delegate = self
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            )
                            
                            
                        case CLOSE_SHIFT:
                            self.getWorkingSession()
                            
                            
                        case EXPIRED_SHIFT:
                            
                        
                            self.presentModalDialogConfirm(
                                title: "Đóng ca làm việc".uppercased(),
                                content: "Ca làm việc hiện tại đã hết hạn. Vui lòng đóng ca hiện tại và mở ca mới để tiếp tục làm việc",
                                titleOfBtnCancel: "ĐÓNG CA",
                                cancel: {
                                    let vc = ClosedWorkingSessionRouter().viewController as! ClosedWorkingSessionViewController
                                    vc.delegate = self
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            )
                            
                            
                        default:
                            break
                    }
                    
                    
                    
                    
                }

            }
        }).disposed(by: disposeBag)
  }
    
    func getWorkingSession(){
        viewModel.workingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                if let workingSessions = Mapper<WorkingSession>().mapArray(JSONObject: response.data){
                    
                    self.presentModalDialogOpenWorkingSessionViewController(workingSession:WorkingSession.init())

                }
            }
        }).disposed(by: disposeBag)
    }
    
    func assignWorkingSession(){
        viewModel.assignWorkingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Mở ca thành công. Bắt đầu vào ca làm việc", duration: 2.0)
                
                var user = Constants.user
                user.alreadCheckWorkingSession = true
                ManageCacheObject.saveCurrentUser(user)
                
            }
        }).disposed(by: disposeBag)
    }
    
}
extension TabbarViewController{
    
    func presentModalDialogConfirm(title:String,content:String,titleOfBtnAccept:String?=nil,titleOfBtnCancel:String?=nil,completion:(()->Void)? = nil, cancel:(()->Void)? = nil) {
        let vc = DialogConfirmViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        if let title = titleOfBtnAccept{
            vc.btnOK.setTitle("Tiếp tục".uppercased(), for: .normal)
        }else{
            vc.btnOK.isHidden = true
        }
        
        if let title = titleOfBtnCancel{
            vc.btnCancel.setTitle("Đóng ca".uppercased(), for: .normal)
        }
        
        
        vc.dialog_title = title
        vc.content = content
        vc.completion = completion
        vc.cancel = cancel
        present(vc, animated: true, completion: nil)

    }
    
}
extension TabbarViewController: TechresDelegate{

    func callBackReload() {
        self.presentModalDialogOpenWorkingSessionViewController(workingSession: self.workingSession)
    }
    
    
    func presentModalDialogOpenWorkingSessionViewController(workingSession:WorkingSession) {
        let vc = OpenWorkingSessionViewController()
        vc.workingSession = workingSession
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
}

