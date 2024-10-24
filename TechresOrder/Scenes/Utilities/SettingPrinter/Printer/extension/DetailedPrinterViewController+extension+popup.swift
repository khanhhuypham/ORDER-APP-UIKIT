//
//  DetailedPrinterViewController+extension+popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/11/2023.
//

import UIKit

extension DetailedPrinterViewController:BLEInvestigatorViewControllerDelegate {
    
//    func presentDialogBLEInvestigator(){
//        let vc = BLEInvestigatorViewController()
//        vc.printerManager = bluetoothManager
//        vc.printer = viewModel.printer.value
//        vc.delegate = self
//        vc.view.backgroundColor = ColorUtils.blackTransparent()
//        vc.modalPresentationStyle = .automatic
//        present(vc, animated: true, completion: nil)
//    }
//    
    
    func presentDialogBLEInvestigator(){
        let vc = BLEInvestigatorViewController()
        vc.printer = viewModel.printer.value
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    func getSelectedBLEDevice(device: CBPeripheral){
        var printer = viewModel.printer.value
        printer.descript = device.identifier.uuidString
        printer.printer_name = device.name ?? ""
        textfield_of_BLE_device_name.text = printer.printer_name
        viewModel.printer.accept(printer)
       
        switch device.state{
            case .connected:
                printerSwitch.isOn = true
            default:
                printerSwitch.isOn = false
                break
        }
    }
    
    
    
    func presentPrintingQueueViewController(){
        let vc = PrintingQueueViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }

}
