//
//  BLEInvestigatorViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/07/2024.
//

import UIKit

class BLEInvestigatorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var delegate:BLEInvestigatorViewControllerDelegate?
    public var BLEPrinterManager:POSBLEManager = { 
        return POSBLEManager.sharedInstance()
    }()
    
    
    var printer = Printer()
    var dataSource = [CBPeripheral]()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        BLEPrinterManager.delegate = self
        BLEPrinterManager.startScan()
        
        
        tableView.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#28282B")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        

 
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
       dismiss(animated: true)
    }
       
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        guard indexPath.row < dataSource.count else {
            return cell
        }

        let printer = dataSource[indexPath.row]

        cell.textLabel?.text = printer.name ?? "unknow"
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
        cell.accessoryType = printer.state == .connected ? .checkmark : .none
        cell.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#28282B")
        
     
    
        switch printer.state{
            case .disconnected:
                print("disconnected")
                cell.accessoryView = nil
                cell.setEditing(false, animated: false)
            case .connecting:
                let v = UIActivityIndicatorView(style: .white)
                v.startAnimating()
                cell.accessoryView = v
            
            case .connected:
                print("connected")
                cell.accessoryView = nil
                cell.setEditing(false, animated: false)
                delegate?.getSelectedBLEDevice(device: printer)
            case .disconnecting:
                print("disconnecting")
                
            
            default: 
            break
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let peripheral = dataSource[indexPath.row]

        
        if peripheral.state == .connected {
            BLEPrinterManager.disconnectRootPeripheral()
        }else{
            BLEPrinterManager.connectDevice(peripheral)
        }
        
   }
    
    

}


extension BLEInvestigatorViewController: POSBLEManagerDelegate{
    
    func poSbleUpdatePeripheralList(_ peripherals: [Any]!, rssiList: [Any]!) {
        var list = peripherals as? [CBPeripheral]
 
        for peripheral in list ?? []{
            
            if !dataSource.contains(where: {$0.name == peripheral.name}){
                dataSource.append(peripheral)
            }
        }
        tableView.reloadData()
    }
    
    
    func poSbleConnect(_ peripheral: CBPeripheral!) {
        tableView.reloadData()
    }
    
    func poSbleFail(toConnect peripheral: CBPeripheral!, error: Error!) {
        BLEPrinterManager.disconnectRootPeripheral()
        messageBox(error.localizedDescription, withTitle: "Cảnh báo", withAutoDismiss: true)
    }
    
    func messageBox(_ message: String, withTitle title: String, withAutoDismiss dismiss: Bool){
        let alert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle:  UIAlertController.Style.alert)
        if dismiss == true {
          
            present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    alert.dismiss(animated: false, completion: nil)
                })
            })
         }else {
             let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
//
//    #pragma mark - POSBLEManagerDelegate
//
//    - (void)POSbleUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList {
//        _dataArr = [NSMutableArray arrayWithArray:peripherals];
//        _rssiList = [NSMutableArray arrayWithArray:rssiList];
//        [self.myTable reloadData];
//    }
//
//    - (void)POSbleConnectPeripheral:(CBPeripheral *)peripheral {
//        [self.indicator stopAnimating];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//
//    - (void)POSbleFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
//        [self.indicator stopAnimating];
//        [self.view makeToast:@"connect fail" duration:1.f position:CSToastPositionCenter];
//    }
}



