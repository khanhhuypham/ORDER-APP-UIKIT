//
//  FeedbackDeveloperViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit
import RxSwift
import JonAlert

class FeedbackDeveloperViewController: BaseViewController {
    var viewModel = FeedbackDeveloperViewModel()
    var router = FeedbackDeveloperRouter()
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSent: UIButton!
    
    @IBOutlet weak var btnChooseFeedbackType: UIButton!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    
    @IBOutlet weak var lbl_feedback_type: UILabel!
    @IBOutlet weak var textfield_email: UITextField!
    
    @IBOutlet weak var textview_description: UITextView!
  
    @IBOutlet weak var view_btn_sent_background: UIView!
    @IBOutlet weak var icon_sent_background: UIImageView!
    @IBOutlet weak var lbl_sent_background: UILabel!
    
    @IBOutlet weak var lbl_count_text: UILabel!
    
    let feedback_type_names = ["Bạn muốn góp ý điều gì?","Yêu cầu cải tiến","Đề nghị làm thêm"]

    //hien
    var ischoose = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hien
        ischoose = false
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        textview_description.withDoneButton()
        textfield_email.becomeFirstResponder()
        
        viewModel.phone.accept(ManageCacheObject.getCurrentUser().phone_number)
        viewModel.name.accept(ManageCacheObject.getCurrentUser().name)
        viewModel.type.accept(0)// gửi góp ý nhà phát triển
        
        
        btnBack.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        btnCancel.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self!.viewModel.makePopViewController()
                       }).disposed(by: rxbag)
        
        btnChooseFeedbackType.rx.tap.asDriver()
                       .drive(onNext: { [weak self] in
                           self?.showChooseFeedbackType()
                           
                       }).disposed(by: rxbag)
        
        
        
        //bind value of textfield to variable of viewmodel
        _ = textfield_email.rx.text.map { $0 ?? "" }.bind(to: viewModel.emailText)
        _ = textview_description.rx.text.map { $0 ?? "" }.bind(to: viewModel.descriptionText)
        
        

        
        //hien kiểm tra số lượng ký tự
        _ = viewModel.isValidEmail.subscribe({ [weak self] isValid in
            guard let strongSelf = self, let isValid = isValid.element else {return}
            strongSelf.btnSent.isEnabled = isValid
            strongSelf.view_btn_sent_background.backgroundColor = isValid ? ColorUtils.orange_brand_900() :ColorUtils.buttonGrayColor()
            
            
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
                           
                           
                           if !(Utils.isValidEmail(self!.textfield_email.text!)){
                               JonAlert.showError(message: String(format: "Email không hợp lệ!"), duration: 2.0)
                           }else if (!self!.ischoose) {
                               JonAlert.showError(message: String(format: "Vui lòng chọn loại góp ý!"), duration: 2.0)
                           }else if ((self!.textview_description.text!.count > Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax) || (self!.textview_description.text!.count < Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMin)){
                                   
                               JonAlert.showError(message: String(format: "Nội dung góp ý từ \(Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMin) đến \(Constants.UPDATE_INFO_FORM_REQUIRED.requireDescriptionMax) ký tự."), duration: 2.0)
                           }else if (Utils.isValidEmail(self!.textfield_email.text!) && self!.ischoose){
                               
                               self?.feedbackDeveloper()
                           }
                          


                       }).disposed(by: rxbag)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_customer_name.text = ManageCacheObject.getCurrentUser().name
        lbl_customer_phone.text = ManageCacheObject.getCurrentUser().phone_number
        textfield_email.text = ManageCacheObject.getCurrentUser().email
        
        //hien
        viewModel.emailText.accept(ManageCacheObject.getCurrentUser().email)
        
    }
}
