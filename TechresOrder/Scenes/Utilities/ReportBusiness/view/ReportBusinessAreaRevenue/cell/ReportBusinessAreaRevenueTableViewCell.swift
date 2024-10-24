//
//  ReportBusinessAreaRevenueTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2023.
//

import UIKit

class ReportBusinessAreaRevenueTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_area_number: UILabel!
    
    @IBOutlet weak var lbl_area_name: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_percent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    
    public var data:AreaRevenueReportData? = nil {
       didSet {
           lbl_area_name.text = data?.area_name
           lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.revenue ?? 0)
       }
    }
    
}
