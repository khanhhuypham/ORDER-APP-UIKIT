//
//  TechresShopOrderCollectionViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit

class TechresShopOrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var textfield_quantity: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textfield_quantity.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        textfield_quantity.setMaxValue(maxValue: 999)
        
    }
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        guard let viewModel = viewModel else {return}
        
        var array = viewModel.deviceArray.value
            
        if let p = array.firstIndex(where: {$0.id == data?.id}){
            array[p].quantity = Int(textField.text ?? "") ?? 0
            if array[p].quantity <= 0{
                array[p].quantity = 0
            }
            viewModel.deviceArray.accept(array)
        }
    }
    
    
    
    @IBAction func actionDecreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        var array = viewModel.deviceArray.value
            
        if let p = array.firstIndex(where: {$0.id == data?.id}){
            array[p].quantity -= 1
            if array[p].quantity <= 0{
                array[p].quantity = 0
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
    
    
    var viewModel: TechresShopOrderViewModel?
    
    
    public var data: TechresDevice? = nil{
        didSet{
            mapData(data: data!)
        }
    }
    
    
    private func mapData(data:TechresDevice){
        dLog(data.name)
        
        if let image =  data.images.first{
           img.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: image)), placeholder:  UIImage(named: "printer"))
        }
      
        lbl_name.text = data.name
        lbl_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.price ?? 0)
        textfield_quantity.text = String(data.quantity)
    }
    
}
