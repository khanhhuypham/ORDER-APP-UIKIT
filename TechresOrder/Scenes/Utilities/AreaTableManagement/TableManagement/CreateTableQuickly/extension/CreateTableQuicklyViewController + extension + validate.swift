//
//  CreateTableQuicklyViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/01/2024.
//

import UIKit
import RxSwift
import RxRelay

extension CreateTableQuicklyViewController {
    
    func mapDataAndValidate(){
        mapData()
        isValid()
        setupMenu(list: viewModel.areaList.value)
    }
    
    private func mapData(){
        _ = textfield_name.rx.text.map{(str) in
            let name = Utils.blockSpecialCharacters(str ?? "")
          
            if name.count > 4{
                self.showWarningMessage(content: "Tên khu vực tối đa 4 ký tự")
            }
            
            return String(name.prefix(4))
        }.map{[self] name in
            var parameter = viewModel.parameter.value
            parameter.name = name
            textfield_name.text = parameter.name
            return parameter
        }.bind(to: viewModel.parameter).disposed(by: rxbag)
        
        _ = textfield_number_to.rx.text.map{[self] str in
   
            var parameter = viewModel.parameter.value
            
            parameter.numberTo = Int(str ?? "0") ?? 0
            
            if parameter.numberTo >= 999{
                parameter.numberTo = 999
                textfield_number_to.text = "999"
            }

            return parameter
        }.bind(to: viewModel.parameter).disposed(by: rxbag)
        
        
        _ = textfield_number_from.rx.text.map{[self] str in
            
            var parameter = viewModel.parameter.value
            
            parameter.numberFrom = Int(str ?? "0") ?? 0
            
            if parameter.numberFrom >= 999{
                parameter.numberFrom = 999
                textfield_number_from.text = "999"
            }
                    
            return parameter
        }.bind(to: viewModel.parameter).disposed(by: rxbag)
        
        _ = textfield_slot.rx.text.map{[self] str in
            
            var parameter = viewModel.parameter.value
            
            parameter.slot = Int(str ?? "0") ?? 0
            
            if parameter.slot >= 999{
                parameter.slot = 999
                textfield_slot.text = "999"
            }
        
            return parameter
        }.bind(to: viewModel.parameter).disposed(by: rxbag)
        
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    
    private func isValid(){
        _ = Observable.combineLatest(isNameValid, isNumberFromValid, isNumberToValid,isSlotValid){$0 && $1 && $2 && $3}.subscribe(onNext: {(valid) in
            dLog(valid)
            self.btnAdd.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btnAdd.isEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
  
    

    private var isNameValid: Observable<Bool> {
        return viewModel.parameter.map{$0.name}.asObservable().map { name in
//            dLog(name.count > 0 && name.count <= 4)
            return name.count > 0 && name.count <= 4
        }
    }
    
    private var isNumberFromValid: Observable<Bool> {
        return viewModel.parameter.map{$0.numberFrom}.asObservable().map {number in
           
            return (number > 0 && number <= 999) && number < self.viewModel.parameter.value.numberTo
        }
    }
    
    private var isNumberToValid: Observable<Bool> {
        return viewModel.parameter.map{$0.numberTo}.asObservable().map { number in
//            dLog((number > 0 && number <= 999) && number > self.viewModel.numberFrom.value)
            return (number > 0 && number <= 999) && number > self.viewModel.parameter.value.numberFrom
        }
    }
    
    private var isSlotValid: Observable<Bool> {
        return viewModel.parameter.map{$0.slot}.asObservable().map {slot in
//            dLog(slot > 0 && slot <= 999)
            return slot > 0 && slot <= 999
        }
    }
    
   

        
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_slot.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_slot.isFirstResponder{
            root_view.transform = .identity
        }
        
        let p = self.viewModel.parameter.value

        if textfield_number_to.isFirstResponder && p.numberTo < p.numberFrom{
            self.showWarningMessage(content: "Số kết thúc phải lớn hơn số bắt đầu")
        }
    }
    
    @objc private func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
            actionCancel("")
        }
    }

    
}



//extension CreateTableQuicklyViewController: ArrayChooseUnitViewControllerDelegate{
//    func showList(btn:UIButton,list:[String]){
//        let controller = ArrayChooseUnitViewController(Direction.allValues)
//        controller.listString = list
//        controller.delegate = self
//        controller.preferredContentSize = CGSize(width: btn.frame.width, height: 200)
//        showPopup(controller, sourceView: btn)
//    }
//    
//    
//    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
//        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
//        presentationController.sourceView = sourceView
//        presentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
//        presentationController.sourceRect = CGRectMake(sourceView.bounds.origin.x, sourceView.bounds.origin.y + 135, sourceView.bounds.width, sourceView.bounds.height)
//        self.present(controller, animated: true)
//    }
//    
//    func selectUnitAt(pos: Int) {
//        viewModel.area_id.accept(areaArray[pos].id)
//        btn_show_area.setAttributedTitle(Utils.setAttributesForBtn(content: areaArray[pos].name, attributes: btnAttr), for: .normal)
//    }
//}

