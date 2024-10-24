//
//  Utilities_rebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/11/2023.


import UIKit
import ObjectMapper
extension UtilitiesViewController {

    func presentModalChooseBrand() {
        let vc = BrandViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .formSheet
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                // 3
                sheet.detents = [.medium()]
                
            }

        }
        present(vc, animated: true, completion: nil)
    }
    
    
    func presentModalChooseBranch() {
        let vc = BranchViewController()
        vc.delegate = self
        vc.brand_id = ManageCacheObject.getCurrentBrand().id
        vc.modalPresentationStyle = .pageSheet
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                // 3
                sheet.detents = [.medium()]
            }
        } else {
            // Fallback on earlier versions
        }

        present(vc, animated: true, completion: nil)
    }
    
    func presentDialogFoodCourtViewController() {
        let vc = DialogFoodCourtViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        vc.completion = self.logout
        present(vc, animated: true, completion: nil)
    }
    
}
extension UtilitiesViewController:BrandDelegate, BranchDelegate {
    func callBackChooseBrand(brand: Brand) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.presentModalChooseBranch()
        }
    }
    
    func callBackChooseBranch(branch: Branch) {

        SettingUtils.getBranchSetting(
            branchId: branch.id,
            completion: {
                self.mapData()
            },
            incompletion: {
                self.presentDialogFoodCourtViewController()
            }
        )
    }
}
