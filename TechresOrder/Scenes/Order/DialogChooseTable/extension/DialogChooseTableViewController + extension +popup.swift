//
//  DialogChooseTableViewController + extension +popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/01/2024.
//

import UIKit

extension DialogChooseTableViewController:MoveTableDelegate {
    func callBackComfirmMoveTable(destination_table:Table,target_table:Table) {
        switch option {
            case .moveTable:
                moveTable(target_table_id: target_table.id)
                break
                
            case .splitFood:
                dismiss(animated: true,completion: { [self] in
                    moveTableDelegate?.callBackToSplitItem(destination_order:order,target_order: Order(table: target_table),only_one: isSplittingSingleItem,isTargetActive: target_table.status)
                })
                break
            
            default:
                return
        }
    }
    
    func presentModalConfirmMoveTableViewController(destinationTable:Table,targetTable:Table) {
        let vc = ConfirmMoveTableViewController()
        vc.destination_table = destinationTable
        vc.target_table = targetTable
        vc.option = self.option
        vc.delegate = self
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}
