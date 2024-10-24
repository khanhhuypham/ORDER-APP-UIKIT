//
//  SentErrorViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import RxSwift
import JonAlert

class SentErrorViewController: BaseViewController {
    var viewModel = SentErrorViewModel()
    var router = SentErrorRouter()
    
    @IBOutlet weak var lbl_count_text: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    
    @IBOutlet weak var textview_description: UITextView!
    @IBOutlet weak var textfield_email: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSent: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()


        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        textview_description.withDoneButton()
        textfield_email.becomeFirstResponder()
        
        viewModel.phone.accept(ManageCacheObject.getCurrentUser().phone_number)
        viewModel.name.accept(ManageCacheObject.getCurrentUser().name)
        viewModel.type.accept(1)
        
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        //bind value of textfield to variable of viewmodel
        _ = textfield_email.rx.text.map { $0 ?? "" }.bind(to: viewModel.emailText)
        _ = textview_description.rx.text.map { $0 ?? "" }.bind(to: viewModel.descriptionText)
        
        
        //  subscribe result of variable isValid in SentErrorViewModel then handle button login is enable or not?
        ////a Tuan
//        _ = viewModel.isValid.subscribe({ [weak self] isValid in
//            dLog(isValid)
//            guard let strongSelf = self, let isValid = isValid.element else { return }
//            strongSelf.btnSent.isEnabled = isValid
//            strongSelf.btnSent.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
//            strongSelf.btnSent.titleLabel?.textColor = isValid ? ColorUtils.white() : ColorUtils.lableBlack()
//
//        })
        
        //hien kiểm tra số lượng ký tự
        _ = viewModel.isValidEmail.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else {return}
            strongSelf.btnSent.isEnabled = isValid
//            strongSelf.btnSent.backgroundColor = isValid ? ColorUtils.buttonOrangeColor() :ColorUtils.buttonGrayColor()
            
            
            if strongSelf.textfield_email.text!.count > Constants.UPDATE_INFO_FORM_REQUIRED.requireEmailLength{
                strongSelf.textfield_email.text = String(strongSelf.textfield_email.text!.prefix(Constants.UPDATE_INFO_FORM_REQUIRED.requireEmailLength))
                

            }

        })
        //hien kiểm tra số lượng ký tự
        _ = viewModel.isValidDescription.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else {return}
            if !isValid {
                
                
                if strongSelf.textview_description.text!.count > Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax{
                    strongSelf.textview_description.text = String(strongSelf.textview_description.text!.prefix(Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax))

                }
                    
            }
            //hien thi so ky tu da nhap
            self!.lbl_count_text.text = String(format: "%d/%d", strongSelf.textview_description.text!.count, 255)
        })
        
        btnSent.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.viewModel.type.accept(2)// gửi thông báo lỗi 
//                           self?.sentError()
                           
                           
                           if !(Utils.isValidEmail(self!.textfield_email.text!)){
                               JonAlert.showError(message: String(format: "Email không hợp lệ!"), duration: 2.0)
                           }else if ((self!.textview_description.text!.count > Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax) || (self!.textview_description.text!.count < Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMin)){
                                   
                               JonAlert.showError(message: String(format: "Nội dung góp ý từ \(Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMin) đến \(Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax) ký tự."), duration: 2.0)
                           }else if (Utils.isValidEmail(self!.textfield_email.text!)){
                               
                               self?.sentError()
                           }
                           
                       }).disposed(by: rxbag)
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_customer_name.text = ManageCacheObject.getCurrentUser().name
        lbl_customer_phone.text = ManageCacheObject.getCurrentUser().phone_number
        textfield_email.text = ManageCacheObject.getCurrentUser().email
    }

}
