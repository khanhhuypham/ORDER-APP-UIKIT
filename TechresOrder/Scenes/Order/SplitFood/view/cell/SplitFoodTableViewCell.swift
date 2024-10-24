//
//  SplitFood_RebuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2023.
//

import UIKit

class SplitFoodTableViewCell: UITableViewCell {


    @IBOutlet weak var food_image: UIImageView!
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_addition_food: UILabel!
    @IBOutlet weak var lbl_remaining_quantity: UILabel!
    
    @IBOutlet weak var lbl_quantity_change: UILabel!
    @IBOutlet weak var gift_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        
        switch sender.titleLabel?.text{
            case "calculator":
                guard let viewModel = viewModel else {return}
                let foods = viewModel.dataArray.value
                
                    if let position = foods.firstIndex(where:{$0.id == data.id}){
                        let condition =  foods[position].is_sell_by_weight == ACTIVE ||
                                        foods[position].is_gift == ACTIVE ||
                                        foods[position].order_detail_additions.count > 0 ||
                                        foods[position].is_extra_Charge == ACTIVE
                        condition
                        ? increaseOrDecreaseByOne(operators: "+")
                        : viewModel.view?.presentModalInputQuantityViewController(position:position, current_quantity:0)
                }
                break
            default:
                increaseOrDecreaseByOne(operators:sender.titleLabel?.text ?? "+")
                break
        }
    }
    
    private func increaseOrDecreaseByOne(operators:String){
        guard let viewModel = viewModel else {return}

        var foods = viewModel.dataArray.value
        
        if let position = foods.firstIndex(where:{$0.id == data.id}){
            var quantityChange = foods[position].quantity_change
            let quantity = foods[position].quantity
            let condition = foods[position].is_sell_by_weight == ACTIVE ||
                            foods[position].is_gift == ACTIVE ||
                            foods[position].order_detail_additions.count > 0 ||
                            foods[position].is_extra_Charge == ACTIVE
        
            /*
                    + MÓN TẶNG vả MÓN BÁN THEO KG và MÓN BÁN KÈM và MÓN là PHỤ THU thì khi tách món thì ta sẽ tách hết
                    + còn lại thì tách theo từng phần
                */
            operators == "+"
            ? {quantityChange += condition ? quantity : 1}()
            : {quantityChange -= condition ? quantity : 1}()
            
    
            if quantityChange > 0 {
                foods[position].isChange = 1
                foods[position].quantity_change = quantityChange >= quantity ? quantity : quantityChange
            }else{
                foods[position].isChange = 0
                foods[position].quantity_change = 0
            }
        }
        viewModel.dataArray.accept(foods)
    }
    
    var viewModel: SplitFoodViewModel?
    
        
    public var data: OrderItem = OrderItem.init() {
        didSet {
            mappData(data: data)
        }
    }
    
    
    let color = NSAttributedString.Key.foregroundColor
    
    private func mappData(data:OrderItem){
        let remainingQuantity = data.quantity - data.quantity_change
        food_image.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data.food_avatar)), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_food_name.text = data.name
        lbl_food_name.textColor = data.isChange == 1 ?  ColorUtils.orange_brand_900() : ColorUtils.black()
        gift_icon.isHidden = data.is_gift == 1 ? false : true
        

        if(data.order_detail_additions.count > 0){
            
            var attr = [(str:"[Món bạn kèm]\n", properties:[color:ColorUtils.orange_brand_900()])]
            
            data.order_detail_additions.enumerated().forEach{(i,value) in
                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                attr.append((str:" = " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.total_price),properties:[color:ColorUtils.gray_600()]))
                if i != data.order_detail_additions.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
            }
            
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food,attributes: attr)
       
        }else if(data.order_detail_combo.count > 0){
            var attr:[(str: String, properties:[NSAttributedString.Key:Any])] = []
            data.order_detail_combo.enumerated().forEach{(i,value) in
                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                attr.append((str:" phần",properties:[color:ColorUtils.gray_600()]))
                if i != data.order_detail_combo.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
            }
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food,attributes:attr)
          }else{
              lbl_addition_food.text = ""
          }
        
        
        if data.is_sell_by_weight == ACTIVE{
            lbl_remaining_quantity.attributedText = Utils.setAttributesForLabel(
                label: lbl_remaining_quantity,
                attributes:[
                    (str:"Còn lại ",properties:[color:ColorUtils.blue_brand_700()]),
                    (str:String(format: remainingQuantity > 0 ? "%.2f ": "0 ", remainingQuantity, "phần"),properties:[color:ColorUtils.orange_brand_900()]),
                    (str:"phần",properties:[color:ColorUtils.blue_brand_700()])
                ])

           lbl_quantity_change.text = String(format: data.quantity_change > 0
                                      ? "%.2f"
                                      : "0"
                                      , data.quantity_change)
        }else{
            
            lbl_remaining_quantity.attributedText = Utils.setAttributesForLabel(
                label: lbl_remaining_quantity,
                attributes:[
                    (str:"Còn lại ",properties:[color:ColorUtils.blue_brand_700()]),
                    (str:String(format: remainingQuantity > 0 ? "%.0f ": "0 ", remainingQuantity, "phần"),properties:[color:ColorUtils.orange_brand_900()]),
                    (str:"phần",properties:[color:ColorUtils.blue_brand_700()])
                ])
            lbl_quantity_change.text = String(format: "%.0f", data.quantity_change)
        }
        
    }
}
