//
//  ServicePopupViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/11/2023.
//

import UIKit

class ServicePopupViewController: BaseViewController {
    
    var orderItem = OrderItem()
    var viewModel = ServicePopupViewModel()
    var completion:(() -> Void)?
    
    @IBOutlet weak var root_view: UIView!
    
    @IBOutlet weak var lbl_service_time_used: UILabel!
    @IBOutlet weak var lbl_start_date: UILabel!
    
    @IBOutlet weak var lbl_end_date: UILabel!
    
    @IBOutlet weak var text_view: UITextView!

    @IBOutlet weak var btn_confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if orderItem.status == .servic_block_using{
            orderItem.service_end_time = TimeUtils.getFullCurrentDate()
        }
        
        viewModel.orderItem.accept(orderItem)
        firstSetup(data: orderItem)
    }
    
    private func firstSetup(data:OrderItem){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        text_view.withDoneButton()
        lbl_service_time_used.text = String(format:"%d phút", data.service_time_used)

        lbl_start_date.text = formatDateString(dateString: data.service_start_time)
        lbl_end_date.text = formatDateString(dateString: data.service_end_time)
    
        text_view.text = data.note
        
        isEnableBtn(btn: btn_confirm, isEnable: false)
        
            
        _ = text_view.rx.text.map{String($0!.prefix(255))}.map{[self] note in
            text_view.text = note
        
            isEnableBtn(btn: btn_confirm, isEnable: note.count <= 255 && note.count >= 2 ? true : false)

            var item = viewModel.orderItem.value
            item.note = note
            return item
        }.bind(to: viewModel.orderItem).disposed(by: rxbag)

        
    }
    
    private func isEnableBtn(btn:UIButton,isEnable:Bool){
        btn.backgroundColor = isEnable ? ColorUtils.orange_brand_900() : ColorUtils.gray_600()
        btn.isUserInteractionEnabled = isEnable ? true : false
    }

    @IBAction func actionChooseStartDate(_ sender: Any) {
        viewModel.dateType.accept(1)
        showCalendar(dateString: viewModel.orderItem.value.service_start_time)
    }
    
    @IBAction func actionChooseEndDate(_ sender: Any) {
        viewModel.dateType.accept(2)
        showCalendar(dateString: viewModel.orderItem.value.service_end_time)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        updateService()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_view.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_view.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
}

