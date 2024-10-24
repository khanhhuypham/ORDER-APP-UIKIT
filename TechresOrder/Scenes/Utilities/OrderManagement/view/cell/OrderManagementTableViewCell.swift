//
//  OrderManagementTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxSwift

class OrderManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_order_status: UILabel!
    
    @IBOutlet weak var view_order_status: UIView!
    
    
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_order_code: UILabel!
    
    @IBOutlet weak var lbl_order_time: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var lbl_avg_amount_per_customer: UILabel!
    
    @IBOutlet weak var view_of_avg_amout_per_customer: UIView!
    
    @IBOutlet weak var view_order_bg_status: UIView!
    
    
    @IBOutlet weak var lbl_table_merge: UILabel!
    
    
    
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
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: OrderManagementViewModel?
    
    // MARK: - Variable -
    public var data: Order? = nil {
       didSet {
           mapData(data: data!)
       }
    }
    
    private func mapData(data: Order){
        lbl_order_code.text = String(format: "#%d", data.id)
        lbl_table_name.text = data.table_id == 0 ? String(format:"MV%@",data.table_name) : data.table_name
//        lbl_table_name.text = data.table_name
        lbl_employee_name.text = data.employee.name
        lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data.total_amount)
        lbl_order_time.text =  data.payment_date
        lbl_table_merge.text = data.table_merged_names.joined(separator: ",")
        lbl_avg_amount_per_customer.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_amount_avg_per_customer)
        
        view_of_avg_amout_per_customer.isHidden = permissionUtils.GPQT_3_and_above && ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE ? false : true
        
        if (data.order_status == ORDER_STATUS_COMPLETE || data.order_status == ORDER_STATUS_DEBT_COMPLETE) {
            self.lbl_order_status.text = "Hoàn Thành".uppercased()
            self.view_order_status.backgroundColor = ColorUtils.green_000()
            self.view_order_bg_status.backgroundColor = ColorUtils.green_000()
            self.lbl_order_status.textColor = ColorUtils.green_600()
            self.lbl_table_name.textColor = ColorUtils.green_600()
            self.lbl_total_amount.textColor = ColorUtils.green_600()
        }else{
          
            self.lbl_order_status.text = "Đã Huỷ".uppercased()
            self.view_order_status.backgroundColor = ColorUtils.red_000()
            self.view_order_bg_status.backgroundColor = ColorUtils.red_000()
            self.lbl_order_status.textColor = ColorUtils.red_600()
            self.lbl_table_name.textColor = ColorUtils.red_600()
            self.lbl_total_amount.textColor = ColorUtils.red_600()
        }
    }

    
}
