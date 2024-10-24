//
//  DialogConfirmViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import RxSwift


class DialogConfirmViewController: BaseViewController {

    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lbl_content: UILabel!
    
   
    var dialog_type = 10 // login = 0, other = 1
    var dialog_title = ""
    var content = ""
    var delegate: DialogConfirmDelegate?
    var title_button_ok = ""
    var title_of_button_cancel = ""
    var isHideCancelButton = false
    var assignWorkingSession = 0
    
    
    var completion:(() -> Void)? = nil
    var cancel:(() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbl_title.text = dialog_title
        lbl_content.text = content
        
        if(!title_button_ok.isEmpty){
            btnOK.setTitle(title_button_ok, for: .normal)
        }
    }
  

    @IBAction func actionCancel(_ sender: Any) {
       
        self.dismiss(animated: true,completion: {
            (self.cancel ?? {})()
        })
    }
    
    
    @IBAction func actionAccept(_ sender: Any) {
       
        self.dismiss(animated: true,completion: {
         
            (self.completion ?? {})()
        })

    }

}
