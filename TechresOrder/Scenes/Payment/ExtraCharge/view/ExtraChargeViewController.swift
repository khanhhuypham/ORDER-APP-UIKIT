//
//  ExtraChargeViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/11/2023.
//

import UIKit
import RxSwift
import JonAlert
class ExtraChargeViewController: BaseViewController {
    var viewModel = ExtraChargeViewModel()
    var order_id = 0

    var completion:(() -> Void)?
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var textField_of_extra_charge: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)

        _ = textField_of_extra_charge.rx.text.map{[self] str in
            var percent = Int(str ?? "0") ?? 0
            if percent > 100{
                showWarningMessage(content: "Phần trăm phụ thu không được quá 100%")
                percent = 100
                textField_of_extra_charge.text = String(percent)
            }
            return percent
        }.bind(to: viewModel.total_amount_extra_charge_percent).disposed(by: rxbag)
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.order_id.accept(order_id)
    }
    

    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    

    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if viewModel.total_amount_extra_charge_percent.value > 0 && viewModel.total_amount_extra_charge_percent.value <= 100{
            applyExtraChargeOnTotalBill()
        }else{
            showWarningMessage(content: "Vui lòng nhập % phụ thu")
        }
    }
    
}

extension ExtraChargeViewController{
    func applyExtraChargeOnTotalBill(){
        viewModel.applyExtraChargeOnTotalBill().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
     
                JonAlert.showSuccess(message: "Áp dụng phụ thu thành công", duration: 2.0)
                self.dismiss(animated: true, completion: {
                    (self.completion ?? {})()
                })
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
}
