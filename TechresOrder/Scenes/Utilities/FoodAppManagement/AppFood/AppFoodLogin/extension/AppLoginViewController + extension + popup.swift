//
//  AppLoginViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/08/2024.
//

import UIKit

extension AppFoodLoginViewController:DialogEnterOTPDelegate{
    func callbackToGetAccessToken(accessToken:String,phoneNumber:String){
        var cre = viewModel.credential.value
        
        cre.access_token = accessToken
        
        if cre.partnerType == .shoppee{
            cre.x_merchant_token = accessToken
            cre.username = phoneNumber
        }
        dLog(cre.toJSON())
        self.viewModel.credential.accept(cre)
        connectionToggle()
    } 
    
    
    
    func presentModalOTP(otpToken:String) {
    
        let vc = DialogEnterOTPViewController()
        vc.delegate = self
        vc.otpToken = otpToken
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)

    }
}
