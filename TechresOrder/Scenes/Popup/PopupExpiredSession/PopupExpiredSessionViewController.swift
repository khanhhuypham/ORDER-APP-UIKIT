//
//  PopupExpiredSessionViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/06/2024.
//

import UIKit

class PopupExpiredSessionViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionConfirm(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.logout()
        })
    }

}
