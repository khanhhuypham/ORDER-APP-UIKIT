//
//  PopupEnterPercentForBuffetViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/05/2024.
//

import UIKit
import RxSwift
import RxRelay
class PopupEnterPercentForBuffetViewController: BaseViewController {
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_header: UILabel!
    
    
    @IBOutlet weak var view_of_adult_ticket: UIStackView!
    @IBOutlet weak var lbl_adultTicket_title: UILabel!
    @IBOutlet weak var textfield_adult_percent: UITextField!
    
    
    @IBOutlet weak var view_of_chilred_ticket: UIView!
    @IBOutlet weak var textfield_children_percent: UITextField!
    @IBOutlet weak var btn_confirm: UIButton!
    
    
    var header = "GIẢM GIÁ MÓN"

    
    var item:Buffet? = nil
    var delegate:EnterPercentForBuffetDelegate? = nil
    var buffet = BehaviorRelay<Buffet>(value: Buffet())


    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetup()
    }
    
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    

    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {

        var buffet = self.buffet.value
        
        for (i,value) in buffet.ticketChildren.enumerated(){
            buffet.ticketChildren[i].discountPercent = value.ticketType == .adult
            ? buffet.adult_discount_percent
            : buffet.child_discount_percent
        }

        
        buffet.setDiscount(
            adultDiscountPercent: buffet.adult_discount_percent,
            childDiscountPercent: buffet.child_discount_percent
        )
        
        dismiss(animated: true,completion: {
            self.delegate?.callbackToGetBuffet(buffet:buffet)
        })
        
    }
    
    
    
    func firstSetup(){
        var buffet = buffet.value
        
        lbl_header.text = header
        textfield_adult_percent.setMaxValue(maxValue: 100)
        textfield_children_percent.setMaxValue(maxValue: 100)

        if buffet.ticketChildren.count > 0{
         
            if let adultTicket = buffet.ticketChildren.filter{$0.ticketType == .adult}.first,adultTicket.discountPercent != 0{
                textfield_adult_percent.text = String(adultTicket.discountPercent)
            }
            
            if let childrenTicket = buffet.ticketChildren.filter{$0.ticketType == .children}.first,childrenTicket.discountPercent != 0 {
                textfield_children_percent.text = String(childrenTicket.discountPercent)
            }
            
    
        }else{
            lbl_adultTicket_title.isHidden = true
            view_of_chilred_ticket.isHidden = true
            if buffet.discount != 0{
                textfield_adult_percent.text = String(buffet.discount)
            }
            
        }
        

        
    
        _ = textfield_adult_percent.rx.text.map{[self] str in
            var buffet = self.buffet.value
            buffet.adult_discount_percent = Int(str ?? "0") ?? 0
            if buffet.adult_discount_percent > 100{
                showWarningMessage(content: "Phần trăm giảm giá không được quá 100%")
                buffet.adult_discount_percent = 100
            }
            return buffet
        }.bind(to: self.buffet).disposed(by: rxbag)
        
        _ = textfield_children_percent.rx.text.map{[self] str in
            var buffet = self.buffet.value
            buffet.child_discount_percent = Int(str ?? "0") ?? 0
            if buffet.child_discount_percent > 100{
                showWarningMessage(content: "Phần trăm giảm giá không được quá 100%")
                buffet.child_discount_percent = 100
            }
            return buffet
        }.bind(to: self.buffet).disposed(by: rxbag)
        
        

        _ = isValid.subscribe(onNext:{valid in
        
            self.btn_confirm.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btn_confirm.isUserInteractionEnabled = valid ? true : false
            
        }).disposed(by: rxbag)

        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private var isValid:Observable<Bool>{
        return Observable.combineLatest(isAdultPercentValid,isChildrenPercentValid){$0 || $1}
    }
    
    private var isAdultPercentValid:Observable<Bool>{
        buffet.map(){buffet in
            return buffet.adult_discount_percent > 0 && buffet.adult_discount_percent <= 100
        }
    }
    
    private var isChildrenPercentValid:Observable<Bool>{
        buffet.map(){buffet in
            
            return buffet.child_discount_percent > 0 && buffet.child_discount_percent <= 100
        }
    }
        
}
