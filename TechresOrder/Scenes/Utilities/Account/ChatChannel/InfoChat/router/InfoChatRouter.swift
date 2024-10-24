//
//  InfoChatRouter.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 08/11/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class InfoChatRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = InfoChatViewController(nibName: "InfoChatViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigationToMediaStoreViewController(conversation_id: String){
        let mediaStoreViewController = MediaStoreRouter().viewController as! MediaStoreViewController
        mediaStoreViewController.conversation_id = conversation_id
        sourceView?.navigationController?.pushViewController(mediaStoreViewController, animated: true)
    }
}
