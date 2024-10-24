//
//  TechresShopOrderInfoDetailTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopOrderInfoDetailTableViewCell: UITableViewCell {
    
    
   
    
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    
    
    public var data: TechresShopOrderItem? = nil{
        didSet{
            mapData(data: data!)
        }
    }
    
    
    private func mapData(data:TechresShopOrderItem){
        lbl_quantity.text = String(format: "%dx", data.quantity)
        lbl_name.text = data.product_name
        lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.amount)
        
    }
    
    
    
}
