//
//  EditBuffetTicketTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/05/2024.
//

import UIKit

class EditBuffetTicketTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var lbl_name: UILabel!
   
    
    @IBOutlet weak var textfield_quantity: UITextField!
    @IBOutlet weak var textfield_discountPercent: UITextField!
    @IBOutlet weak var lbl_price: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textfield_quantity.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfield_quantity.setMaxValue(maxValue: 999)
        
        textfield_discountPercent.addTarget(self, action: #selector(textFieldDiscountEditingDidEnd(_:)), for: .editingDidEnd)
        textfield_discountPercent.setMaxValue(maxValue: 100)
        
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var viewModel:EditBuffetTicketViewModel?
    
    var data:BuffetTicketChild? = nil {
        didSet{
            guard let ticket = data else {return}
            mapData(ticket:ticket)

        }
    }
    
    
    private func mapData(ticket:BuffetTicketChild){

        lbl_name.text =  ticket.name
        textfield_quantity.text = String(ticket.quantity)
        lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: ticket.price * ticket.quantity)
        
        
        if ticket.discountPercent != 0{
            textfield_discountPercent.text = String(ticket.discountPercent)
        }
        
    }

    

    
    @IBAction func decreaseQuantity(_ sender: Any) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        var buffet = viewModel.buffet.value
        
        if let position = buffet.ticketChildren.firstIndex(where: {$0.ticketType == data?.ticketType}){
            var ticket = buffet.ticketChildren[position]
            
            

            ticket.decreaseByOne()
            buffet.ticketChildren[position] = ticket
            
    
            if buffet.ticketChildren.map{$0.quantity}.reduce(0, +) < 1{
                viewModel.view?.showWarningMessage(content: "Số lượng vé tối tiểu là 1")
                ticket.setQuantity(quantity: 1)
                buffet.ticketChildren[position] = ticket
            }

            
            textfield_quantity.text = String(ticket.quantity)
            lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: ticket.price * ticket.quantity)

        }
        
        viewModel.buffet.accept(buffet)
        
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        var buffet = viewModel.buffet.value
        
        if let position = buffet.ticketChildren.firstIndex(where: {$0.ticketType == data?.ticketType}){
            var ticket = buffet.ticketChildren[position]
            ticket.increaseByOne()
            textfield_quantity.text = String(ticket.quantity)
            lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: ticket.price * ticket.quantity)
            buffet.ticketChildren[position] = ticket
        }
        viewModel.buffet.accept(buffet)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        var buffet = viewModel.buffet.value
        
        if let position = buffet.ticketChildren.firstIndex(where: {$0.ticketType == data?.ticketType}){
            
            var ticket = buffet.ticketChildren[position]
            ticket.setQuantity(quantity: Int(self.textfield_quantity.text ?? "0") ?? 0)

            lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: ticket.price * ticket.quantity)
            buffet.ticketChildren[position] = ticket
        }
        
        viewModel.buffet.accept(buffet)
    }
    
    
    
    @objc func textFieldDiscountEditingDidEnd(_ textField: UITextField) {
        let number = Int(textField.text ?? "0") ?? 0
        guard let viewModel = viewModel else {
            return
        }
        
        var buffet = viewModel.buffet.value
        
        if let position = buffet.ticketChildren.firstIndex(where: {$0.ticketType == data?.ticketType}){
            var ticket = buffet.ticketChildren[position]
            ticket.discountPercent = number
            buffet.ticketChildren[position] = ticket
        }
        
        viewModel.buffet.accept(buffet)
    }
    
}
    
