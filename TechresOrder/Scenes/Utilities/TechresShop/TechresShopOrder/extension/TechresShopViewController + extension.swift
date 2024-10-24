//
//  TechresShopViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/09/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import SNCollectionViewLayout


extension TechresShopOrderViewController {
    func getTechresShopDeviceList() {
        appServiceProvider.rx.request(.getTechresShopDeviceList)
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
           
           
            
            if (response.code == RRHTTPStatusCode.ok.rawValue) {
                if let res = Mapper<TechresDeviceResponse>().map(JSONObject: response.data) {
            
                    viewModel.deviceArray.accept(res.list)
                    
                    
                    view_no_data.isHidden = res.list.isEmpty ? false : true
                }
                
               
            } else if (response.code == RRHTTPStatusCode.badRequest.rawValue) {
           
               
            } else {
               
              
            }
            
        
        }).disposed(by: rxbag)
        
    }
}





//MARK: This Part of extension is to register cell for areacollectionView and bind data and implement some method of protocol
extension TechresShopOrderViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func registerAndBindData(){
        registerCell()
        binđDataAreaCollectionView()
    }
    
    
    private func registerCell(){
        let cell = UINib(nibName: "TechresShopOrderCollectionViewCell", bundle: .main)
        collectionView.register(cell, forCellWithReuseIdentifier: "TechresShopOrderCollectionViewCell")
 
        let snCollectionViewLayout = SNCollectionViewLayout()
        snCollectionViewLayout.fixedDivisionCount = 2 // Columns for .vertical, rows for .horizontal
        collectionView.collectionViewLayout = snCollectionViewLayout
        collectionView.delegate = self
        collectionView.collectionViewLayout = flowLayout
       

    }
    
    
    private func binđDataAreaCollectionView(){
        viewModel.deviceArray.bind(to: collectionView.rx.items(cellIdentifier: "TechresShopOrderCollectionViewCell", cellType: TechresShopOrderCollectionViewCell.self)) { (index, data, cell) in
            cell.viewModel = self.viewModel
            cell.data = data
            let totalAmount = self.viewModel.deviceArray.value.map{value in Float(value.price * value.quantity)}.reduce(0.0,+)
            self.lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: totalAmount)
            self.lbl_total_quantity.text = String(format: "Giỏ hàng: %d món", self.viewModel.deviceArray.value.filter{$0.quantity > 0}.count)
         }.disposed(by: rxbag)
                
    }
             
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnNumber:CGFloat = 2
        let width = collectionView.bounds.width
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (columnNumber + 1)
        let itemDimension = floor(availableWidth / columnNumber)
        
        return CGSize(width: itemDimension, height: 200)
    }



}
