//
//  CategoryTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var category_avatar: UIImageView!
    
    @IBOutlet weak var cate_name: UILabel!
    
    @IBOutlet weak var cate_status: UILabel!
    
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
    
    
    var viewModel: CategoryManagementViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Category? = nil {
        didSet {
            cate_name.text = data?.name
            cate_status.text = data?.status == ACTIVE ? "ĐANG KINH DOANH" : "NGỪNG KINH DOANH"
            cate_status.textColor = data?.status == ACTIVE ? ColorUtils.green_600() : ColorUtils.red_600()
        }
    }
    
}
