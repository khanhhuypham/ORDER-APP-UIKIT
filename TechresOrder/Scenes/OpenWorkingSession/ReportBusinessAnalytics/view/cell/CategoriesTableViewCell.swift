//
//  CategoriesTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 26/02/2023.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_unit_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Variable -
       public var data: FoodReport? = nil {
           didSet {
               lbl_food_name.text = data?.food_name
               lbl_quantity.text = String(format: "%d", data?.quantity ?? "0")
               lbl_unit_name.text = data?.unit_name
               avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: (data?.food_avatar)!)), placeholder:  UIImage(named: "image_defauft_medium"))
           }
       }
    
}
