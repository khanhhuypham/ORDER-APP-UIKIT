//
//  UpdateOtherFeedViewController.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 17/06/2023.
//

import UIKit
import JonAlert
class UpdateOtherFeedViewController: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var textfield_amount: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textfield_date: UILabel!
    @IBOutlet weak var textfield_reason: UITextField!
    @IBOutlet weak var btnChooseAmount: UIButton!
    @IBOutlet weak var btnChooseDate: UIButton!
    @IBOutlet weak var textview_note: UITextView!
    
    @IBOutlet weak var btnConfirmDelete: UIButton!
    var router = UpdateOtherFeedRouter()
    var viewModel = UpdateOtherFeedViewModel()
    var selectedFeeTypeIndex = 0
    var picker: DateTimePicker?
    var fee_id:Int = 0
    var fee:Fee = Fee()
    
    
     var strings = ["Ăn uống",
                     "Chi tiêu",
                     "Đi lại",
                     "Giáo dục",
                     "Mỹ phẩm",
                     "Giao lưu",
                     "Liên lạc",
                     "Quần áo",
                     "Tiền điện",
                     "Tiền nước",
                     "Tiền nhà",
                     "Y tế"]
     var imgs = ["icon_an_uong",
                 "icon_chi_tieu_hang_ngay",
                 "icon_di_lai",
                 "icon_giao_duc",
                 "icon_my_pham",
                 "icon_phi_giao_luu",
                 "icon_phi_lien_lac",
                 "icon_quan_ao",
                 "icon_tien_dien",
                 "icon_tien_nuoc",
                 "icon_tien_nha",
                 "icon_y_te"]
     var otherFees = [Fee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // thêm nút done vào bàn phím
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        self.textview_note.inputAccessoryView = toolbar

        _ = textfield_reason.rx.text.map {$0 ?? ""}.bind(to: viewModel.object_name)
        _ = textview_note.rx.text.map {$0 ?? ""}.bind(to: viewModel.note)
        
        
        for var i in 0..<strings.count {
            var fee = Fee.init()
            fee.id = i
            fee.object_name = strings[i]
            fee.icon = imgs[i]
            otherFees.append(fee)
        }

        viewModel.branch_id.accept(ManageCacheObject.getCurrentBranch().id)
        viewModel.id.accept(fee.id)
        viewModel.object_name.accept(fee.object_name)
        viewModel.dateText.accept(fee.date)
        getUpdateOtherFeed()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        registerCollectionViewCell()
        bindDataCollectionView()
        
        //gán text đã chọn từ ô gợi ý vào ô input
        viewModel.object_name.subscribe( // Thực hiện subscribe Observable
          onNext: { [weak self] titleText in
              self?.textfield_reason.text = titleText
          }).disposed(by: rxbag)
        
        //chọn ngày
        btnChooseDate.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseDate")
                              self?.chooseDate()
                          }).disposed(by: rxbag)
        //chọn số tiền
        btnChooseAmount.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              dLog("btnChooseAmount")
                              self!.presentModalCaculatorInputMoneyViewController()
                          }).disposed(by: rxbag)
        //hiển thị form ghi chú xoá chi phí khác
        btnConfirmDelete.rx.tap.asDriver()
                          .drive(onNext: { [weak self] in
                              self!.presentModalCreateNote()
                          }).disposed(by: rxbag)
            
    }
    
    private func hideView(view:UIView){
        view.isHidden = true
        view.frame =  CGRect(x: 0, y: 0, width:  view.frame.width, height: 0)
    }

            
    @objc func dismissMyKeyboard() {
            view.endEditing(true)
        }


    override func viewWillAppear(_ animated: Bool) {
        viewModel.other_fees.accept(otherFees)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.updateOtherFee()
        viewModel.makePopViewController()


    }
    func isValidOtherFee(fees: [Fee], textField: UITextField) -> Bool{
        for fee in fees {
            if fee.object_name == textField.text {
                return true
            }
        }
        return false
    }
    
}
