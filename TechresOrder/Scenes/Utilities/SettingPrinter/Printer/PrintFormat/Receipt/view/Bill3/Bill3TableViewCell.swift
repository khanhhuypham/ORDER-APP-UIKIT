//
//  ReceiptPrintFormatTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/12/2023.
//



import UIKit

class Bill3TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_addition_food: UILabel!
    
    @IBOutlet weak var lbl_amount: UILabel!

    @IBOutlet weak var lbl_discount_price: UILabel!
    @IBOutlet weak var lbl_vat: UILabel!
    
    @IBOutlet weak var view_of_food_note: UIView!
    @IBOutlet weak var lbl_note: UILabel!
    
    @IBOutlet weak var view_gift: UIView!
    @IBOutlet weak var lbl_gift_food_value: UILabel!
    
    @IBOutlet weak var underlineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = .white
    }
    deinit {
        print("Memory Release : \(String(describing: self))\n" )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    

  
    var data: OrderItem?{
        didSet {
            mapData(data: data!)
        }
    }
    

    private func mapData(data: OrderItem){
        let setting = ManageCacheObject.getSetting()
        lbl_food_name.text = data.name
        lbl_note.text = data.note
        lbl_vat.text = String(format: "(%d%%)", data.vat_percent)
        lbl_vat.isHidden = setting.is_show_vat_on_items_in_bill == ACTIVE ? false : true
        lbl_quantity.text = String(format:data.is_sell_by_weight == ACTIVE ?"%.2f x %@":"%.0f x %@", data.quantity,Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.price))
        
        view_gift.isHidden = data.is_gift == 0 ? true : false
//        view_of_food_note.isHidden = data.note.count == 0 ? true : false
        
        var text = ""

        data.order_detail_additions.enumerated().forEach{(i,value) in
            
            var lastStr = Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.total_price)
            
            if setting.is_show_vat_on_items_in_bill == ACTIVE{
                lastStr += String(format: " (%@%%)", Utils.stringVietnameseMoneyFormatWithNumberInt(amount: value.vat_percent))
            }
            
            if i != data.order_detail_additions.count - 1 {
                lastStr += "\n"
            }
            
            text += String(format: " + %@ x %.0f = %@",value.name,value.quantity,lastStr)
        }
                
        
        data.order_detail_combo.enumerated().forEach{(i,value) in
            
            text += String(format: i == data.order_detail_combo.count - 1 ? " + %@ x %.0f phẩn" : " + %@ x %.0f phần\n",value.name, value.quantity)
            
        }
        
        
        lbl_addition_food.text = text

     
        if(data.is_gift == 1){
            lbl_discount_price.isHidden = true
            lbl_amount.text = "0"
            lbl_gift_food_value.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data.price) * data.quantity)
        }else{
            lbl_discount_price.isHidden = data.discount_amount > 0 ? false : true
            
            if data.discount_amount > 0{
                
                lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount:data.discount_price)
                
                lbl_discount_price.attributedText = Utils.setAttributesForLabel(
                    label: lbl_discount_price,
                    attributes: [(
                        str:Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data.total_price),
                        properties:[
                            color:UIColor.white,
                            crossLineKey:crossLineValue
                        ]
                    ),
                        
                ])
            }else{
                lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: data.order_detail_additions.count > 0
                                                                             ? data.total_price_include_addition_foods
                                                                             : data.total_price)
            }
            
            
        }
        
    }
    
 

}

