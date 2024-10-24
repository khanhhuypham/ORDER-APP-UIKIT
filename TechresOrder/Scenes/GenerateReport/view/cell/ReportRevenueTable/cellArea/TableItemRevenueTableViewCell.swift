//
//  TableItemRevenueTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/09/2023.
//

import UIKit
import RxSwift
class TableItemRevenueTableViewCell: UITableViewCell {

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
    
    var data: TableRevenueReportData?{
        didSet{
        }
    }
    
}
