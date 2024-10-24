//
//  OrderHistoryTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/12/2023.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    // MARK: - Variable -
    
    public var data: ActivityLog? = nil {
        didSet {
            if let data = data{
                
                lbl_time.text = String(data.created_at.split(separator: " ")[0])
                lbl_date.text = String(data.created_at.split(separator: " ")[1])
                
                lbl_name.text = data.full_name + "•" + data.user_name + "•" + ""
                lbl_content.text = data.content
            }
        }
    }
    
}

