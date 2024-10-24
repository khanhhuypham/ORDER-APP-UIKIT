//
//  PopupConfirmViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/11/2023.
//

import UIKit

class PopupConfirmViewController: BaseViewController {

    @IBOutlet weak var lbl_content: UILabel!

    var content = ""
    var confirmClosure:(() -> Void)? = nil
    var cancelClosure:(() -> Void)? = nil
    var backgroudColor = ColorUtils.blackTransparent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = backgroudColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_content.text = content
    }
    
    

    @IBAction func actionConfirm(_ sender: Any) {
        dismiss(animated: true,completion: {
            
            if self.confirmClosure != nil{
                (self.confirmClosure ?? {})()
            }
        })
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
       
        dismiss(animated: true,completion: {
            if self.cancelClosure != nil{
                (self.cancelClosure ?? {})()
            }
            
        })

    }
    
}
