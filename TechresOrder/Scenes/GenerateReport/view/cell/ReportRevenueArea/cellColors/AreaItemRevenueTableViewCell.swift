//
//  AreaItemRevenueTableViewCell.swift
//  SEEMT
//
//  Created by Huynh Quang Huy on 28/06/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift

class AreaItemRevenueTableViewCell: UITableViewCell {

    @IBOutlet weak var back_ground_index: UIView!
    @IBOutlet weak var lbl_index: UILabel!
    
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var data: AreaRevenueReportData?{
        didSet{
        }
    }
}
