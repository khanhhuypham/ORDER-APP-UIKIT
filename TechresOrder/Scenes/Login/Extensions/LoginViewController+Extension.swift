//
//  LoginViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import JonAlert


extension LoginViewController {
    func presentDialogRegisterAccountViewController() {
        let vc = DialogRegisterAccountViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func presentModalDialogConfirmViewController() {
        let vc = DialogFoodCourtViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.completion = clearCache
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
}


extension LoginViewController: DevModeDelegate {
    func presentModalDevMode(){
        let confirmDevModeViewController = ConfirmDevModeViewController()
        confirmDevModeViewController.delegate = self
        confirmDevModeViewController.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: confirmDevModeViewController)
        nav.modalPresentationStyle = .overCurrentContext
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.large()]
            }
        }
        present(nav, animated: true, completion: nil)
    }
    
    func callbackSetUpDevMode(pass_word: String) {
        if environmentMode == .develop { // EnvironmentMode Develop
            let passDevMode = "order" + TimeUtils.getCurrentDatePass()
            if pass_word.trimmingCharacters(in: .whitespacesAndNewlines) == passDevMode {
                ManageCacheObject.setIsDevMode(!ManageCacheObject.isDevMode())
                if ManageCacheObject.isDevMode() {
                    JonAlert.show(message: "Bật Chế Độ Dev Mode Thành Công", duration: 2.0)
                } else {
                    JonAlert.show(message: "Tắt Chế Độ Dev Mode Thành Công", duration: 2.0)
                }
            } else {
                JonAlert.show(message: "Thông tin không chính xác", andIcon: UIImage(named: "icon-warning"),duration: 2.5)
            }
        } else { // EnvironmentMode Production && Staging
            let passDevMode = "techresorder" + TimeUtils.getCurrentDatePass()
            if pass_word.trimmingCharacters(in: .whitespacesAndNewlines) == passDevMode {
                ManageCacheObject.setIsDevMode(!ManageCacheObject.isDevMode())
                if ManageCacheObject.isDevMode() {
                    JonAlert.show(message: "Bật Chế Độ Dev Mode Thành Công", duration: 2.0)
                } else {
                    JonAlert.show(message: "Tắt Chế Độ Dev Mode Thành Công", duration: 2.0)
                }
            } else {
                JonAlert.show(message: "Thông tin không chính xác", andIcon: UIImage(named: "icon-warning"),duration: 2.5)
            }
        }
    }
}

extension LoginViewController{
    func presentDialogRequiredSetPassword(currentPassword: String){
        let dialogViewController = DialogRequiredSetPasswordViewController()
        dialogViewController.oldPassword = currentPassword
        dialogViewController.view.backgroundColor = ColorUtils.blackTransparent()
        dialogViewController.modalPresentationStyle = .overFullScreen
        dialogViewController.modalTransitionStyle = .crossDissolve
        present(dialogViewController, animated: true, completion: nil)
    }
}
