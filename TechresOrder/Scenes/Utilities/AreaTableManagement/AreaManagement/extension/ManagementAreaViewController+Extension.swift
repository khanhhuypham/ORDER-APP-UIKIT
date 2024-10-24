//
//  ManagementAreaViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 23/01/2023.
//

import UIKit
import SNCollectionViewLayout
import ObjectMapper
import MSPeekCollectionViewDelegateImplementation

extension AreaManagementViewController {
    func getAreas(){
        viewModel.getAreas().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let areas  = Mapper<Area>().mapArray(JSONObject: response.data){
                    self.viewModel.area_array.accept(areas)
                }
            }
        }).disposed(by: rxbag)
        
    }
}
    
extension AreaManagementViewController{
  
    
    //MARK: Register Cells as you want
    func registerAreaCell(){
        let collectionCell = UINib(nibName: "AreaManagementCollectionViewCell", bundle: .main)
        areaCollectionView.register(collectionCell, forCellWithReuseIdentifier: "AreaManagementCollectionViewCell")

        let layout = SNCollectionViewLayout()
        layout.fixedDivisionCount = 2 // Columns for .vertical, rows for .horizontal
        layout.itemSpacing = 30
        areaCollectionView.collectionViewLayout = layout
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: CGFloat(-30), cellPeekWidth: CGFloat(17), maximumItemsToScroll: Int(1), numberOfItemsToShow: Int(2), scrollDirection: .horizontal)
        
                
        areaCollectionView.rx.modelSelected(Area.self) .subscribe(onNext: { element in

            self.presentModalCreateAreaViewController(area: element)
            
        }).disposed(by: rxbag)
        
    }
    


    func binđDataCollectionView(){
        viewModel.area_array.bind(to: areaCollectionView.rx.items(cellIdentifier: "AreaManagementCollectionViewCell", cellType: AreaManagementCollectionViewCell.self)) { (index, element, cell) in
            cell.data = element
         }.disposed(by: rxbag)
    }
}


extension AreaManagementViewController{
    func presentModalCreateAreaViewController(area:Area = Area()!) {
        let vc = CreateAreaViewController()
        vc.area = area
        vc.completeHandler = getAreas
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: vc)
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

        present(nav, animated: true, completion: nil)
    }
    

      
}
