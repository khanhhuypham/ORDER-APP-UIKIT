//
//  OrderDetail_RebuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/09/2023.
//

import UIKit
import JonAlert
class OrderDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_addition_food: UILabel!
    
    @IBOutlet weak var lbl_status: UILabel!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var lbl_amount: UILabel!
    
    @IBOutlet weak var lbl_discount_percent: UILabel!
    @IBOutlet weak var lbl_quantity_status_completed: UILabel!
    
    @IBOutlet weak var lbl_note: UILabel!
    @IBOutlet weak var view_note: UIView!
    
    @IBOutlet weak var lbl_discount_price: UILabel!
    @IBOutlet weak var view_discount: UIView!
    
    
    @IBOutlet weak var parent_view_of_view_action: UIView!
    @IBOutlet weak var view_relatedQuantity_action: UIView!
    
    @IBOutlet weak var lbl_gift_amount: UILabel!
    @IBOutlet weak var view_gift: UIView!
    
    @IBOutlet weak var lbl_service_time_block: UILabel!
    
    @IBOutlet weak var hand_holder: UIView!
    
    @IBOutlet weak var btn_pause_service: UIButton!
    @IBOutlet weak var btn_show_service_popup: UIButton!
    
    
    
    var timer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hand_holder.roundCorners(corners: [.bottomLeft,.topLeft], radius: 6)
    }
    
    deinit {
        timer?.invalidate()
        print("Memory Release : \(String(describing: self))\n" )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    var viewModel: OrderDetailViewModel?
    
    
    
    
    var data: OrderItem?{
        didSet {
            mapData(data: data!)
        }
    }
    


    private func mapData(data: OrderItem){
        guard let viewModel = viewModel else {return}
        let totalPrice = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount:data.order_detail_additions.count > 0 ? data.total_price_include_addition_foods : data.total_price)
        let discountedPrice = Utils.stringVietnameseMoneyFormatWithNumberInt(amount:data.discount_price)
        var minute = data.service_time_used
        var second = TimeUtils.getSecondSFromDateString(dateString: data.service_end_time)
        dLog(data.total_price)
        timer?.invalidate()
        
        parent_view_of_view_action.isHidden = false
        view_relatedQuantity_action.isHidden = false
        lbl_quantity_status_completed.isHidden = false
        view_discount.isHidden = data.discount_percent == 0 ? true : false
        view_note.isHidden = data.note.count == 0 ? true : false
        view_gift.isHidden = data.is_gift == 0 ? true : false
        lbl_status.isHidden = false
        btn_pause_service.isHidden = true
        btn_show_service_popup.isHidden = true
        
        
        avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data.food_avatar)), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_food_name.text = data.name
        lbl_discount_percent.text = String(format: "Giảm giá %d%%", data.discount_percent)
        lbl_note.text = data.note
        lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
            label: lbl_quantity_status_completed,
            attributes:[
                (str:"Số lượng: ",properties:[color:UIColor.black]),
                (str:String(format:data.is_sell_by_weight == ACTIVE ?"%.2f":"%.0f", data.quantity),properties:[color:ColorUtils.red_600()])
            ]
        )
   
        lbl_quantity.text = String(format: data.is_sell_by_weight == ACTIVE ? "%.2f" : "%.0f ", data.quantity)
      
        lbl_service_time_block.text = String(format: "%@ giờ đầu tiên: %@/giờ",
                                             Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.time_block_price),
                                             Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data.block_price))
        lbl_service_time_block.isHidden = data.is_enable_block == ACTIVE ? false : true
        
        
        if(data.is_gift == 1){
            lbl_discount_price.isHidden = true
            lbl_amount.text = "0"
            lbl_gift_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(data.price) * data.quantity)
        }else{
            
            lbl_discount_price.isHidden = data.discount_amount > 0 ? false : true
            
            if data.discount_amount > 0{
                
                lbl_amount.text = discountedPrice
                
                lbl_discount_price.attributedText = Utils.setAttributesForLabel(
                    label:lbl_discount_price,
                    attributes: [
                        (str: totalPrice,properties:[color:ColorUtils.gray_600(),crossLineKey:crossLineValue])
                    ]
                )
                
            }else{
                lbl_amount.text = totalPrice
            }
            
        }

        
        
        switch data.status {
            case .done:
            
                let text1 = "HOÀN TẤT"
                var text2 = ""
            
                view_relatedQuantity_action.isHidden = true
                lbl_quantity_status_completed.isHidden = false
                self.backgroundColor = ColorUtils.white()
                hand_holder.isHidden = false
            
                if data.category_type == .buffet_ticket{
                    hand_holder.backgroundColor = ColorUtils.blue_brand_700()
                }else{
                    hand_holder.backgroundColor = data.buffet_ticket_id > 0 ? ColorUtils.red_500() : ColorUtils.green_600()
                }
         
            
                
                if data.category_type == .drink || data.category_type == .other {
                    
                    if data.quantity == 0 && data.buffet_ticket_id == 0{
                        hand_holder.isHidden = true
                    }
                    
                  
                    if permissionUtils.GPBH_2{
                        /*Nếu chưa trả bia rồi -> (ĐÃ XÁC NHẬN)*/
                        text2 = data.enable_return_beer == DEACTIVE ? " (ĐÃ XÁC NHẬN)" : ""
                        
                    }else if permissionUtils.GPBH_3{
                        /*Nếu chưa trả bia và sử dụng máy pos*/
                        if data.enable_return_beer == ACTIVE && data.is_only_use_printer == DEACTIVE{
                            
                            text2 = " (CHỜ XÁC NHẬN)"
                            
                        /*Nếu trả bia rồi và sử dụng máy In rời*/
                        }else if data.enable_return_beer == DEACTIVE && data.is_only_use_printer == ACTIVE {
                            
                            text2 = " (ĐÃ XÁC NHẬN)"
                        }

                    }
                
                }
                
            
                lbl_status.attributedText = Utils.setAttributesForLabel(
                    label: lbl_status,
                    attributes: [
                        (str:text1,properties:[color:ColorUtils.green_600()]),
                        (str:text2,properties:[color:ColorUtils.blue_brand_700()])
                ])
            
        
                break
            
            case .cooking:
            
                lbl_status.text = "ĐANG CHẾ BIẾN"
                lbl_status.textColor = ColorUtils.blue_brand_700()
                view_relatedQuantity_action.isHidden = true
                lbl_quantity_status_completed.isHidden = false
                self.backgroundColor = ColorUtils.white()
                hand_holder.backgroundColor = ColorUtils.green_600()
                break
            
            case .pending:
                lbl_status.text = data.category_type == .drink || data.category_type == .other ? "CHỜ XUẤT KHO" : "CHỜ CHẾ BIẾN"
                lbl_status.textColor = ColorUtils.orange_brand_900()
                view_relatedQuantity_action.isHidden = false
                lbl_quantity_status_completed.isHidden = true
                self.backgroundColor = ColorUtils.white()
                hand_holder.backgroundColor = ColorUtils.gray_600()
                hand_holder.isHidden = false
                break
            
            case .not_enough:
                lbl_status.text = "HẾT MÓN"
                lbl_status.textColor = ColorUtils.red_500()
                view_relatedQuantity_action.isHidden = true
                lbl_quantity_status_completed.isHidden = false
                self.backgroundColor = ColorUtils.red_000()
                hand_holder.isHidden = true
                break
            
            case .cancel:
                lbl_status.text = "ĐÃ HỦY"
                lbl_status.textColor = ColorUtils.red_500()
                view_relatedQuantity_action.isHidden = true
                lbl_quantity_status_completed.isHidden = false
                self.backgroundColor = ColorUtils.red_000()
                hand_holder.isHidden = true
            
                if data.category_type == .service{
                    lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                        label: lbl_quantity_status_completed,
                        attributes:[
                            (str:String(format:"%@",TimeUtils.calculateTime(minute)),properties:[color:ColorUtils.red_600()]),
                        ])
                }
                break
            
            case .servic_block_using:
                avatar_food.image = UIImage(named:"icon-service-block-using")
                lbl_status.text = "ĐANG SỬ DỤNG"
                lbl_status.textColor = ColorUtils.green_600()
                view_relatedQuantity_action.isHidden = true
                lbl_quantity_status_completed.isHidden = false

                btn_pause_service.isHidden = false
                btn_show_service_popup.isHidden = false
                self.backgroundColor = .white
                hand_holder.backgroundColor = ColorUtils.blue_brand_700()
                hand_holder.isHidden = false
            
                lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                    label: lbl_quantity_status_completed,
                    attributes:[
                        (str:String(format:"%@",TimeUtils.ConvertMinutetoHourMinuteFormat(minute)),properties:[color:ColorUtils.green_600()])
                    ])
           
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                    
                    second += 1
                    if second == 59{
                        second = 0
                        minute += 1
                    }
                    
                    self!.lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                        label: self!.lbl_quantity_status_completed,
                        attributes:[
                            (str:String(format:"%@",TimeUtils.ConvertMinutetoHourMinuteFormat(minute)),properties:[color:ColorUtils.green_600()])
                        ])
                }
            
                break
            
            case .servic_block_stopped:
            
                avatar_food.image = UIImage(named:"icon-service-block-stop")
                lbl_status.text = "ĐANG TẠM DỪNG"
                lbl_status.textColor = ColorUtils.red_500()
                view_relatedQuantity_action.isHidden = true
                lbl_quantity_status_completed.isHidden = false
                lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                                label: lbl_quantity_status_completed,
                                attributes:[
                                    (str:TimeUtils.ConvertMinutetoHourMinuteFormat(data.service_time_used),properties:[color:ColorUtils.red_600()]),
                                ])
                btn_pause_service.isHidden = false
                btn_show_service_popup.isHidden = false
                self.backgroundColor = .white
                hand_holder.backgroundColor = ColorUtils.blue_brand_700()
                hand_holder.isHidden = false
                break
            
            default:
                break
        }
        
        
        /*
            các trường hợp khi bàn ở trạng thái booking
         */
        
        if data.is_booking_item == ACTIVE{
            switch data.category_type {
                case .drink:
                    hand_holder.backgroundColor = ColorUtils.gray_600()
                    break
                
                case .food:
                    view_relatedQuantity_action.isHidden = true
                    lbl_quantity_status_completed.isHidden = false
                    hand_holder.isHidden = true
                    break
                
                case .service:
                    lbl_status.isHidden = true
                    parent_view_of_view_action.isHidden = true
                    hand_holder.isHidden = true
                    break
                
                default:
                    parent_view_of_view_action.isHidden = false
                    hand_holder.isHidden = true
                    break
                }
        }
        
            
        var attr:[(str: String, properties:[NSAttributedString.Key:Any])] = []
        
        if data.order_detail_additions.count > 0 {
            attr.append((str:"[Món bán kèm]\n", properties:[color:ColorUtils.orange_brand_900()]))
            lbl_addition_food.isHidden = false
            data.order_detail_additions.enumerated().forEach{(i,value) in
                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                attr.append((str:" = " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.total_price),properties:[color:ColorUtils.gray_600()]))
                if i != data.order_detail_additions.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
            }
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food, attributes: attr)
        }else if data.order_detail_combo.count > 0 {

            lbl_addition_food.isHidden = false
            data.order_detail_combo.enumerated().forEach{(i,value) in
                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                attr.append((str:" phần",properties:[color:ColorUtils.gray_600()]))
                if i != data.order_detail_combo.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
            }
            
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food,attributes:attr)
        }else if data.order_detail_promotion_foods.count > 0{
            attr.append((str:"[Quà tặng kèm]\n", properties:[color:ColorUtils.orange_brand_900()]))
            lbl_addition_food.isHidden = false
            data.order_detail_promotion_foods.enumerated().forEach{(i,value) in
                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                if i != data.order_detail_promotion_foods.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
            }
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food, attributes: attr)
        }else if data.order_detail_buffetTicket.count > 0 {
            
            lbl_addition_food.isHidden = false
            data.order_detail_buffetTicket.enumerated().forEach{(i,value) in

                if value.discountPercent > 0{
                    attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                    attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                    
                    attr.append((
                        str:" = " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.discountPrice) + " ",
                        properties:[color:ColorUtils.gray_600()]
                    ))
                    
                    attr.append((
                        str: Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.total_price),
                        properties:[color:ColorUtils.gray_600(),crossLineKey:crossLineValue]
                    ))

                    attr.append((str:String(format:"\n   (Giảm giá %d%%)",value.discountPercent),properties:[color:ColorUtils.blue_brand_700()]))
                    
                }else{
                    attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                    attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                    attr.append((str:" = " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.total_price),properties:[color:ColorUtils.gray_600()]))
                }
                
                if i != data.order_detail_buffetTicket.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }

            }
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food, attributes: attr)
        }else{
            lbl_addition_food.text = ""
            lbl_addition_food.isHidden = true
        }
    }
    
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        
        switch sender.titleLabel?.text{
            case "calculator":
                presentCalculator()
                break
            
            case "+":
                increaseByOne()
                break
            
            case "-":
                decreaseByOne()
                break
            
            default:
                break
        }
    }
    
    
    private func presentCalculator(){
        guard let viewModel = viewModel else {return}
        if data?.is_gift == DEACTIVE && data?.order_detail_promotion_foods.count == 0{ // món tặng không được phép chỉnh sửa số lượng
          
            if let position = viewModel.order.value.order_details.firstIndex(where: {$0.id == data?.id}){
                viewModel.view?.presentModalInputQuantityViewController(currentQuantity: 0, is_sell_by_weight: data!.is_sell_by_weight,position: position)
            }
            
        }else {
            
            viewModel.view?.showWarningMessage(content: "Món tặng không được phép thay đổi số lượng")
        }
    }
    
    
    private func increaseByOne(){
        guard let viewModel = viewModel else {return}
        
        // món tặng và món khuyến mãi không được phép chỉnh sửa số lượng
        if data?.is_gift == DEACTIVE  &&  data?.order_detail_promotion_foods.count == 0{
            var order = viewModel.order.value
            if let position = order.order_details.firstIndex(where:{$0.id == data?.id}){
                
                var food = order.order_details[position]
                food.setQuantity(quantity: food.quantity + (food.is_sell_by_weight == ACTIVE ? 0.01 : 1))
                
                order.order_details[position] = food
            }
            viewModel.order.accept(order)
        }else{
            viewModel.view?.showWarningMessage(content: "Món tặng không được phép thay đổi số lượng")

        }
        
    }
    
    
    private func decreaseByOne(){
        guard let viewModel = viewModel else {return}
        
        if data?.is_gift == DEACTIVE &&  data?.order_detail_promotion_foods.count == 0{// món tặng không được phép chỉnh sửa số lượng
      
            var order = viewModel.order.value
            if let position = order.order_details.firstIndex(where:{$0.id == data?.id}){

                var food = order.order_details[position]
                
                food.setQuantity(quantity: food.quantity - (food.is_sell_by_weight == ACTIVE ? 0.01 : 1))
                
                if food.quantity < 0.01{
                    viewModel.view?.handleCancelFood(item: food)
                }else{
                    order.order_details[position] = food
                }
            }
            viewModel.order.accept(order)
        }
    }
    
    @IBAction func actionShowServicePopup(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        viewModel.view?.presentServicePopupViewController(orderItem: data!)
    }
    
    @IBAction func actionPauseService(_ sender: Any) {
        guard let viewModel = viewModel else {return}
        viewModel.view?.pauseService(orderDetailId: data?.id ?? 0)
    }
    
}
    
