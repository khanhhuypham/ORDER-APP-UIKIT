//
//  DialogFoodCourtViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/03/2024.
//

import UIKit

class DialogFoodCourtViewController: BaseViewController {
    
    
    var completion:(()->Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionClose(_ sender: Any) {
        dismiss(animated: true,completion: { (self.completion ?? {})()})
    }
    
    
}
