//
//  Observable+Extension.swift
//  ALOLINE
//
//  Created by Kelvin on 02/11/2022.
//  Copyright © 2022 OVERATE-VNTECH. All rights reserved.
//

import Foundation
import RxSwift
import Moya
extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: { (event) in
        }, onError: { (error) in
            // TODO: It is possible to present information that is currently available on the Internet.

            if let e = error as? MoyaError, e.response?.statusCode == RRHTTPStatusCode.unauthorized.rawValue  {
                print("pham khánh huy")
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }

                    if !topController.isKind(of: PopupExpiredSessionViewController.self){
                        let vc = PopupExpiredSessionViewController()
                        vc.view.backgroundColor = ColorUtils.blackTransparent()
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overCurrentContext
                        topController.present(vc, animated: true)
                    }else{
                        return
                    }
                }
                
            }
            
            
            
            
           
        }, onCompleted: {
        }, onSubscribe: {
        }, onDispose: {
        })
    }
}
