//
//  ImageVideoStoreViewModel.swift
//  TECHRES-ORDER
//
//  Created by Nguyen Thanh Vinh on 30/5/24.
//

import UIKit

class MediaStoreRouter: NSObject {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = MediaStoreViewController(nibName: "MediaStoreViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
}

