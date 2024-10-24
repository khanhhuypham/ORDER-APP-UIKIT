//
//  EditChildrenFoodTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/03/2024.
//

import UIKit
import JonAlert
import RxRelay

class EditChildrenFoodTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var btn_stick: UIButton!
    @IBOutlet weak var view_of_quantity: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    var viewModel:EditChildrenFoodViewModel?
    
    var data:OrderDetailAddition? = nil {
        didSet{
            guard let item = viewModel?.orderItem.value else {return}
            
            if item.is_allow_print_stamp == ACTIVE{
                view_of_quantity.isHidden = true
                btn_stick.isHidden = false
                lbl_name.text = String(format:"%@ x %@",
                    data?.name ?? "",
                    Utils.stringQuantityFormatWithNumberFloat(amount: data?.quantity ?? 0)
                )
                btn_stick.isSelected = data?.isSelected == ACTIVE
            }else{
                view_of_quantity.isHidden = false
                btn_stick.isHidden = true
                
                lbl_name.text = data?.name
                lbl_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: data?.quantity ?? 0)
            }
            
            let total_price = Float(data?.price ?? 0) * (data?.quantity ?? 0)
                
            lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: total_price)
          
        }
    }
    
    
    
    @IBAction func actionStick(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        
        var item = viewModel.orderItem.value
                
        btn_stick.isSelected = !btn_stick.isSelected
        
        if let index = item.order_detail_additions.firstIndex(where: {$0.id == data?.id}){
            
            item.order_detail_additions[index].isSelected = btn_stick.isSelected ? ACTIVE : DEACTIVE
            
            item.order_detail_additions[index].isChange = btn_stick.isSelected ? DEACTIVE : ACTIVE
        }
        
        viewModel.orderItem.accept(item)
    }
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        
        var item = viewModel.orderItem.value
        item.decreaseChildrenItemByOne(id: data?.id ?? 0)
        viewModel.orderItem.accept(item)
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        
        var item = viewModel.orderItem.value
        item.increaseChildrenItemByOne(id: data?.id ?? 0)
        viewModel.orderItem.accept(item)
        
    }
    
    
}
