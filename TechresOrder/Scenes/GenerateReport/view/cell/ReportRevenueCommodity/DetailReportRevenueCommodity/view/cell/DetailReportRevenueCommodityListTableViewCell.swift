//
//  ReportRevenueCommodityListTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class DetailReportRevenueCommodityListTableViewCell: UITableViewCell {

    var index = 0
    
    @IBOutlet weak var avatar_food: UIImageView!
    @IBOutlet weak var lbl_index_foods: UILabel!
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_total_original_amount: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    var data: FoodReport?{
        didSet{
            avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data?.food_avatar ?? "")), placeholder:  UIImage(named: "image_defauft_medium"))
            lbl_index_foods.text = String(index)
            lbl_food_name.text = data?.food_name
            lbl_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: data?.quantity ?? 0)
            lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.total_amount ?? 0)
            lbl_total_original_amount.text = "Giá vốn: " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.total_original_amount ?? 0)
            
        }
    }
    
}
