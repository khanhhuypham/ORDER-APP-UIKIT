//
//  InfoVersionAppTableViewCell.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 04/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxCocoa

class InfoVersionAppTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_last_version: UILabel!
    @IBOutlet weak var lbl_website: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: InformationApplicationViewModel? {
        didSet { 
            let newData = viewModel?.dataArray.value ?? []
            for ( index,item ) in newData.enumerated() {
                if index == 1 {
                    lbl_last_version.text = "Phiên bản \(item.app_version)"
                    lbl_website.text = item.download_link
                }
            }
        }
    }
}
