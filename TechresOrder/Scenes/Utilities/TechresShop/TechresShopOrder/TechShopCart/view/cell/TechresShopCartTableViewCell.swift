//
//  TechresShopCartTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_name: UILabel!
    

    
    @IBOutlet weak var lbl_quantity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func actionDecreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        var array = viewModel.deviceArray.value
            
        if let p = array.firstIndex(where: {$0.id == data?.id}){
            array[p].quantity -= 1
            if array[p].quantity <= 0{
                array.remove(at: p)
            }
            viewModel.deviceArray.accept(array)
        }
        
    }
    
    
    
    @IBAction func actionIncreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        var array = viewModel.deviceArray.value
            
        if let p = array.firstIndex(where: {$0.id == data?.id}){
            array[p].quantity += 1
            
            viewModel.deviceArray.accept(array)
        }
    }
    
    
    var viewModel: TechresShopCartViewModel?
    
    
    public var data: TechresDevice? = nil{
        didSet{
            mapData(data: data!)
        }
    }
    
    
    private func mapData(data:TechresDevice){
        dLog(data.name)
        lbl_name.text = data.name
        lbl_quantity.text = String(data.quantity)
    }
    
    
}
