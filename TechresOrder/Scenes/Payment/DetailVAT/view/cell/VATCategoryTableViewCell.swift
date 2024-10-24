//
//  VATCategoryTableViewCell.swift
//  TECHRES - Bán Hàng
//
//  Created by Kelvin on 20/03/2023.
//

import UIKit
import RxSwift

class VATCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_title_vat_percent: UILabel!
    @IBOutlet weak var lbl_food_quantity: UILabel!
    @IBOutlet weak var lbl_vat_total: UILabel!
    @IBOutlet weak var table_view_vat: UITableView!
    @IBOutlet weak var root_view_vat_category: UIView!
    
    
    var order_details = [DetailVAT]()
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        root_view_vat_category.round(with: .both, radius: 8)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: DetailVATViewModel? {
           didSet {
               registerCell()
           }
    }
    // MARK: - Variable -
    public var data: VATOrder? = nil {
        didSet {
            lbl_vat_total.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(floor(data!.vat_amount)))
            self.order_details = data!.order_details
            self.table_view_vat.reloadData()
            lbl_food_quantity.text = String(format: "%% (%d)", Int((data?.order_details.count)!))
            lbl_title_vat_percent.text = String(format:"%d" ,Int(data!.vat_percent))
        }
    }
    
    
    
}
extension VATCategoryTableViewCell{
    func registerCell() {
        let ItemFoodVATTableViewCell = UINib(nibName: "ItemFoodVATTableViewCell", bundle: .main)
        table_view_vat.register(ItemFoodVATTableViewCell, forCellReuseIdentifier: "ItemFoodVATTableViewCell")
        
        self.table_view_vat.rowHeight = UITableView.automaticDimension
        table_view_vat.separatorStyle = UITableViewCell.SeparatorStyle.none
        table_view_vat.isScrollEnabled = false
        table_view_vat.rowHeight = 90
        table_view_vat.rx.setDataSource(self).disposed(by: disposeBag)
        
    }
}

extension VATCategoryTableViewCell:UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemFoodVATTableViewCell", for: indexPath) as! ItemFoodVATTableViewCell
        cell.data = self.order_details[indexPath.row]
//        let order_detail = self.order_details[indexPath.row]
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.order_details.count
    }
}
