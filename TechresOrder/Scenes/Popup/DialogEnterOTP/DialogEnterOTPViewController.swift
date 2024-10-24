//
//  DialogEnterOTPViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/08/2024.
//

import UIKit
import OTPFieldView
import ObjectMapper
class DialogEnterOTPViewController:BaseViewController, OTPFieldViewDelegate {
   
    
    @IBOutlet weak var OTP_text_field_view: OTPFieldView!
    
    var delegate:DialogEnterOTPDelegate?
    
    var otpToken:String = ""
    var otpCode:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOtpView()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    @IBAction func actionConfirm(_ sender: UIButton) {

        sender.preventRepeatedPresses(inNext: 2)
        confirmGoFoodToken(otp: self.otpCode, otpToken: self.otpToken)
    }
    
    
    private func setUpOtpView(){
        self.OTP_text_field_view.fieldsCount = 4
        self.OTP_text_field_view.fieldBorderWidth = 2
        self.OTP_text_field_view.defaultBorderColor = ColorUtils.orange_brand_900()
        self.OTP_text_field_view.defaultBackgroundColor = ColorUtils.gray_000()
        self.OTP_text_field_view.filledBorderColor = ColorUtils.orange_brand_900()
        self.OTP_text_field_view.filledBackgroundColor = ColorUtils.gray_000()
        self.OTP_text_field_view.cursorColor = ColorUtils.gray_400()
        self.OTP_text_field_view.displayType = .roundedCorner
        
        self.OTP_text_field_view.fieldSize = 40
        self.OTP_text_field_view.separatorSpace = 8
        self.OTP_text_field_view.shouldAllowIntermediateEditing = false
        self.OTP_text_field_view.delegate = self
        self.OTP_text_field_view.initializeUI()
        
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        self.otpCode = otp
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {

        return true
    }
    
    
    func confirmGoFoodToken(otp: String, otpToken: String){
        
        
        appServiceProvider.rx.request(.postGoFoodToken(otp: otp, otp_token: otpToken)).mapJSON().asObservable().subscribe(onNext: { (response) in
            
           
            if let res = Mapper<GoFoodAPIResponse>().map(JSON:response as? [String : Any] ?? [:]){

                if let token = res.access_token{
                    self.dismiss(animated: true,completion: {
//                        self.delegate?.callbackToGetAccessToken(accessToken: token)
                    })
                }else if let error = res.errors.first{
                    Toast.show(message: error["message"] as? String ?? "", controller: self)
                }
                    
                    
                    
            }
            
        }).disposed(by: rxbag)
    }

}
