//
//  ItemFoodVATTableViewCell.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 20/03/2023.
//

import UIKit

class ItemFoodVATTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var food_name: UILabel!
    @IBOutlet weak var food_price: UILabel!
    @IBOutlet weak var food_vat_price: UILabel!
    
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var btm_contraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Variable -
    public var data: DetailVAT? = nil{
        didSet{
            
            guard let data = self.data else {return}
            
            food_name.text = data.name
            //nhân số tiền với số lượng thêm khi đặt món
            food_price.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: (data.total_price))
            food_vat_price.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: floor(data.vat_amount))
            lbl_discount.isHidden = data.discount_percent > 0 ? false : true
            btm_contraint.constant = data.discount_percent > 0 ? 15 : 24
            lbl_discount.text = String(format: "Giảm giá (%d%%): %@",Int(data.discount_percent),Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(floor(data.discount_amount))))
        }
    }
}
