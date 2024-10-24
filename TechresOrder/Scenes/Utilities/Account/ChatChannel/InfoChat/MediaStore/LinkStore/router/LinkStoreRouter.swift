//
//  LinkStoreRouter.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 03/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class LinkStoreRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = LinkStoreViewController(nibName: "LinkStoreViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToWebViewController(title_header: String, link_website: String){
        let vc = WebLinkViewController()
        vc.link = link_website
        vc.title = title_header
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
}
