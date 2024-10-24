//
//  FeeRebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/01/2024.
//

import UIKit
import ObjectMapper
import RxSwift
extension FeeRebuildViewController {

                
    func fees(){
        viewModel.fees().subscribe(onNext: { [self] (response) in
           if(response.code == RRHTTPStatusCode.ok.rawValue){
               if var report = Mapper<FeeData>().map(JSONObject: response.data) {
                   report.reportData = report.reportData.filter{$0.addition_fee_status == 2}
                   
                   let materialFee = report.reportData.filter{$0.addition_fee_reason_type_id == 16}
                   let otherFee = report.reportData.filter{$0.addition_fee_reason_type_id != 16}
                   let materialFeeAmount:Float = materialFee.map{$0.amount}.reduce(0.0,+)
                   let otherFeeAmount:Float = otherFee.map{$0.amount}.reduce(0.0,+)
                   
                   lbl_total_fee.text = Utils.stringQuantityFormatWithNumberFloat(amount: materialFeeAmount + otherFeeAmount)
                   lbl_material_fee_sm.text = Utils.stringQuantityFormatWithNumberFloat(amount: materialFeeAmount)
                   lbl_material_fee_lg.text = Utils.stringQuantityFormatWithNumberFloat(amount: materialFeeAmount)
                   lbl_other_fee_sm.text = Utils.stringQuantityFormatWithNumberFloat(amount: otherFeeAmount)
                   lbl_other_fee_lg.text = Utils.stringQuantityFormatWithNumberFloat(amount: otherFeeAmount)
                 
             
                   viewModel.feeReport.accept(report)
                   
                   if materialFee.count > 0{
                       height_of_material_fee_table.constant = 200
                       for i in (0...materialFee.count - 1){
                           let cell = materialFeeTable.cellForRow(at: IndexPath(row: i, section: 0))
                           height_of_material_fee_table.constant += CGFloat(cell?.frame.height ?? 0)
                           materialFeeTable.layoutIfNeeded()
                       }
                       height_of_material_fee_table.constant -= 200
                       view_no_data_of_material_fee.isHidden = true
                   }else{
                       height_of_material_fee_table.constant = 200
                       view_no_data_of_material_fee.isHidden = false
                   }
                   
              
                   
                   if otherFee.count > 0{
                       height_of_other_fee_table.constant = 200
                       for i in (0...otherFee.count - 1){
                           let cell = otherFeeTable.cellForRow(at: IndexPath(row: i, section: 0))
                           height_of_other_fee_table.constant += CGFloat(cell?.frame.height ?? 0)
                           otherFeeTable.layoutIfNeeded()
                       }
                       height_of_other_fee_table.constant -= 200
                       view_no_data_of_other_fee.isHidden = true
                   }else{
                       height_of_other_fee_table.constant = 200
                       view_no_data_of_other_fee.isHidden = false
                   }
                   
               }
           }else{
               dLog(response.message ?? "")
           }
        
       }).disposed(by: rxbag)
    }
                               
            
}
