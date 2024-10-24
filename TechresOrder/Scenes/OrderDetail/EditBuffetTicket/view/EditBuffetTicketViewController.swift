//
//  EditBuffetTicketViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/05/2024.
//

import UIKit
import RxSwift
import JonAlert

class EditBuffetTicketViewController: BaseViewController {
    
    var viewModel = EditBuffetTicketViewModel()
    var buffet:Buffet?
    var order:OrderDetail?
    var completetion:(() -> Void)? = nil
    
    
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var textfield_quantity: UITextField!
    
    @IBOutlet weak var textfield_discountPercent: UITextField!
    @IBOutlet weak var view_discount: UIView!
    
    
    @IBOutlet weak var view_related_quantity_action: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        guard var buffet = self.buffet else {
            dismiss(animated: true)
            return
        }
        
        if buffet.ticketChildren.isEmpty{
            buffet.quantity = buffet.adult_quantity
            view_discount.isHidden = false
            textfield_discountPercent.addTarget(self, action: #selector(textFieldDiscountEditingDidEnd(_:)), for: .editingDidEnd)
            textfield_discountPercent.setMaxValue(maxValue: 100)
            
            if buffet.adult_discount_percent != 0{
                textfield_discountPercent.text = String(buffet.adult_discount_percent)
            }
            
        }else{
            view_discount.isHidden = true
            
        }
        
        
        viewModel.buffet.accept(buffet)
        bindTableViewAndRegisterCell()
        mapData()
       
    }
    
 
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        var buffet = viewModel.buffet.value
        buffet.decreaseByOne()
        if buffet.quantity < 1{
            buffet.quantity = 1
        }
        viewModel.buffet.accept(buffet)
        textfield_quantity.text = String(buffet.quantity)
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        var buffet = viewModel.buffet.value
        buffet.increaseByOne()
        viewModel.buffet.accept(buffet)
        textfield_quantity.text = String(buffet.quantity)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        view.endEditing(true)
        guard let order = order else {
            return
        }
        
        var buffetTicket = viewModel.buffet.value
        
        if buffetTicket.ticketChildren.isEmpty{
            buffetTicket.adult_quantity = buffetTicket.quantity > 0 ? buffetTicket.quantity : 1
        }else{
            
            for ticket in  buffetTicket.ticketChildren{
                if ticket.ticketType == .adult{
                    buffetTicket.adult_quantity = ticket.quantity 
                    buffetTicket.adult_discount_percent = ticket.discountPercent
                }else if ticket.ticketType == .children {
                    buffetTicket.child_quantity = ticket.quantity
                    buffetTicket.child_discount_percent = ticket.discountPercent
                }
            }
            
            
            if buffetTicket.ticketChildren.map{$0.quantity}.reduce(0,+)  < 1{
                showWarningMessage(content: "Số lượng vé tối tiểu là 1")
                buffetTicket.adult_quantity = 1
            }
                
        }
    
        updateBuffetTickets(buffet: buffetTicket, orderId: order.id)
            
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    
    @objc func textFieldDiscountEditingDidEnd(_ textField: UITextField) {
        var buffetTicket = viewModel.buffet.value
        buffetTicket.adult_discount_percent = Int(textField.text ?? "0") ?? 0
        viewModel.buffet.accept(buffetTicket)

    }
    
    

}


extension EditBuffetTicketViewController {
    
    //MARK: API tạo vé buffet.
    func updateBuffetTickets(buffet:Buffet,orderId:Int){

        viewModel.updateBuffetTickets(buffet: buffet,orderId: orderId).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                (self.completetion ?? {})()
                self.dismiss(animated: true)
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
        
    }
}
