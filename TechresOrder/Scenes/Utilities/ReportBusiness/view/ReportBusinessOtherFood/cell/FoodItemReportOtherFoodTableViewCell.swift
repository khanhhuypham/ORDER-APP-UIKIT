//
//  FoodItemReportOtherFoodTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 10/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FoodItemReportOtherFoodTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var food_avatar: UIImageView!
    
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var avatar_food: UIImageView!
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var lbl_index_category: UILabel!
    @IBOutlet weak var view_root: UIView!
    
    
    var indexItem:Array<Any> = []
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    var data: FoodReport? {
        didSet{
            self.avatar_food.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: data!.food_avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
            self.lbl_food_name.text = data?.food_name
            self.lbl_quantity.text = Utils.stringQuantityFormatWithNumberFloat(amount: data!.quantity)
            self.lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data!.total_original_amount)
            self.lbl_index_category.text = String(self.index)
        }
    }
}
