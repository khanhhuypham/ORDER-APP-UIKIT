//
//  DialogConfirmClosedWorkingSessionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 30/01/2023.
//

import UIKit
import RxSwift


class DialogConfirmClosedWorkingSessionViewController: BaseViewController {

    
    @IBOutlet weak var root_view: UIView!

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbl_content: UILabel!
    
    var dialog_type = 0 // login = 0, other = 1 
    var dialog_title = ""
    var content = ""
    var delegate: DialogConfirmClosedWorkingSessionDelegate?
    var title_button_ok = ""
    var isHideCancelButton = false
    var assignWorkingSession = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()


    
        btnOK.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in

                           self?.delegate?.closedWorkingSession()
                           self?.dismiss(animated: true)
                       }).disposed(by: rxbag)
        
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in

                           self?.delegate?.cancelClosedWorkingSession()
                           self?.dismiss(animated: true)
                       }).disposed(by: rxbag)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        btnCancel.isHidden = isHideCancelButton
//        lbl_title.text = dialog_title
//        lbl_content.text = content
        
//        if(!title_button_ok.isEmpty){
//            btnOK.setTitle(title_button_ok, for: .normal)
//        }
    }
  

}
