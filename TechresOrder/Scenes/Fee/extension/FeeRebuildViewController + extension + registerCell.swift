//
//  FeeRebuildViewController + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/01/2024.
//

import UIKit
extension FeeRebuildViewController {
    
    //MARK: Register Cells as you want
    func registerCell(){

        materialFeeTable.register(UINib(nibName: "FeeMaterialItemTableViewCell", bundle: .main), forCellReuseIdentifier: "FeeMaterialItemTableViewCell")
        materialFeeTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        materialFeeTable.rowHeight = UITableView.automaticDimension
        
        materialFeeTable.rx.modelSelected(Fee.self) .subscribe(onNext: { element in
            self.viewModel.makeToUpdateFeeMaterialViewController(materialFeeId: element.id)
        }).disposed(by: rxbag)
        

        otherFeeTable.register(UINib(nibName: "FeeMaterialItemTableViewCell", bundle: .main), forCellReuseIdentifier: "FeeMaterialItemTableViewCell")
        otherFeeTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        otherFeeTable.rowHeight = UITableView.automaticDimension
        
        
        otherFeeTable.rx.modelSelected(Fee.self) .subscribe(onNext: { element in
            self.viewModel.makeToUpdateOtherFeedViewController(fee: element)
        }).disposed(by: rxbag)

    }
    
    func bindTableSection(){
        viewModel.feeReport.map{$0.reportData.filter{$0.addition_fee_reason_type_id == 16}}.bind(to: materialFeeTable.rx.items(cellIdentifier: "FeeMaterialItemTableViewCell", cellType: FeeMaterialItemTableViewCell.self))
        {(row, fee, cell) in
            cell.data = fee
        }.disposed(by: rxbag)
        
        
        viewModel.feeReport.map{$0.reportData.filter{$0.addition_fee_reason_type_id != 16}}.bind(to: otherFeeTable.rx.items(cellIdentifier: "FeeMaterialItemTableViewCell", cellType: FeeMaterialItemTableViewCell.self))
        {(row, fee, cell) in
            cell.data = fee
        }.disposed(by: rxbag)
    }
    
}


