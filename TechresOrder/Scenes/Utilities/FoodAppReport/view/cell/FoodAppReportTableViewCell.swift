//
//  FoodAppReportTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 04/09/2024.
//

import UIKit

class FoodAppReportTableViewCell: UITableViewCell {

    @IBOutlet weak var report_date: UILabel!
    

    @IBOutlet weak var total_order_GOF: UILabel!
    @IBOutlet weak var total_amount_GOF: UILabel!
    @IBOutlet weak var order_amount_GOF: UILabel!
    @IBOutlet weak var commission_amount_GOF: UILabel!

    
    @IBOutlet weak var total_order_BEF: UILabel!
    @IBOutlet weak var total_amount_BEF: UILabel!
    @IBOutlet weak var order_amount_BEF: UILabel!
    @IBOutlet weak var commission_amount_BEF: UILabel!
    
    
    @IBOutlet weak var total_order_GRF: UILabel!
    @IBOutlet weak var total_amount_GRF: UILabel!
    @IBOutlet weak var order_amount_GRF: UILabel!
    @IBOutlet weak var commission_amount_GRF: UILabel!
    
    
    @IBOutlet weak var total_order_SHF: UILabel!
    @IBOutlet weak var total_amount_SHF: UILabel!
    @IBOutlet weak var order_amount_SHF: UILabel!
    @IBOutlet weak var commission_amount_SHF: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Variable -
    public var data: FoodAppReportData? = nil {
       didSet {
           mapData(data: data!)
       }
    }
    
    
    
    private func mapData(data: FoodAppReportData){
        
        total_order_GOF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_order_GOF) + " đơn"
        total_amount_GOF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_amount_GOF)
        order_amount_GOF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.order_amount_GOF)
        commission_amount_GOF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.commission_amount_GOF)
              
        total_order_BEF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_order_BEF) + " đơn"
        total_amount_BEF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_amount_BEF)
        order_amount_BEF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.order_amount_BEF)
        commission_amount_BEF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.commission_amount_BEF)
     
        total_order_GRF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_order_GRF) + " đơn"
        total_amount_GRF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_amount_GRF)
        order_amount_GRF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.order_amount_GRF)
        commission_amount_GRF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.commission_amount_GRF)
       
        total_order_SHF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_order_SHF) + " đơn"
        total_amount_SHF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.total_amount_SHF)
        order_amount_SHF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.order_amount_SHF)
        commission_amount_SHF.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.commission_amount_SHF)
    }
    
    
    
    
    
    
}
