//
//  FoodReportRevenueTableViewCell.swift
//  ORDER
//
//  Created by Kelvin on 06/06/2023.
//

import UIKit

class FoodReportRevenueTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_amount: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_number: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Variable -
    public var data:FoodReport? = nil {
        didSet {
            lbl_name.text = data?.food_name
            lbl_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: data?.quantity ?? 0)
            lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.total_amount ?? 0)
            avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: (data!.food_avatar))), placeholder:  UIImage(named: "image_defauft_medium"))
        }
    }

}
