//
//  PaymentRebuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit

class PaymentRebuildTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var main_view: UIView!
    
    @IBOutlet weak var avatar_food: UIImageView!
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_addition_food: UILabel!
    
    @IBOutlet weak var lbl_discount_percent: UILabel!
    @IBOutlet weak var view_discount: UIView!
    @IBOutlet weak var lbl_note: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!

    @IBOutlet weak var lbl_discount_price: UILabel!
    @IBOutlet weak var lbl_quantity_status_completed: UILabel!
    @IBOutlet weak var lbl_gift_amount: UILabel!
    @IBOutlet weak var view_note: UIView!

    @IBOutlet weak var view_gift: UIView!
    
    var timer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    deinit {
        timer?.invalidate()
        print("Memory Release : \(String(describing: self))\n" )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    var viewModel: PaymentRebuildViewModel?
    var orderStatus:Int?
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
        timer?.invalidate()
        
        avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data.food_avatar)), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_food_name.text = data.name
        view_discount.isHidden = data.discount_percent == 0 ? true : false
        view_note.isHidden = data.note.count == 0 ? true : false
        lbl_discount_percent.text = String(format: "Giảm giá %d%%", data.discount_percent)
        lbl_note.text = data.note
        lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                        label: lbl_quantity_status_completed,
                        attributes:[
                            (str:"Số lượng: ",properties:[color:UIColor.black]),
                            (str:String(format:data.is_sell_by_weight == ACTIVE ?"%.2f":"%.0f", data.quantity),properties:[color:ColorUtils.red_600()])
                        ])
        
       
        view_gift.isHidden = data.is_gift == 0 ? true : false
        self.backgroundColor = ColorUtils.white()
        
        
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
                lbl_status.text = "HOÀN TẤT"
                lbl_status.textColor = ColorUtils.green_600()
                break
            
            case .cooking:
                lbl_status.text = "ĐANG CHẾ BIẾN"
                lbl_status.textColor = ColorUtils.blue_brand_700()
                break
            
            case .pending:
                lbl_status.text = "CHƯA XÁC NHẬN"
                lbl_status.textColor = ColorUtils.orange_brand_900()
                break

            case .cancel:
                lbl_status.text = "ĐÃ HỦY"
                lbl_status.textColor = ColorUtils.red_500()
                self.backgroundColor = ColorUtils.red_000()
                break
            
            case .servic_block_using:
                avatar_food.image = UIImage(named:"icon-service-block-using")
                lbl_status.text = "ĐANG SỬ DỤNG"
                lbl_status.textColor = ColorUtils.green_600()
            
                lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                    label: lbl_quantity_status_completed,
                                attributes:[
                                    (str:String(format:"%@",TimeUtils.ConvertMinutetoHourMinuteFormat(minute)),properties:[color:ColorUtils.green_600()]),
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
                avatar_food.image = orderStatus == ORDER_STATUS_COMPLETE ? UIImage(named:"image_defauft_medium") : UIImage(named:"icon-service-block-stop")
                lbl_status.text = orderStatus == ORDER_STATUS_COMPLETE ? "HOÀN THÀNH" : "ĐANG TẠM DỪNG"
                lbl_status.textColor = orderStatus == ORDER_STATUS_COMPLETE ? ColorUtils.green_600() : ColorUtils.red_500()
            
                lbl_quantity_status_completed.attributedText = Utils.setAttributesForLabel(
                                label: lbl_quantity_status_completed,
                                attributes:[
                                    (str:TimeUtils.ConvertMinutetoHourMinuteFormat(data.service_time_used),properties:[color:ColorUtils.red_600()]),
                                ])

                break
                
            default:
                break
        }
        
        /*
            các trường hợp khi bàn ở trạng thái booking
         */
        if viewModel.order.value.booking_status == STATUS_BOOKING_SET_UP {
            switch data.category_type {
               
                case .food:
                    lbl_quantity_status_completed.isHidden = false
            
                default:
                    break
                 
            }
                
        }
            
        lbl_addition_food.text = ""
        lbl_addition_food.isHidden = true
        var attr:[(str: String, properties:[NSAttributedString.Key:Any])] = []
        if(data.order_detail_additions.count > 0){
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
        }else if(data.order_detail_combo.count > 0){
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
        }else if data.order_detail_buffetTicket.count > 0 {
            lbl_addition_food.isHidden = false
            data.order_detail_buffetTicket.enumerated().forEach{(i,value) in

                attr.append((str:String(format:"+ %@ ",value.name),properties:[color:ColorUtils.gray_600()]))
                attr.append((str:String(format:"x %.0f",value.quantity),properties:[color:ColorUtils.orange_brand_900()]))
                
                if value.discountPercent > 0{
                   
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

                    attr.append((str:" = " + Utils.stringVietnameseMoneyFormatWithNumberInt(amount:value.total_price),properties:[color:ColorUtils.gray_600()]))
                }
                
                if i != data.order_detail_buffetTicket.count - 1{
                    attr.append((str:"\n",properties:[:]))
                }
                
            }
            lbl_addition_food.attributedText = Utils.setAttributesForLabel(label: lbl_addition_food, attributes: attr)
        }
    }
}
