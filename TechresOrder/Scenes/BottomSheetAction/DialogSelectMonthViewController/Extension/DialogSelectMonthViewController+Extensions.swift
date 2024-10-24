//
//  DialogSelectMonthViewController+Extensions.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
//import SNCollectionViewLayout
extension DialogSelectMonthViewController{
    
    
    //MARK: Register Cells as you want
    func registerCell(){
        let monthSelectCollectionViewCell = UINib(nibName: "MonthSelectCollectionViewCell", bundle: .main)
        month_collectionView.register(monthSelectCollectionViewCell, forCellWithReuseIdentifier: "MonthSelectCollectionViewCell")
        month_collectionView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    func binđDataCollectionView(){
     
        viewModel.dataArray.bind(to: month_collectionView.rx.items(cellIdentifier: "MonthSelectCollectionViewCell", cellType: MonthSelectCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
    
}


extension DialogSelectMonthViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthSelectCollectionViewCell", for: indexPath as IndexPath) as! MonthSelectCollectionViewCell
        if(cell.month_lbl != nil){
            cell.month_lbl.text = String(indexPath.row + 1)
            
            if (indexPath.row + 1 == month) {
                cell.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#0071BB").withAlphaComponent(0.5)
                cell.month_lbl.textColor = ColorUtils.white()
            }
            else {
                cell.backgroundColor = ColorUtils.white()
                cell.month_lbl.textColor = ColorUtils.black()
            }
        }
        cell.month_lbl.text = String(indexPath.row + 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.containView.frame.width - 2) / 3, height: 188 / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        month = indexPath.row + 1
        month_collectionView.reloadData()
        delegate?.selected(month: month, year: year)
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
