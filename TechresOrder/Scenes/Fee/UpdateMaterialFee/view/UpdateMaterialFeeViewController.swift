//
//  UpdateFeedViewController.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 16/06/2023.
//

import UIKit

class UpdateMaterialFeeViewController: BaseViewController {

    var viewModel = UpdateMaterialFeeViewModel()
    var router = UpdateMaterialFeeRouter()
    var picker:DateTimePicker?
    var materialFeeId = 00
    
    @IBOutlet weak var purpose: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var text_view_note: UITextView!
    
    @IBOutlet weak var btnConfirmDelete: UIButton!
    @IBOutlet weak var btnChooseAmount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // thêm nút done vào bàn phím
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.text_view_note.inputAccessoryView = toolbar
        
        text_view_note.rx.text.map{ $0 ?? ""}.bind(to: viewModel.note)
        purpose.rx.text.map{ $0 ?? ""}.bind(to: viewModel.object_name)
        
        text_view_note.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        viewModel.materialFeeId.accept(materialFeeId)
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        getMaterialFee()
        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        
        //chọn số tiền
        btnChooseAmount.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseAmount")
                              self!.presentModalCaculatorInputMoneyViewController()
                          }).disposed(by: rxbag)
        //hiển thị form ghi chú xoá
        btnConfirmDelete.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              self!.presentModalCreateNote()
                          }).disposed(by: rxbag)
    }
    
    @objc func dismissMyKeyboard() {
            view.endEditing(true)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        updateMaterialFee()
        viewModel.makePopViewController()
    }
    
    
    @IBAction func actionShowCalendar(_ sender: Any) {
        dLog(viewModel.dateTime.value)
        chooseDate(selectedDate: viewModel.dateTime.value)
    }
    
}
