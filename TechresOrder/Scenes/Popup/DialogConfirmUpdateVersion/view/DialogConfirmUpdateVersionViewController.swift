//
//  DialogConfirmUpdateVersionViewController.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 19/03/2023.
//

import UIKit

class DialogConfirmUpdateVersionViewController: UIViewController {

    @IBOutlet weak var lbl_content: UILabel!
    
    var is_require_update = 0
    var content:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbl_content.text = content
        
    }
    @IBAction func actionAccept(_ sender: Any) {
        openAppStore()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        if(is_require_update == 1){
//            exit(0)
            self.dismiss(animated: true, completion: nil)
        }else{
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1468724786"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
}
