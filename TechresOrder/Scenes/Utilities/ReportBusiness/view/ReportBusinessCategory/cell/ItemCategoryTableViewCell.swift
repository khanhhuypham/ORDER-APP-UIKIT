//
//  ItemCategoryTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 08/03/2023.
//

import UIKit

class ItemCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_percent: UILabel!
    @IBOutlet weak var lbl_cate_name: UILabel!
    @IBOutlet weak var lbl_number: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    public var total_revenue:Double = 1.0
    
    public var data: RevenueCategory? = nil {
       didSet {
           lbl_cate_name.text = data?.category_name
           lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data!.total_amount))
           
           var percent = (Double(data!.total_amount)/Double(total_revenue))*100
        
           lbl_percent.text = String(format: "%2.1f%%", percent)
       }
    }
    
}
