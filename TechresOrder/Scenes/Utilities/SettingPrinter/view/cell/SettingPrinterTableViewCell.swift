//
//  SettingPrinter_ReBuildTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/09/2023.
//

import UIKit

class SettingPrinterTableViewCell: UITableViewCell {

    @IBOutlet weak var printer_name: UILabel!
    
    @IBOutlet weak var printer_ip: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    @IBAction func actionNavigateToDetailedPrinterViewController(_ sender: Any) {
        guard let viewModel = self.viewModel, let printer = self.data else {
            return
        }
        
        viewModel.makeDetailedPrinterViewController(printer: printer)
        
    }
    
    var viewModel:SettingPrinterViewModel?
    
    var data:Printer?{
        didSet{
            mapData(data: data ?? Printer())
        }
    }
    
    private func mapData(data:Printer){
        printer_name.text = data.name
        
        switch data.connection_type{
            case .wifi:
                if data.printer_ip_address.isEmpty || data.printer_port.isEmpty{
                    printer_ip.text = "Chưa thiết lập"
                }else {
                    printer_ip.text = String(format: "%@:%@", data.printer_ip_address ,data.printer_port)
                }
                break
            case .sunmi:
                printer_ip.text = "In qua Sunmi"
                break
            case .Imin:
                printer_ip.text = "In qua iMin"
                break
            case .blueTooth:
                printer_ip.text = "In Bluetooth"
                break
            case .usb:
                printer_ip.text = "In qua USB"
                break
            default:
                break
                
        }
        
      
        status.text = data.is_have_printer == ACTIVE ? "ĐANG HOẠT ĐỘNG" : "NGƯNG HOẠT ĐỘNG"
        status.textColor = data.is_have_printer == ACTIVE ? ColorUtils.blue_brand_700() : ColorUtils.gray_600()
    }

}
