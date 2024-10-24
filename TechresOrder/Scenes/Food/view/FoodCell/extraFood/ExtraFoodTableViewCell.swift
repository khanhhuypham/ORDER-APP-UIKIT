//
//  ExtraFood_RebuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/09/2023.
//

import UIKit
import RxSwift
class ExtraFoodTableViewCell: UITableViewCell {
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var icon_check: UIImageView!
    @IBOutlet weak var view_of_quantity_related_action: UIView!
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_food_price: UILabel!

    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var view_gift: UIView!
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionCheckBtn(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        
        
        if var food = viewModel.getFood(id: data?.mainFood.id ?? 0){
            if let children = food.getChildren(id: data?.additionFood.id ?? 0){
         
                children.is_selected == ACTIVE
                ? food.deSelectChildren(id: data?.additionFood.id ?? 0)
                : food.selectChildren(id: data?.additionFood.id ?? 0)
            }
            viewModel.setElement(element: food, categoryType: .food)
        }
        
        
    }
    
    

    
    @IBAction func actionDecreaseQuantity(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}

        if var food = viewModel.getFood(id: data?.mainFood.id ?? 0){
            
    
            if let child = food.getChildren(id: data?.additionFood.id ?? 0){
                 food.setChildrenQuantity(id: child.id,quantity: child.quantity - 1)
            }
    
            viewModel.setElement(element: food, categoryType: .food)
        }
    }
    

    @IBAction func actionIncreaseQuantity(_ sender: UIButton) {
        
        if data?.mainFood.addition_foods.count ?? 0 > 0 &&  data?.mainFood.is_allow_print_stamp == ACTIVE{
            return
        }else{
            guard let viewModel = self.viewModel else {return}
            
            if var food = viewModel.getFood(id: data?.mainFood.id ?? 0){
                
                if let child = food.getChildren(id: data?.additionFood.id ?? 0){
                     food.setChildrenQuantity(id: child.id,quantity: child.quantity + 1)
                }
    
                viewModel.setElement(element: food, categoryType: .food)
            }
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    var viewModel: AddFoodViewModel?
    
    /*vì 2 món chính có thể chứa cùng 1 món phụ => datatype = (mainFood:Food, additionFood:FoodInCombo)
        ex:
            combo1:(rau,cơm,pepsi)
            combo2:(rau,cơm,coca)
     */
    
    var food:Food? = nil
    
//    var childFood:FoodAddition? = nil
    
    
    var data: (mainFood:Food, additionFood:FoodAddition)?{
        didSet{
            mapData(mainFood: data!.mainFood, additionFood: data!.additionFood)
        }
    }
    
    
    private func mapData(mainFood:Food, additionFood:FoodAddition){
        btnCheck.isUserInteractionEnabled = mainFood.is_combo == ACTIVE ? false : true
        icon_check.isHidden = mainFood.is_combo == ACTIVE ? true : false
        icon_check.image = UIImage(named: additionFood.is_selected == ACTIVE ? "check_2" : "un_check_2")
    
        lbl_food_name.text = data?.additionFood.name
        lbl_food_price.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: additionFood.price)
        lbl_food_price.isHidden = mainFood.food_list_in_promotion_buy_one_get_one.count > 0 ? true : false
        view_gift.isHidden =  mainFood.food_list_in_promotion_buy_one_get_one.count > 0 ? false : true
        let color = NSAttributedString.Key.foregroundColor
        let crossLine = NSAttributedString.Key.strikethroughStyle
        let value = NSNumber(value: NSUnderlineStyle.single.rawValue)
        
        if additionFood.temporary_price != 0 {
            if additionFood.price_with_temporary < additionFood.price{
                lbl_food_price.attributedText = Utils.setAttributesForLabel(
                    label: lbl_food_price,
                    attributes: [
                        (str:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: additionFood.price),properties:[color:ColorUtils.red_600(),crossLine:value]),
                        (str:"/" + additionFood.unit_type,properties:[color:ColorUtils.red_600(),crossLine:value]),
                        (str:" " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount: additionFood.price_with_temporary).replacingOccurrences(of: "-", with: ""),properties:[color:ColorUtils.green_600()])
                    ])
            } else if (additionFood.price_with_temporary > additionFood.price) {
                lbl_food_price.attributedText = Utils.setAttributesForLabel(
                    label: lbl_food_price,
                    attributes: [
                        (str:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: additionFood.price_with_temporary),properties:[color:ColorUtils.orange_brand_900()])
                    ])
            }
        }else{
            lbl_food_price.attributedText = Utils.setAttributesForLabel(
                label: lbl_food_price,
                attributes: [
                    (str:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: additionFood.price),properties:[color:ColorUtils.orange_brand_900()])
                ])
    
        }
        
        
        
        
        let conditionToHideView = mainFood.is_combo == ACTIVE || (mainFood.addition_foods.count > 0 && mainFood.is_allow_print_stamp == ACTIVE)
        
        
        view_of_quantity_related_action.isHidden = conditionToHideView ? true : false
        
        if mainFood.addition_foods.count > 0{
            lbl_quantity.text = String(additionFood.quantity)
        }else if mainFood.food_in_combo.count > 0 && mainFood.is_combo == ACTIVE {
            lbl_quantity.text = String(additionFood.combo_quantity)
        }else if mainFood.food_list_in_promotion_buy_one_get_one.count > 0{
            lbl_quantity.text = String(additionFood.quantity)
        }
    }

}
