//
//  CreateFeeRebuilViewController + extension +registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 02/02/2024.
//

import UIKit
import SNCollectionViewLayout


extension CreateFeedRebuildViewController{
    
    func registerCellAndBindTable(){
        registerCollectionViewCell()
        binđDataCollectionView()
    }
    
    private func registerCollectionViewCell() {
        let otherFeeCollectionViewCell = UINib(nibName: "OtherFeeCollectionViewCell", bundle: .main)
        collectionView.register(otherFeeCollectionViewCell, forCellWithReuseIdentifier: "OtherFeeCollectionViewCell")
        
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 4 // Columns for .vertical, rows for .horizontal
        collectionView.collectionViewLayout = snCollectionViewLayout

        collectionView.rx.modelSelected(Fee.self) .subscribe(onNext: { [self] element in

            
            var fees = self.viewModel.array.value
            
            for i in (0..<fees.count){
                if fees[i].id == element.id{
                    fees[i].isSelect = fees[i].isSelect == ACTIVE ? DEACTIVE : ACTIVE
                    textfield_object_name.text = fees[i].object_name
                    
                    
                    var fee = viewModel.fee.value
                    fee.object_name = fees[i].object_name
                    viewModel.fee.accept(fee)
                }else{
                    fees[i].isSelect = DEACTIVE
                }
            }
            
            
           
            self.viewModel.array.accept(fees)
            
        }).disposed(by: rxbag)

    }
    
    private func binđDataCollectionView(){
        viewModel.array.bind(to: collectionView.rx.items(cellIdentifier: "OtherFeeCollectionViewCell", cellType: OtherFeeCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
}
extension CreateFeedRebuildViewController:SNCollectionViewLayoutDelegate{
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 10 || indexPath.row == 70 {
           return 2
        }
        return 1
    }
}
