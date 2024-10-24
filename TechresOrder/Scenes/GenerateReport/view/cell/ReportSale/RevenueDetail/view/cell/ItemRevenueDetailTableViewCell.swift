//
//  ItemRevenueDetailTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import RxSwift

class ItemRevenueDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_report_date: UILabel!
    @IBOutlet weak var lbl_total_revenue: UILabel!
    var index = 0
    var report_type = 0
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    
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
    

    
}
