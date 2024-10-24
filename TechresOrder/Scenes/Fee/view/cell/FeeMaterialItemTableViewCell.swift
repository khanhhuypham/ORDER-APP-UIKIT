//
//  FeeMaterialItemTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//

import UIKit

class FeeMaterialItemTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_food_price: UILabel!
    @IBOutlet weak var btnUpdateFeedMaterial: UIButton!
    
    var fee_id:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - Variable -
       public var data: Fee? = nil {
           didSet {
               lbl_food_name.text = data?.object_name
               lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.amount))
               fee_id = data!.id
           }
       }
 
}
