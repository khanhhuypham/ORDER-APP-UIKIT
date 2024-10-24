//
//  PopupPaymentViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/11/2023.
//

import UIKit

class PopupPaymentMethodViewController: BaseViewController {
    var delegate: PopupPaymentMethodDelegate?
    var paymentMethod:Int = Constants.PAYMENT_METHOD.CASH
    var totalPayment:Double = 0
    
    
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var height_of_popup: NSLayoutConstraint!
    @IBOutlet weak var paddingBtm: NSLayoutConstraint!
    
    @IBOutlet weak var total_payment: UILabel!
    @IBOutlet weak var cashPayment: UIButton!
    @IBOutlet weak var transferPayment: UIButton!
    @IBOutlet weak var creditCardPayment: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = ColorUtils.blackTransparent()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        height_of_popup.constant += Utils.getAreaBottomPadding()
        paddingBtm.constant = Utils.getAreaBottomPadding()
        main_view.round(with: .top,radius: 20)
        total_payment.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: totalPayment)
        changeBtn(btn: cashPayment)
        
    }
    
    
    
    

    @IBAction func actionConfirm(_ sender: Any) {
        delegate?.callBackToGetPaymentMethod(paymentMethod: paymentMethod)
        dismiss(animated: true)
    }
    
    @IBAction func actionCashPayment(_ sender: UIButton) {
        changeBtn(btn: sender)
        paymentMethod = Constants.PAYMENT_METHOD.CASH
    }
    
    @IBAction func actionTransferPayment(_ sender: UIButton) {
        changeBtn(btn: sender)
        paymentMethod = Constants.PAYMENT_METHOD.TRANSFER
        
    }
    
    @IBAction func actionCreditPayment(_ sender: UIButton) {
        changeBtn(btn: sender)
        paymentMethod = Constants.PAYMENT_METHOD.ATM_CARD
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func changeBtn(btn:UIButton){
        
        cashPayment.borderColor = ColorUtils.gray_600()
        cashPayment.tintColor = ColorUtils.gray_600()
        transferPayment.borderColor = ColorUtils.gray_600()
        transferPayment.tintColor = ColorUtils.gray_600()
        creditCardPayment.borderColor = ColorUtils.gray_600()
        creditCardPayment.tintColor = ColorUtils.gray_600()
        
        btn.borderColor = ColorUtils.blue_brand_700()
        btn.tintColor = ColorUtils.blue_brand_700()
        
    }
}
