//
//  BankAccountCreateViewController + extension + setup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/04/2024.
//

import UIKit
import JonAlert
import ObjectMapper
import RxSwift
extension BankAccountCreateViewController {
    
  
    func mapDataAndValidate(){
        mappData()
        isDiscountValid()
        lbl_title.text = "Tạo tài khoản"
        if let account = bankAccount{
            viewModel.bankAccount.accept(account)
            lbl_bank.text = account.bank_name
            textfield_account_number.text = account.bank_number
            textfield_account_holder.text = account.bank_account_name
            lbl_title.text = "Cập nhật tài khoản"
        }
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    
    }

    private func mappData(){
        _ = textfield_account_number.rx.text.map{str in
            let text = str ?? ""
            if text.count > 15{
                self.showWarningMessage(content: "Số tài khoản có độ dài từ 8-15 ký tự")
            }
            return String(text.prefix(15))
            
        }.map{[self] str in
            
            var bankAccount = viewModel.bankAccount.value
            bankAccount.bank_number = str
            
            textfield_account_number.text = bankAccount.bank_number
            return bankAccount
        }.bind(to: viewModel.bankAccount).disposed(by: rxbag)
        
        _ = textfield_account_holder.rx.text.map{str in
         
            let text = Utils.blockSpecialCharacters(str ?? "")
            if text.count > 50{
                self.showWarningMessage(content: "Tên tài khoản có độ dài từ 5-50 ký tự")
            }
            return String(text.prefix(50))
            
        }.map{[self] str in
            var bankAccount = viewModel.bankAccount.value
            bankAccount.bank_account_name = str
            textfield_account_holder.text =  bankAccount.bank_account_name
            return bankAccount
        }.bind(to: viewModel.bankAccount).disposed(by: rxbag)
        
    }
        
    private func isDiscountValid(){
       _ = Observable.combineLatest(isAccountNumberValid,isAccountHolderValid){$0 && $1}.subscribe(onNext: {(valid) in
            self.btn_create.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btn_create.isEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
    private var isAccountNumberValid: Observable<Bool>{
        return viewModel.bankAccount.map{$0.bank_number}.asObservable().map(){[self](accountNumber) in
            return accountNumber.count >= 8 && accountNumber.count <= 15
        }
    }
    
    private var isAccountHolderValid: Observable<Bool>{
        return viewModel.bankAccount.map{$0.bank_account_name}.asObservable().map(){[self](name) in
            return name.count >= 5 && name.count <= 50
        }
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_account_holder.isFirstResponder || textfield_account_number.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_account_holder.isFirstResponder || textfield_account_number.isFirstResponder{
            root_view.transform = .identity
        }
    }

}

extension BankAccountCreateViewController: ArrayChooseUnitViewControllerDelegate{
    func showList(btn:UIButton,list:[String]){
        let controller = ArrayChooseUnitViewController(Direction.allValues)
        controller.listString = list
        controller.delegate = self
        controller.preferredContentSize = CGSize(width: btn.frame.width, height: 300)
        showPopup(controller, sourceView: btn)
    }
    
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        presentationController.sourceRect = CGRectMake(sourceView.bounds.origin.x, sourceView.bounds.origin.y + 180, sourceView.bounds.width, sourceView.bounds.height)
        self.present(controller, animated: true)
    }
    
    func selectUnitAt(pos: Int) {
        var bankAccount = viewModel.bankAccount.value
        bankAccount.bank_identify_id = viewModel.bankList.value[pos].bin
        bankAccount.bank_name = viewModel.bankList.value[pos].name
        viewModel.bankAccount.accept(bankAccount)
        
        lbl_bank.text = bankAccount.bank_name
    }
}






//extension BankAccountCreateViewController{
//    
//    private func handleSelection(element:Bank,menu:UIMenu) -> UIMenu{
//      
////        btn_dropDown.setAttributedTitle(Utils.setAttributesForBtn(content: element.name, attributes: btnAttr),for: .normal)
//        
////        var list = viewModel.areaList.value
////        
////        list.enumerated().forEach{(i, area) in
////            list[i].is_select = area.id == element.id ? ACTIVE : DEACTIVE
////        }
////        viewModel.areaList.accept(list)
//        
//
//        menu.children.enumerated().forEach{(i, action) in
//            guard let action = action as? UIAction else {
//                return
//            }
//            action.state = action.title == element.name ? .on : .off
//        }
//        return menu
//    }
//    
//    func setupMenu(list:[Bank]){
//        
//        var options:[UIAction] = []
//    
//        for element in list {
//
//            options.append(
//                UIAction(title: element.name, image: nil, identifier: nil, handler: { _ in
//                    self.btn_dropDown.menu = self.handleSelection(element: element, menu:self.btn_dropDown.menu!)
//                })
//            )
//        }
//
//        btn_dropDown.menu = UIMenu(options: .displayInline, children: options)
//        
//        if list.count > 0{
//            self.btn_dropDown.menu =  handleSelection(element: list[0], menu:self.btn_dropDown.menu!)
//            
////            for element in list.filter{$0.is_select == ACTIVE} {
////                self.btn_dropDown.menu = handleSelection(element: element, menu:self.btn_dropDown.menu!)
////            }
//        }
//        
//        btn_dropDown.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
//        
//        btn_dropDown.showsMenuAsPrimaryAction = true
//        btn_dropDown.changesSelectionAsPrimaryAction = true
//    
//    }
//}
//

//extension BankAccountCreateViewController: UIContextMenuInteractionDelegate {
//
//    /*
//
//     When we create our menu, we'll use the exact same items
//     as the basic menu, but group "rename" and "delete" into
//     a submenu titled "Edit..."
//
//     */
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
//
//            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share1 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share2 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share3 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share4 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share5 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share6 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share7 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share8 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share9 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share10 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share11 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share12 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share13 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share14 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share15 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share16 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share17 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share18 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share19 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let share20 = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in }
//            let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in }
//
//            let deleteCancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
//            let deleteConfirmation = UIAction(title: "Delete", image: UIImage(systemName: "checkmark"), attributes: .destructive) { action in }
//
//            // The delete sub-menu is created like the top-level menu, but we also specify an image and options
//            let delete = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [deleteCancel, deleteConfirmation])
//
//            // The edit menu adds delete as a child, just like an action...
//            let edit = UIMenu(title: "Edit...", children: [rename, delete])
//
//            // ...then we add edit as a child of the main menu.
////            return UIMenu(title: "", children: [share,share1,share2,share3,share4,share5,share6,share7,share8,share9,share10,share11,share12,share13,share14,share15,share16,share17,share18,share19,edit])
//            
//            return UIMenu(title: "", children: [share,edit])
//        }
//    }
//}



