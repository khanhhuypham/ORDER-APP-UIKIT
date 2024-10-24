//
//  FoodManagementTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class FoodManagementTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_price: UILabel!
    @IBOutlet weak var lbl_food_name: UILabel!
    
    @IBOutlet weak var lbl_food_unit: UILabel!
    
    @IBOutlet weak var lbl_food_status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: FoodManagementViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Food? = nil {
        didSet {
            mapData(data: data!)
        }
    }
    
    private func mapData(data:Food){
      
        avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        
        lbl_food_name.text = data.name
        lbl_food_status.text = data.status == ACTIVE ? "ĐANG BÁN" : "NGỪNG BÁN"
        lbl_food_status.textColor = data.status == ACTIVE ? ColorUtils.green_600() : ColorUtils.grayColor() // MÀU ĐỎ CHO lbl_food_status
        let color = NSAttributedString.Key.foregroundColor
        lbl_food_price.attributedText = Utils.setAttributesForLabel(
            label: lbl_food_price,
            attributes: [
                (str:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.price_with_temporary),properties:[color:ColorUtils.orange_brand_900()]),
                (str:"/" + data.unit_type,properties:[color:ColorUtils.gray_600()])
            ])
    }
    
    
}
