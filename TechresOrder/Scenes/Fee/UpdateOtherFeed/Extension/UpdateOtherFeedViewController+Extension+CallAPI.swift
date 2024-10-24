//
//  UpdateOtherFeedViewController+Extension+CallAPI.swift
//  ORDER
//
//  Created by Macbook Pro M1 Techres - BE65F182D41C on 17/06/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import SNCollectionViewLayout
import JonAlert
extension UpdateOtherFeedViewController: MaterialDelegate{
    func presentModalCreateNote() {
            let createNoteViewController = CreateNoteMaterialViewController()
            createNoteViewController.delegate = self
            createNoteViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: createNoteViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {

                    // 3
                    sheet.detents = [.medium()]

                }
            } else {
                // Fallback on earlier versions
            }
            // 4
//            brandViewController.delegate = self
            present(nav, animated: true, completion: nil)

        }
    func callBackNoteDelete(note: String) {
        viewModel.cancel_reason.accept(note)
        viewModel.addition_fee_status.accept(3)
        self.cancelOtherFee()
        dismiss(animated: true)
        viewModel.makePopViewController()
    }
}
extension UpdateOtherFeedViewController{
    func getUpdateOtherFeed(){
        viewModel.getUpdateOtherFeed().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let otherFee = Mapper<Fee>().map(JSONObject: response.data) {
                        
                    self.textfield_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: otherFee.amount)
                    self.textview_note.text = otherFee.note
                    let otherFeeDate: String = otherFee.date
                    let otherFeeDateNotHour = otherFeeDate.components(separatedBy: " ")
                    self.textfield_date.text = otherFeeDateNotHour[0] //Chỉ lấy ra dd/MM/yyy
                    self.textfield_reason.text = otherFee.object_name
                    
                    self.viewModel.object_name.accept(otherFee.object_name)
                    self.viewModel.amount.accept(Int(otherFee.amount))
                    self.viewModel.note.accept(otherFee.note)
                    self.viewModel.dateText.accept(otherFee.date)
                    self.viewModel.addition_fee_reason_type_id.accept(otherFee.addition_fee_reason_type_id)
                    self.viewModel.is_count_to_revenue.accept(otherFee.is_count_to_revenue)
                    dLog(otherFee.is_count_to_revenue)
                    dLog(otherFee.amount)
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    func cancelOtherFee(){
        viewModel.cancelOtherFee().subscribe(onNext: {[self] (response) in

            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Xoá thành công!")
            }else{
                JonAlert.showError(message:response.message ?? "Lỗi kết nối server")
            }
            
        })
    }
    func updateOtherFee(){
        viewModel.updateOtherlFee().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Cập nhật thành công!")
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
    func presentModalCaculatorInputMoneyViewController() {
        let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
        caculatorInputMoneyViewController.checkMoneyFee = 1000
        caculatorInputMoneyViewController.limitMoneyFee = 1000000000
        caculatorInputMoneyViewController.result = Int(self.viewModel.amount.value)
            caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
            caculatorInputMoneyViewController.delegate = self
    //        newFeedBottomSheetActionViewController.newFeed = newFeed
    //        newFeedBottomSheetActionViewController.index = position
            present(nav, animated: true, completion: nil)

        }
      
    func chooseDate(){
                let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
                let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
                let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        //        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
                picker.highlightColor = UIColor(red: 255.0/255.0, green: 162.0/255.0, blue: 51.0/255.0, alpha: 1)
                picker.darkColor = UIColor.darkGray
                picker.doneButtonTitle = "CHỌN"
                picker.doneBackgroundColor = UIColor(red: 0.0/255.0, green: 114.0/255.0, blue: 188.0/255.0, alpha: 1)
                picker.locale = Locale(identifier: "vi")
                
                picker.todayButtonTitle = "Hôm nay"
                picker.is12HourFormat = true
//                picker.dateFormat = "dd/MM/YYYY hh:mm"
                picker.dateFormat = "dd/MM/YYYY" //không hiển thị giờ
                picker.isTimePickerOnly = false
                picker.isDatePickerOnly = false
                picker.includeMonth = false // if true the month shows at top
                picker.completionHandler = { date in
                    let formatter = DateFormatter()
//                    formatter.dateFormat = "dd/MM/YYYY hh:mm"
                    formatter.dateFormat = "dd/MM/YYYY" //không hiển thị giờ
                    self.title = formatter.string(from: date)
                }
                picker.delegate = self
                self.picker = picker
    }
    
}

extension UpdateOtherFeedViewController: CalculatorMoneyDelegate, DateTimePickerDelegate{
    func callBackCalculatorMoney(amount: Int, position: Int) {
        self.textfield_amount.text = Utils.stringVietnameseMoneyFormatWithNumberDouble(amount: Double(amount))
        self.viewModel.amount.accept(Int(amount))
        
    }
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        dLog(picker.selectedDateString)
        textfield_date.text = picker.selectedDateString
        viewModel.dateText.accept(picker.selectedDateString)
        
    }
}
extension UpdateOtherFeedViewController{
    
    func registerCollectionViewCell() {
        let UpdateOtherFeedCollectionViewCell = UINib(nibName: "UpdateOtherFeedCollectionViewCell", bundle: .main)
        collectionView.register(UpdateOtherFeedCollectionViewCell, forCellWithReuseIdentifier: "UpdateOtherFeedCollectionViewCell")
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        collectionView.collectionViewLayout = snCollectionViewLayout

        //MỚI
        collectionView.rx.modelSelected(Fee.self).subscribe(onNext: { element in
            print("Selected \(element)")
            self.viewModel.object_name.accept(element.object_name)
            
            var fees = self.viewModel.other_fees.value
            fees.enumerated().forEach { (index, value) in
                fees[index].isSelect = DEACTIVE
                dLog(fees[index].isSelect)
            }
            fees.enumerated().forEach { (index, value) in
                if(element.id == value.id){
                    fees[index].isSelect = ACTIVE
                    self.selectedFeeTypeIndex = index
                    dLog(fees[index].object_name)
                }else{
                    fees[index].isSelect = DEACTIVE
                }
                
            }
            self.viewModel.other_fees.accept(fees)
        }).disposed(by: rxbag)
      
//        collectionView.rx.modelSelected(Fee.self) .subscribe(onNext: { element in
//            print("Selected \(element)")
//            self.viewModel.titleText.accept(element.object_name)
//
//            var fees = self.viewModel.other_fees.value
//            fees.enumerated().forEach { (index, value) in
//                if(element.id == value.id){
//                    fees[index].isSelect = fees[index].isSelect == ACTIVE ? DEACTIVE : ACTIVE
//                    self.selectedFeeTypeIndex = index
//                }else{
//                    fees[index].isSelect = DEACTIVE
//                }
//            }
//            self.viewModel.other_fees.accept(fees)
//        })
//        .disposed(by: rxbag)
    }
                                                             
    public func bindDataCollectionView(){

        viewModel.other_fees.bind(to: collectionView.rx.items(cellIdentifier: "UpdateOtherFeedCollectionViewCell", cellType: UpdateOtherFeedCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
            if self.otherFees[index].object_name.trimmingCharacters(in: .whitespacesAndNewlines) == self.viewModel.object_name.value.trimmingCharacters(in: .whitespacesAndNewlines) {
                cell.data?.isSelect = ACTIVE
            }
           
         }.disposed(by: rxbag)
    }
}

extension UpdateOtherFeedViewController:SNCollectionViewLayoutDelegate{
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
           if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 10 || indexPath.row == 70 {
               return 2
           }
           return 1
       }
}
