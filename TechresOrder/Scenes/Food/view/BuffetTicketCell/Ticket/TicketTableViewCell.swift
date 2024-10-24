//
//  TicketTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/04/2024.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon_image: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var textfield_quantity: UITextField!
    @IBOutlet weak var view_discount: UIView!
    
    @IBOutlet weak var lbl_discount_percent: UILabel!
    
    @IBOutlet weak var btm_contraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    @IBAction func actionCheck(_ sender: Any) {
        
        guard let viewModel = viewModel else {return}
        
        if var ticket = viewModel.getBuffet(id: ticket?.id ?? 0){
           
            if let position = ticket.ticketChildren.firstIndex(where: {$0.ticketType == ticketChild?.ticketType}){
                
                ticket.ticketChildren[position].isSelected == DEACTIVE
                ? ticket.ticketChildren[position].select()
                : ticket.ticketChildren[position].deSelect()
                
            }
        
            viewModel.setElement(element: ticket, categoryType: .buffet_ticket)
        }
        
    }
    
    
    @IBAction func actionDecrease(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        
        if var ticket = viewModel.getBuffet(id: ticket?.id ?? 0){
            
            if let position = ticket.ticketChildren.firstIndex(where: {$0.ticketType == ticketChild?.ticketType}){
                ticket.ticketChildren[position].decreaseByOne()
            }
            viewModel.setElement(element: ticket, categoryType: .buffet_ticket)
        }
    }
    
    
    @IBAction func btnShowCalcaulator(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        

        
        if var ticket = viewModel.getBuffet(id: ticket?.id ?? 0){
            
            if let position = ticket.ticketChildren.firstIndex(where: {$0.ticketType == ticketChild?.ticketType}){
                
                viewModel.buffetTicketType.accept(ticket.ticketChildren[position].ticketType)
                viewModel.view?.presentModalInputQuantityViewController(item: ticket)
            }
            
            
        }
       
    }
    
    
    
    @IBAction func actionIncrease(_ sender: Any) {

        guard let viewModel = self.viewModel else {return}
        
        
        if var ticket = viewModel.getBuffet(id: ticket?.id ?? 0){
            
            if let position = ticket.ticketChildren.firstIndex(where: {$0.ticketType == ticketChild?.ticketType}){
                
                ticket.ticketChildren[position].increaseByOne()
            }
            
            viewModel.setElement(element: ticket, categoryType: .buffet_ticket)
        }

    }
    

    var viewModel:AddFoodViewModel?
    
    var ticket:Buffet?

    var ticketChild:BuffetTicketChild?{
        didSet{
            mapData(ticket: ticketChild ?? BuffetTicketChild())
        }
    }
    
    
    private func mapData(ticket:BuffetTicketChild){

        
        let price = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: ticket.price)
        
        icon_image.image = UIImage(named: ticket.isSelected == ACTIVE ? "check_2" : "un_check_2")
        
        lbl_name.text =  ticket.name
        textfield_quantity.text = String(ticket.quantity)
        
        lbl_price.attributedText = Utils.setAttributesForLabel(
            label: lbl_price, attributes: [
                (str:price,properties:[NSAttributedString.Key.foregroundColor:ColorUtils.orange_brand_900()]),
                (str:" / vé",properties:[NSAttributedString.Key.foregroundColor:ColorUtils.gray_600()])
            ]
        )
        lbl_discount_percent.text = String(format: "Giảm giá %d%%", ticket.discountPercent)
        view_discount.isHidden = ticket.discountPercent > 0 ? false : true
        btm_contraint.constant = view_discount.isHidden ? 15 : 0
    }

    
}
