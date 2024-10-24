//
//  TechresShopOrderInfoTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopOrderInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view_of_order_status: UIView!
    @IBOutlet weak var lbl_order_status: UILabel!
    @IBOutlet weak var lbl_order_id: UILabel!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_discount: UILabel!
    
    @IBOutlet weak var lbl_vat: UILabel!
    
    @IBOutlet weak var lbl_return_quantity: UILabel!
    
    @IBOutlet weak var lbl_net_payment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var viewModel: TechresShopOrderViewModel?
    
    
    public var data: TechresShopOrder? = nil{
        didSet{
            mapData(data: data!)
        }
    }
    
    
    private func mapData(data:TechresShopOrder){

        lbl_order_id.text = data.code
        lbl_quantity.text = String(data.total_device)
        lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data.total_amount)
        lbl_discount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data.discount_amount)
        lbl_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data.vat_amount)
        lbl_return_quantity.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_amount_returned)
        lbl_net_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: data.amount)
        
        switch data.product_order_status {
            case .waiting_confirm:
                lbl_order_status.text = "Chờ xác nhận"
                view_of_order_status.backgroundColor = ColorUtils.orange_brand_900()
            case .payment:
                if data.payment_status == .payment_complete{
                    lbl_order_status.text = "Hoàn tất"
                    view_of_order_status.backgroundColor = ColorUtils.green_matcha_400()
                }else{
                    lbl_order_status.text = "Chờ thanh toán"
                    view_of_order_status.backgroundColor = ColorUtils.orange_brand_900()
                }
            case .cancel:
                lbl_order_status.text = "Huỷ"
                view_of_order_status.backgroundColor = ColorUtils.red_600()
            case .RETURN:
                lbl_order_status.text = "Trả hàng"
                view_of_order_status.backgroundColor = ColorUtils.gray_600()
            }
 
    }
    
    
}
