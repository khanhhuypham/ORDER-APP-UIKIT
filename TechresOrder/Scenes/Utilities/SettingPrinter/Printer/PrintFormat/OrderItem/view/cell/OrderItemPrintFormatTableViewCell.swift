//
//  OrderItemPrintFormatTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/12/2023.
//

import UIKit

class OrderItemPrintFormatTableViewCell: UITableViewCell {

    @IBOutlet weak var container_view: UIView!
    
    @IBOutlet weak var lbl_item_name: UILabel!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_item_addition: UILabel!
    
    @IBOutlet weak var view_note: UIView!
    @IBOutlet weak var lbl_note: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var viewModel:OrderItemPrintFormatViewModel?
    
    var data: Food?{
        didSet {
          mapData(data: data!)
        }
    }
    
    
    private func mapData(data: Food){


        
        lbl_item_name.text = data.name
        
        if data.status == CANCEL_FOOD{
            lbl_item_name.attributedText = Utils.setAttributesForLabel(
                label: lbl_item_name,
                attributes: [
                    (str:data.name,properties:[crossLineKey:crossLineValue]),
            ])
            
        }
        

        var text = ""


        data.addition_foods.enumerated().forEach{(i,value) in
            if i != data.addition_foods.count - 1{
              text += String(format: " + %@ x %.0f\n",  value.name, value.quantity)
            }else{
              text += String(format: " + %@ x %.0f",  value.name, value.quantity)
            }
        }
        
        
        
        lbl_item_addition.text = text

        view_note.isHidden = data.note.count == 0 ? true : false
        lbl_note.text =  String(format: "(%@)", data.note)

        lbl_quantity.text = String(format:data.is_sell_by_weight == ACTIVE ?"%.2f":"%.0f", data.quantity)
        
        if let viewModel = self.viewModel{
            self.container_view.addBorder(toEdges: [.top], color: viewModel.view?.textColor ?? .systemGray5, thickness: 1)
        }

    }

}
