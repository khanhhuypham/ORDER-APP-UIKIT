//
//  CreateFeedRebuildViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit
import RxSwift
class CreateFeedRebuildViewController: BaseViewController {
    var viewModel = CreateFeedRebuildViewModel()
    var router = CreateFeedRebuildRouter()
//    var picker: DateTimePicker?
    var strings = ["Ăn uống","Chi tiêu","Đi lại","Giáo dục","Mỹ phẩm","Giao lưu","Liên lạc","Quần áo","Tiền điện","Tiền nước","Tiền nhà","Y tế"]
    var viewType = 0
 
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var material_fee_view: UIView!
    @IBOutlet weak var lbl_material_fee: UILabel!
    @IBOutlet weak var btn_material_fee: UIButton!
    
    @IBOutlet weak var other_fee_view: UIView!
    @IBOutlet weak var lbl_other_fee: UILabel!
    @IBOutlet weak var btn_other_fee: UIButton!


    
    @IBOutlet weak var btnChooseDate: UIButton!
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textfield_object_name: UITextField!

    @IBOutlet weak var textfield_amount: UITextField!
  

    @IBOutlet weak var btnChooseAmount: UIButton!
    @IBOutlet weak var textview_note: UITextView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        registerCellAndBindTable()
        firstSetup()
        actionLoadMaterialFeeView("")
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    @IBAction func actionLoadMaterialFeeView(_ sender: Any) {
        self.lbl_material_fee.textColor = ColorUtils.green_600()
        self.lbl_other_fee.textColor = ColorUtils.green_200()
        material_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.green_600(), thickness: 4)
        other_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.white(), thickness: 4)
        viewType = 1
        collectionView.isHidden = true
        lbl_date.text = TimeUtils.getCurrentDateTime().dateTimeNow
        textfield_object_name.text = ""
        textfield_amount.text = ""
        textview_note.text = ""

        var fee = Fee()
        fee.addition_fee_reason_type_id = 16
        viewModel.fee.accept(fee)
       
    }
    
    @IBAction func actionLoadOtherFeeView(_ sender: Any) {
        self.lbl_material_fee.textColor = ColorUtils.green_200()
        self.lbl_other_fee.textColor = ColorUtils.green_600()
        material_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.white(), thickness: 4)
        other_fee_view.addBorder(toEdges: [.bottom], color: ColorUtils.green_600(), thickness: 4)
        viewType = 2
        collectionView.isHidden = false
        
       
        lbl_date.text = TimeUtils.getCurrentDateTime().dateTimeNow
        textfield_object_name.text = ""
        textfield_amount.text = ""
        textview_note.text = ""
        

        var fee = Fee()
        fee.addition_fee_reason_type_id = 8
        viewModel.fee.accept(fee)
    }
    
    @IBAction func actionShowCalendar(_ sender: Any) {

        var dateStr = viewModel.fee.value.date
        
        dateStr.isEmpty
        ? DatePickerUtils.shared.showDatePicker(self)
        : DatePickerUtils.shared.showDatePicker(self, date:TimeUtils.convertStringToDate(from: dateStr, format: .dd_mm_yyyy_hh_mm))
       
       
    }
    
    @IBAction func actionChooseAmount(_ sender: Any) {
        presentModalCaculatorInputMoneyViewController()
    }
    
    @IBAction func actionSave(_ sender: Any) {
        isFeeValid.take(1).subscribe(onNext: { [self] isValid in
            if isValid {
                createFee()
            }
        }).disposed(by: rxbag)

    }
    

}
