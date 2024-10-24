//
//  BaseViewController+extension+API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/01/2024.
//

import UIKit


extension BaseViewController{

    
    func presentDialogKickouts(deviceName:String,deviceIdString:String,LoginAt:String,ipAddress:String) {
        let vc = DialogKickoutViewController()
        let color = NSAttributedString.Key.foregroundColor
        vc.loadView()
      
        
        vc.lbl_content.attributedText = Utils.setAttributesForLabel(
            label: vc.lbl_content,
            attributes: [
                (str:"tài khoản của bạn đã đăng nhập trên thiết bị ",properties:[color:ColorUtils.gray_600()]),
                (str:deviceName + deviceIdString + " ",properties:[color:ColorUtils.orange_brand_900()]),
                (str:"vào lúc ",properties:[color:ColorUtils.gray_600()]),
                (str:LoginAt,properties:[color:ColorUtils.orange_brand_900()]),
                (str:" với IP: ",properties:[color:ColorUtils.gray_600()]),
                (str:ipAddress,properties:[color:ColorUtils.orange_brand_900()]),
            ])
                
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: vc)
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

}
