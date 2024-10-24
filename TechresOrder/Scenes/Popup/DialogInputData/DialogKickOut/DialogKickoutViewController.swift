//
//  DialogKickoutViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/10/2023.
//

import UIKit

class DialogKickoutViewController: UIViewController {
    
    
    @IBOutlet weak var lbl_content: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        
        // clean all data local store befored logout

        ManageCacheObject.saveCurrentPoint(NextPoint()!)
        ManageCacheObject.saveCurrentBrand(Brand())
        ManageCacheObject.saveCurrentBranch(Branch())
        ManageCacheObject.setSetting(Setting()!)
        ManageCacheObject.saveCurrentUser(Account())
        ManageCacheObject.setConfig(Config()!)
        let loginViewController = LoginRouter().viewController
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginViewController)
        dismiss(animated: true)
    }
}
