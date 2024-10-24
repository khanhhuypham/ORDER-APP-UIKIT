//
//  SettingAccountViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import RxSwift
import LocalAuthentication
extension SettingAccountViewController {
    
    func setLogin(settingLoginSwitch:UISwitch){
        settingLoginSwitch.isOn == true ? ManageCacheObject.setBiometric(String(ACTIVE)) : ManageCacheObject.setBiometric(String(DEACTIVE))
        setFaceId(settingLoginSwitch: settingLoginSwitch)
    }
    
    func setFaceId(settingLoginSwitch:UISwitch){
        guard #available(iOS 8.0, *) else {return print("Not supported")}
        var context = LAContext()
        var err: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) else {
            if context.biometryType == .faceID{
                if #available(iOS 13.0, *){
                    let alert = UIAlertController(title: "ORDER muốn truy cập Face id của thiết bị", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Từ chối", style: .cancel){ _ in
                        ManageCacheObject.setBiometric(String(DEACTIVE))
                        settingLoginSwitch.setOn(false, animated: true)
                    }
                    let settingAction = UIAlertAction(title: "Mở Cài Đặt", style: .default){ UIAlertAction in
                        if let url = URL(string: UIApplication.openSettingsURLString){
                            UIApplication.shared.open(url,options: [:],completionHandler: { _ in
                            })
                        }
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(settingAction)
                    self.present(alert, animated: true,completion: nil)
                }else {}
            }else {
                if #available(iOS 13, *){
                    let alert = UIAlertController(title: "ORDER muốn truy cập camera của thiết bị", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Từ chối", style: .cancel, handler: { _ in
                        dLog("Không được truy cập vào camera")
                    })
                    let settingAction = UIAlertAction(title: "Mở cài dặt", style: .default, handler: { _ in
                        dLog("được phép truy cập")
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(settingAction)
                    self.present(alert, animated: true,completion: nil)
                }else {}
                
            }
            return
        }
    }
    
    
    func checkExistingFaceIdFunctionality(settingLoginSwitch:UISwitch){
            guard #available(iOS 8.0, *) else {return print("Not supported")}
            var context = LAContext()
            var err: NSError?
        
//            settingLoginSwitch.isOn =  ManageCacheObject.getBiometric() == String(ACTIVE) ? true : false
    
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) else {
                if context.biometryType == .faceID{
                    ManageCacheObject.setBiometric(String(DEACTIVE))
                    settingLoginSwitch.setOn(ManageCacheObject.getBiometric() == String(ACTIVE) ? true : false , animated: true)
                }
                return
            }
            settingLoginSwitch.setOn(ManageCacheObject.getBiometric() == String(ACTIVE) ? true : false , animated: true)
            ManageCacheObject.setBiometric(String(ACTIVE))
           
    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1468724786"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
        let settingAccountTableViewCell = UINib(nibName: "SettingAccountTableViewCell", bundle: .main)
        tableView.register(settingAccountTableViewCell, forCellReuseIdentifier: "SettingAccountTableViewCell")
        let settingInfoTableViewCell = UINib(nibName: "SettingInfoTableViewCell", bundle: .main)
        tableView.register(settingInfoTableViewCell, forCellReuseIdentifier: "SettingInfoTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rx.setDelegate(self).disposed(by:rxbag)
    }
    
    func bindTableView(){
        viewModel.dataSectionArray.asObservable()
            .bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                switch(element){
                    case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingAccountTableViewCell") as! SettingAccountTableViewCell
                       
    
                        cell.btnUpdateProfile.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                        
                                           self!.viewModel.makeUpdateProfileViewController()
                                       }).disposed(by: rxbag)
                        
                        cell.btnChangePassword.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                    
                                           self!.viewModel.makeChangePasswordViewController()
                                       }).disposed(by: rxbag)
                    
                        cell.btnChatChannel.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
        
                                           self!.viewModel.makeChatChannelViewController()
                                       }).disposed(by: rxbag)
             
                        checkExistingFaceIdFunctionality(settingLoginSwitch: cell.settingSwitch)
                        cell.settingSwitch.rx.controlEvent(.valueChanged).withLatestFrom(cell.settingSwitch.rx.value)
                            .subscribe(onNext : { _ in
                                    setLogin(settingLoginSwitch: cell.settingSwitch)
                            }).disposed(by: rxbag)
                        
                    
                    
                        return cell
                        
                    case 1: let cell = tableView.dequeueReusableCell(withIdentifier:"SettingInfoTableViewCell" ) as! SettingInfoTableViewCell
                        
                        
                        cell.btnTermOfUse.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("btnTermOfUse")
                                           self!.viewModel.makeTermOfUseViewController()
                                       }).disposed(by: rxbag)
                        
                        cell.btnPravicyPolicy.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("btnPravicyPolicy")
                                           self!.viewModel.makePravicyPolicyViewController()
                                       }).disposed(by: rxbag)
                        
                        cell.btnReviewApplication.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("btnReviewApplication")
                                           Utils.reviewOnAppStore()
                                       }).disposed(by: rxbag)
                        
                        cell.btnAppInfo.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           self?.viewModel.makeToInformationApplicationViewController()
                                       }).disposed(by: rxbag)
                        
                        cell.btnSentError.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("btnSentError")
                                           self!.viewModel.makeSentErrorViewController()
                                       }).disposed(by: rxbag)
                        
                        cell.btnFeedbackDeveloper.rx.tap.asDriver()
                                       .drive(onNext: { [weak self] in
                                           dLog("btnFeedbackDeveloper")
                                           self!.viewModel.makeFeedbackDeveloperViewController()
                                       }).disposed(by: rxbag)
                
                    
                        
                        
                        return cell
                   
                    default:
                        let cell = tableView.dequeueReusableCell(withIdentifier:"SettingAccountTableViewCell" ) as! SettingAccountTableViewCell
                        return cell
     
                }
            }
    }
    
    
    
}
extension SettingAccountViewController: DialogConfirmClosedWorkingSessionDelegate, TechresDelegate{
    func presentModalDialogConfirmClosedWorkingSessionViewController() {
        let dialogConfirmClosedWorkingSessionViewController = DialogConfirmClosedWorkingSessionViewController()
        dialogConfirmClosedWorkingSessionViewController.view.backgroundColor = ColorUtils.blackTransparent()
       
        dialogConfirmClosedWorkingSessionViewController.delegate = self
        let nav = UINavigationController(rootViewController: dialogConfirmClosedWorkingSessionViewController)
        // 1
        nav.modalPresentationStyle = .overCurrentContext
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                
                // 3
                sheet.detents = [.large()]
                
            }
        } else {
            // Fallback on earlier versions
        }
        // 4
        present(nav, animated: true, completion: nil)
    }
    
    func closedWorkingSession() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.viewModel.makeClosedWorkingSessionViewController()
//        }
        self.viewModel.makeClosedWorkingSessionViewController()
        
        
    }
    func cancelClosedWorkingSession() {
        self.logout()
    }
    
    func callBackReload() {
        self.logout()
    }
}


extension SettingAccountViewController{
    //dialog_type = 0 logout
    func presentModalDialogConfirm(title:String, content:String) {
        let vc = DialogConfirmViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.completion = self.logout
        vc.dialog_title = title
        vc.content = content
        present(vc, animated: true, completion: nil)

    }

}

extension SettingAccountViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row{
                case 0:
                    return 240
                    
                case 1:
                    return 380
                    
                default:
                    return 250
                    
            }
    }
}


