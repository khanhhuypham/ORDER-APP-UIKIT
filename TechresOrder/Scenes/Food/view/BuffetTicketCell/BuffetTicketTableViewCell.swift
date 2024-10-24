//
//  BuffetTicketTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/04/2024.
//

import UIKit
import RxSwift
import RxRelay

class BuffetTicketTableViewCell: UITableViewCell {
    @IBOutlet weak var icon_check: UIImageView!
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var buffet_image: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var view_discount: UIView!
    @IBOutlet weak var lbl_quantity: UILabel!
    
    
    @IBOutlet weak var parent_view_of_action: UIView!
    @IBOutlet weak var view_relatedQuantity_action: UIView!
    @IBOutlet weak var view_btn: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height_of_tableView: NSLayoutConstraint!
    @IBOutlet weak var hand_holder: UIView!
    
    
    
    private(set) var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hand_holder.roundCorners(corners: [.topLeft,.bottomLeft], radius: 6)
        hand_holder.backgroundColor = ColorUtils.orange_brand_900()
        registerAndBindTable()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    @IBAction func actionCheckBtn(_ sender: Any) {

        guard let viewModel = viewModel else {return}
        if var buffet = viewModel.getBuffet(id: data?.id ?? 0){
           
            buffet.isSelected == ACTIVE
            ? buffet.deSelect()
            : buffet.select()
            
            viewModel.setElement(element: buffet, categoryType: .buffet_ticket)
        }
    
    }
    
    
    @IBAction func actionShowCalculator(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        
        if let buffet = viewModel.getBuffet(id: data?.id ?? 0){
            viewModel.view?.presentModalInputQuantityViewController(item:buffet)
        }
    }
    
    
    @IBAction func actionDecreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        
        if var buffet = viewModel.getBuffet(id: data?.id ?? 0){
            buffet.decreaseByOne()
            viewModel.setElement(element: buffet, categoryType: .buffet_ticket)
        }
        
    }
    
    
    @IBAction func actionIncreaseQuantity(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        if var buffet = viewModel.getBuffet(id: data?.id ?? 0){
            buffet.increaseByOne()
            viewModel.setElement(element: buffet, categoryType: .buffet_ticket)
        }

    }
    
    
    var viewModel:AddFoodViewModel?
    var buffetticket = BehaviorRelay<[BuffetTicketChild]>(value: [])
    
    var data:Buffet?{
        didSet{
            guard var buffet = self.data,let viewModel = viewModel else {return}
            
            icon_check.image = UIImage(named: buffet.isSelected == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck")
            buffet_image.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: buffet.avatar)), placeholder:  UIImage(named: "image_defauft_medium"))
            
            parent_view_of_action.isHidden = buffet.child_price != 0 ? true : false
            
            buffetticket.accept(buffet.ticketChildren)
            
            height_of_tableView.constant = CGFloat(buffet.ticketChildren.count * 60)
            
            
            tableView.isHidden = buffet.isSelected == ACTIVE ? false : true
            
            if buffet.isSelected == ACTIVE{
                viewModel.view?.view.endEditing(true)
                
                if buffet.ticketChildren.filter{$0.isSelected == DEACTIVE}.count >= 2{
                    data?.deSelect()
                    viewModel.setElement(element: data, categoryType: .buffet_ticket)
                    
                }
            }
            
            lbl_name.text = buffet.name
            
            
            let price = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: buffet.adult_price)
            
            lbl_price.attributedText = Utils.setAttributesForLabel(
                label: lbl_price,
                attributes: [
                    (str:price, properties:[color:ColorUtils.orange_brand_900()]),
                    (str:"/vé", properties:[color:ColorUtils.gray_600()]),
                ])
            
            
            
            if buffet.ticketChildren.count > 0{
                view_discount.isHidden = true
            }else{
                view_discount.isHidden = buffet.adult_discount_percent > 0 ? false : true
                lbl_discount.text = String(format: "%d%%", buffet.adult_discount_percent)
            }

        
        
            view_relatedQuantity_action.isHidden = buffet.isSelected == ACTIVE ? false : true
            lbl_quantity.text = String(buffet.quantity)
        }
    }
    
}

extension BuffetTicketTableViewCell{
    func registerAndBindTable(){
        registerCell()
        bindTableViewData()
    }
    
   private func registerCell() {
        let extraFoodTableViewCell = UINib(nibName: "TicketTableViewCell", bundle: .main)
        tableView.register(extraFoodTableViewCell, forCellReuseIdentifier: "TicketTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 60
        tableView.isScrollEnabled = false
    }
    
    private func bindTableViewData(){
        buffetticket.bind(to: tableView.rx.items(cellIdentifier: "TicketTableViewCell", cellType: TicketTableViewCell.self))
        { (index, element, cell) in
            cell.viewModel = self.viewModel
            cell.ticket = self.data
            cell.ticketChild = element
        }.disposed(by: disposeBag)
        
    }
}
