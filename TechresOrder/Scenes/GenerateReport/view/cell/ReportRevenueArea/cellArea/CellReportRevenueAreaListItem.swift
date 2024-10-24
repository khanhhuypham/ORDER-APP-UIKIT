//
//  CellReportRevenueAreaListItem.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class CellReportRevenueAreaListItem: UITableViewCell {
    
    @IBOutlet weak var lbl_area_name: UILabel!
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_percent_area: UILabel!
    @IBOutlet weak var lbl_total_amount_area: UILabel!
    @IBOutlet weak var lbl_index_area: UILabel!
    @IBOutlet weak var view_color_area: UIView!
    
    var colors = [UIColor]()
    
//    var index = 0
    var totalAmountRevenueArea = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: GenerateReportViewModel?{
        didSet{
        }
    }
    
    var data: AreaRevenueReportData?{
        didSet{
            
            lbl_area_name.text = data?.area_name
            lbl_branch_name.text = data?.branch_name
            
            lbl_branch_name.isHidden = ManageCacheObject.getCurrentBrand().id == ALL ? false : true
            
            lbl_total_amount_area.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data?.revenue ?? 0))
            lbl_percent_area.text = String(Int(Utils.rateDefaultTemplate(numerator: Double(data?.revenue ?? 0), denominator: Double(totalAmountRevenueArea)) * 100)) + "%"
            
        }
    }
    
}
