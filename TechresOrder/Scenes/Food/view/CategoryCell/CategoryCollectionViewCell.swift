//
//  AddFoodCollectionViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 04/01/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_category_name: UILabel!
    
    @IBOutlet weak var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionChooseCategory(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        var category = viewModel.categoryArray.value
        var parameter = viewModel.APIParameter.value
        
        for i in 0..<category.count{
            category[i].isSelected = category[i].id == data?.id ? ACTIVE : DEACTIVE
        }
        
        parameter.category_id = data!.id
        
        viewModel.APIParameter.accept(parameter)
        viewModel.categoryArray.accept(category)
       
        var APIParameter = viewModel.APIParameter.value
        APIParameter.key_word = ""
        viewModel.APIParameter.accept(APIParameter)
        
        viewModel.clearData()
        
        viewModel.view?.fetFoods()
    }
    
    
    var viewModel: AddFoodViewModel?
    
    var data: Category?{
        didSet{
            mapData(category: data!)
        }
    }
    private func mapData(category:Category){
        lbl_category_name.text = category.name
        lbl_category_name.textColor = category.isSelected == ACTIVE ? .white : ColorUtils.orange_brand_900()
        bubbleView.backgroundColor = category.isSelected == ACTIVE ? ColorUtils.orange_brand_900() : .white
    }
}
