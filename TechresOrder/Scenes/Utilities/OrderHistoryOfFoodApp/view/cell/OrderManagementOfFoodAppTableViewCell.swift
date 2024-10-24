//
//  OrderManagementOfFoodAppTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit

class OrderManagementOfFoodAppTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_partner: UILabel!
    @IBOutlet weak var lbl_display_id: UILabel!
    @IBOutlet weak var lbl_order_created_at: UILabel!
    
    
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    
    // MARK: - Variable -
    public var data: FoodAppOrder? = nil {
       didSet {
           mapData(data: data!)
       }
    }
    
    private func mapData(data: FoodAppOrder){
        lbl_partner.text = data.channel_order_food_name
        lbl_display_id.text = String(format: "%@-%@", data.channel_order_food_code,data.display_id)
        lbl_order_created_at.text = data.order_created_at
       
        
        switch data.is_completed{
            case .cancel:
                lbl_status.text = "HUỶ"
                lbl_status.textColor = ColorUtils.red_600()
            case .complete:
                lbl_status.text = "HOÀN THÀNH"
                lbl_status.textColor = ColorUtils.green_600()
            
            case .processing:
                lbl_status.text = "ĐANG XỬ LÝ"
                lbl_status.textColor = ColorUtils.gray_600()
        }
        
        lbl_total_amount.text =  Utils.stringVietnameseMoneyFormatWithNumber(amount: data.total_amount)
    }
    
    
    
    
}
