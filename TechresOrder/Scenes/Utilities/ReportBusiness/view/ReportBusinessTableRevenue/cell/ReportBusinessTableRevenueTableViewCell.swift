//
//  ReportBusinessTableRevenueTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/08/2023.
//

import UIKit

class ReportBusinessTableRevenueTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_number: UILabel!
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var lbl_percent: UILabel!
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    public var data:TableRevenueReportData? = nil {
       didSet {
           lbl_table_name.text = data?.table_name
           lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.revenue ?? 0)
       }
    }
}
