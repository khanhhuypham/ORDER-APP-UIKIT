//
//  EmployeeItemReportTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 10/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmployeeItemReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar_employee: UIImageView! // avatar
    @IBOutlet weak var lbl_employee_name: UILabel! // tên nhân viên
    @IBOutlet weak var lbl_employee_role_name: UILabel! // bộ phận
    @IBOutlet weak var lbl_order_count: UILabel! // đơn hàng
    @IBOutlet weak var lbl_revenue: UILabel! // doanh thu
    
    @IBOutlet weak var view_root: UIView!
    @IBOutlet weak var lbl_index_category: UILabel!

    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    
    var data: RevenueEmployee? {
        didSet{
            self.avatar_employee.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data?.avatar ?? "")), placeholder: UIImage(named: "image_default_user"))
            self.lbl_index_category.text = String(self.index)
            self.lbl_employee_name.text = data?.employee_name
            self.lbl_employee_role_name.text = data?.employee_role_name
            self.lbl_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.revenue ?? 0)
            self.lbl_order_count.text = Utils.stringQuantityFormatWithNumber(amount: data?.order_count ?? 0)
        }
    }
}
