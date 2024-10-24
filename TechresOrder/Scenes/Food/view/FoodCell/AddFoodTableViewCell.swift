//
//  AddFood_RebuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/09/2023.
//

import UIKit
import RxRelay
import RxSwift
class AddFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon_check: UIImageView!
    @IBOutlet weak var btn_check: UIButton!
    
    @IBOutlet weak var food_image: UIImageView!

    @IBOutlet weak var padding_right_of_stack_view: NSLayoutConstraint!
    @IBOutlet weak var view_of_scale_icon: UIView!
    @IBOutlet weak var view_of_gift_icon: UIView!
    @IBOutlet weak var lbl_food_name: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var lbl_note: UILabel!
    
    @IBOutlet weak var view_note: UIView!
    
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var view_discount: UIView!
    
    @IBOutlet weak var parent_view_of_action: UIView!
    @IBOutlet weak var view_relatedQuantity_action: UIView!
    
    @IBOutlet weak var view_btn: UIView!
    @IBOutlet weak var lbl_out_of_food: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_tableView: NSLayoutConstraint!
    @IBOutlet weak var hand_holder: UIView!
    

    private(set) var disposeBag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hand_holder.roundCorners(corners: [.topLeft,.bottomLeft], radius: 6)
        hand_holder.backgroundColor = ColorUtils.gray_600()
        registerCell()
        bindTableViewData()
    }
    
    @IBAction func actionCheckBtn(_ sender: Any) {

        guard let viewModel = viewModel else {return}
    
        
        if var food = viewModel.getFood(id: data?.id ?? 0){
            
            food.is_selected == ACTIVE
            ? food.deSelect()
            : food.select()
            
            viewModel.setElement(element: food, categoryType: .food)
        }
        
    }
    
    
    @IBAction func actionShowCalculator(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        
        if let food = viewModel.getFood(id: data?.id ?? 0){
            viewModel.view?.presentModalInputQuantityViewController(item:food)
        }
    }
    
    
    @IBAction func actionDecreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        
        if var food = viewModel.getFood(id: data?.id ?? 0){
            
            food.setQuantity(
                quantity: food.quantity - (food.is_sell_by_weight == ACTIVE ? 0.01 : 1)
            )
            viewModel.setElement(element: food, categoryType: .food)
        }
        
    }
    
    
    
    @IBAction func actionIncreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}

        if var food = viewModel.getFood(id: data?.id ?? 0){
            
            food.setQuantity(
                quantity: food.quantity + (food.is_sell_by_weight == ACTIVE ? 0.01 : 1)
            )
            
            viewModel.setElement(element: food, categoryType: .food)
        }
    }
    
    
    var viewModel: AddFoodViewModel?
    
    var data: Food?{
        didSet{
            mapData(food: data!)
        }
    }
    
    var additionFood = BehaviorRelay<[(mainFood:Food, additionFood:FoodAddition)]>(value: [])
    
    private func mapData(food:Food){
        guard let viewModel = viewModel else {return}
        btn_check.isUserInteractionEnabled = true
        icon_check.image = UIImage(named: food.is_selected == ACTIVE ? "check_2" : "un_check_2")
        parent_view_of_action.isHidden = food.is_selected == ACTIVE ? false : true

        
        view_relatedQuantity_action.isHidden = food.is_selected == ACTIVE ? false : true
        view_btn.isHidden = food.category_type == .service ? true : false
        food_image.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: food.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
        lbl_food_name.text = food.name
        
        
        if food.is_selected == ACTIVE{
            viewModel.view?.view.endEditing(true)
        }
             
        let color = NSAttributedString.Key.foregroundColor
        let crossLine = NSAttributedString.Key.strikethroughStyle
        let value = NSNumber(value: NSUnderlineStyle.single.rawValue)
        if food.temporary_price < 0 {
            lbl_price.attributedText = Utils.setAttributesForLabel(
                label: lbl_price,
                attributes: [
                    (str:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: food.price),properties:[color:ColorUtils.red_600(),crossLine:value]),
                    (str:"/" + food.unit_type,properties:[color:ColorUtils.red_600(),crossLine:value]),
                    (str:" " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount: food.price_with_temporary).replacingOccurrences(of: "-", with: ""),properties:[color:ColorUtils.green_600()]),
                    (str:"/" + food.unit_type,properties:[color:ColorUtils.gray_600()])
            ])
        }else{
            
            lbl_price.attributedText = Utils.setAttributesForLabel(
                label: lbl_price,
                attributes: [
                    (str:Utils.stringVietnameseMoneyFormatWithNumberInt(amount: food.price_with_temporary),properties:[color:ColorUtils.orange_brand_900()]),
                    (str:"/" + food.unit_type,properties:[color:ColorUtils.gray_600()]),
            ])
        }
        
        // KIỂM TRA MÓN HẾT HOẶC MÓN CHƯA GÁN BẾP ( ĐỐI VỚI MÓN CÓ THUỘC TÍNH IN BẾP )
        if(food.restaurant_kitchen_place_id == DEACTIVE ){
            
            if food.category_type == .service{ // trừ trường hợp category_type là serevice
                lbl_out_of_food.isHidden = true
                btn_check.isUserInteractionEnabled = true
                self.isUserInteractionEnabled = true
                hand_holder.isHidden = false
            }else{
                parent_view_of_action.isHidden = false
                lbl_out_of_food.isHidden = false
                lbl_out_of_food.text = "chưa có bếp".uppercased()
                btn_check.isUserInteractionEnabled = false
                icon_check.image = UIImage(named: "icon-check-disable")
                self.isUserInteractionEnabled = false
                hand_holder.isHidden = true
            }
           
        }else{
            if(food.is_out_stock == ACTIVE){
                parent_view_of_action.isHidden = false
                lbl_out_of_food.isHidden = false
                lbl_out_of_food.text = "hết món".uppercased()
                btn_check.isUserInteractionEnabled = false
                icon_check.image = UIImage(named: "icon-check-disable")
                self.isUserInteractionEnabled = false
                hand_holder.isHidden = true
            }else{
                lbl_out_of_food.isHidden = true
                lbl_out_of_food.text = ""
                self.isUserInteractionEnabled = true
                
                hand_holder.isHidden = false
            }
        }
        
        
        
        //Quantity
        lbl_quantity.text = String(format: food.is_sell_by_weight == ACTIVE ? "%.2f" : "%.0f" , food.quantity)
        
        //discount
        lbl_discount.text = String(format: "%d%%", food.discount_percent)
        view_discount.isHidden = food.discount_percent > 0 ? false : true
        
        //Note
        lbl_note.text = food.note
        view_note.isHidden = food.note.count > 0 ? false : true
        view_of_gift_icon.isHidden = food.food_list_in_promotion_buy_one_get_one.count > 0 ? false : true
        view_of_scale_icon.isHidden = food.is_sell_by_weight == ACTIVE ? false : true

        tableView.isHidden = food.is_selected == ACTIVE ? false : true
        

        if food.addition_foods.count > 0{
            height_of_tableView.constant = CGFloat(food.addition_foods.count*60)
            additionFood.accept(food.addition_foods.map{(value) in (mainFood:food, additionFood:value)})
        }else if food.food_in_combo.count > 0 && food.is_combo == ACTIVE{
            height_of_tableView.constant = CGFloat(food.food_in_combo.count*60)
            additionFood.accept(food.food_in_combo.map{(value) in (mainFood:food, additionFood:value)})
        }else if food.food_list_in_promotion_buy_one_get_one.count > 0 {
            /*
                    Đối với món mua 1 mua 1 tặng 1
                    TH1: món tặng -> thì ẩn đi tất cả các món con (chỉ được tặng món cha thôi không dc tặng món con)
                    TH2: không phải món tăng -> thì hiện lên tất cả các món con
                */
            let isGifted = viewModel.APIParameter.value.is_allow_employee_gift == ACTIVE
            
            height_of_tableView.constant = isGifted ? 0 : CGFloat(food.food_list_in_promotion_buy_one_get_one.count*60)
            additionFood.accept(isGifted ? [] : food.food_list_in_promotion_buy_one_get_one.map{(value) in (mainFood:food, additionFood:value)})
            
        }else{
            height_of_tableView.constant = 0
            additionFood.accept([])
        }
    }

}


extension AddFoodTableViewCell{
    func registerCell() {
        let extraFoodTableViewCell = UINib(nibName: "ExtraFoodTableViewCell", bundle: .main)
        tableView.register(extraFoodTableViewCell, forCellReuseIdentifier: "ExtraFoodTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false
        tableView.rx.setDelegate(self).disposed(by:disposeBag)
    }
    
    private func bindTableViewData() {
        additionFood.bind(to: tableView.rx.items(cellIdentifier: "ExtraFoodTableViewCell", cellType: ExtraFoodTableViewCell.self))
           {  (row, food, cell) in
               cell.viewModel = self.viewModel
               cell.data = food
           }.disposed(by: disposeBag)
    }
}


extension AddFoodTableViewCell: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

