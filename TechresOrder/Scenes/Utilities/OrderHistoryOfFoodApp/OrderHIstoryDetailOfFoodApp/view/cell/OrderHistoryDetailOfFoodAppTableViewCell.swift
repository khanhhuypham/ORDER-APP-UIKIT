//
//  OrderHistoryDetailOfFoodAppTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2024.
//

import UIKit

class OrderHistoryDetailOfFoodAppTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_children_food: UILabel!
    
    @IBOutlet weak var lbl_note: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var view_note: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var data: OrderItemOfFoodApp?{
        didSet {
            mapData(data: data!)
        }
    }
    
    private func mapData(data: OrderItemOfFoodApp){
        lbl_name.text = data.food_name
        lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount:data.total_price_include_addition_foods)
        lbl_quantity.text = String(format: "Số lượng: %.0f", data.quantity)
        lbl_note.text = data.note
        view_note.isHidden = data.note.isEmpty ? true : false
        
        
        lbl_children_food.text = ""
        lbl_children_food.isHidden = true
        var attr:[(str: String, properties:[NSAttributedString.Key:Any])] = []
        if(data.food_options.count > 0){
            
            attr.append((str:"[Món bán kèm]\n", properties:[color:ColorUtils.orange_brand_900()]))
            
            lbl_children_food.isHidden = false
            
            data.food_options.enumerated().forEach{(i,value) in
                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %d",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                attr.append((str:" = " + Utils.stringQuantityFormatWithNumber(amount:value.price*value.quantity),properties:[color:ColorUtils.gray_600()]))
                if i != data.food_options.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
            }
            
            lbl_children_food.attributedText = Utils.setAttributesForLabel(label: lbl_children_food, attributes: attr)
        }
        
        
    }
    
}
