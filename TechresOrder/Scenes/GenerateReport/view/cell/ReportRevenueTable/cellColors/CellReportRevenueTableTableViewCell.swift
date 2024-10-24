//
//  CellReportRevenueTableTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/09/2023.
//

import UIKit
import RxSwift
class CellReportRevenueTableTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_area_name: UILabel!
    @IBOutlet weak var lbl_percent_area: UILabel!
    @IBOutlet weak var lbl_total_amount_area: UILabel!
    @IBOutlet weak var lbl_index_area: UILabel!
    @IBOutlet weak var view_color_area: UIView!
    
    var colors = [UIColor]()
    
//    var index = 0
    var totalAmountRevenueArea = 1

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
    
    var data: TableRevenueReportData?{
        didSet{
            
            lbl_area_name.text = data?.table_name
            
            lbl_total_amount_area.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data?.revenue ?? 0))
            
            if totalAmountRevenueArea != 0 && data?.revenue != 0 {
                lbl_percent_area.text = String(format: "%.2f%%", Double(data?.revenue ?? 0)/Double(totalAmountRevenueArea)*100)
            }else {
                lbl_percent_area.text = String(format: "%.2f", 0.0)
            }
            
            
        }
    }
}
