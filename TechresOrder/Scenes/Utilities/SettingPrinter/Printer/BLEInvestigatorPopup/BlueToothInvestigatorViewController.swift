////
////  BlueToothInvestigatorViewController.swift
////  TECHRES-ORDER
////
////  Created by Pham Khanh Huy on 25/11/2023.
////
//
//import UIKit
//import Foundation
//import JonAlert
//class BlueToothInvestigatorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
//    public var printerManager: BluetoothPrinterManager?
//    @IBOutlet weak var tableView: UITableView!
//    var dataSource = [BluetoothPrinter]()
//    var printer = Kitchen()
//    
//    
//    var delegate:BLEInvestigatorViewControllerDelegate?
//    
//    
//    @IBOutlet weak var root_view: UIView!
//    
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#28282B")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//       
//    }
//    
//
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        dataSource = printerManager?.nearbyPrinters ?? []
//        printerManager?.delegate = self
//       
//    }
// 
//    @IBAction func actionCancel(_ sender: Any) {
//        dismiss(animated: true)
//    }
//    
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//        guard indexPath.row < dataSource.count else {
//            return cell
//        }
//
//        let printer = dataSource[indexPath.row]
//
//        cell.textLabel?.text = printer.name ?? "unknow"
//        cell.textLabel?.textColor = .white
//        cell.selectionStyle = .none
//        cell.accessoryType = printer.state == .connected ? .checkmark : .none
//        cell.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#28282B")
//
//        if printer.isConnecting {
//            let v = UIActivityIndicatorView(style: .white)
//            v.startAnimating()
//            cell.accessoryView = v
//        } else {
//            cell.accessoryView = nil
//            cell.setEditing(false, animated: false)
//            switch printer.state{
//                case .connected:
////                    delegate?.getSelectedDevice(device: printer)
//                    break
//                case .disconnected:
////                    delegate?.getSelectedDevice(device: BluetoothPrinter.init())
//                    break
//                    
//                default:
//                    break
//
//            }
//        }
//
//        return cell
//    }
//    
//    func messageBox(_ message: String, withTitle title: String, withAutoDismiss dismiss: Bool){
//        let alert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle:  UIAlertController.Style.alert)
//        if dismiss == true {
//          
//            present(alert, animated: true, completion: {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                    alert.dismiss(animated: false, completion: nil)
//                })
//            })
//         }else {
//             let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                (action: UIAlertAction!) -> Void in
//                print("OK")
//            })
//            alert.addAction(defaultAction)
//            present(alert, animated: true, completion: nil)
//        }
//    }
//    
//
//     public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let p = dataSource[indexPath.row]
//     
//        if p.state == .connected {
//            printerManager?.disconnect(p)
//        } else {
//            printerManager?.disconnectAllPrinter()
//            printerManager?.connect(p)
//           
//        }
//    }
//}
//
//extension BlueToothInvestigatorViewController: PrinterManagerDelegate {
//    public func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {
//        tableView.beginUpdates()
//
//        switch change {
//            case let .add(p):
//                let indexPath = IndexPath(row: dataSource.count, section: 0)
//                dataSource.append(p)
//                tableView.insertRows(at: [indexPath], with: .automatic)
//            case let .update(p):
//                guard let row = (dataSource.firstIndex { $0.identifier == p.identifier }) else {
//                    return
//                }
//                dataSource[row] = p
//                let indexPath = IndexPath(row: row, section: 0)
//                tableView.reloadRows(at: [indexPath], with: .automatic)
//            case let .remove(identifier):
//                guard let row = (dataSource.firstIndex { $0.identifier == identifier }) else {
//                    return
//                }
//                dataSource.remove(at: row)
//                let indexPath = IndexPath(row: row, section: 0)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            
//            case let .timeout(p):
//                messageBox("Quá thời gian kết nối tới thiết bị\n" + (p.name ?? ""), withTitle: "Cảnh báo", withAutoDismiss: true)
//            }
//
//        tableView.endUpdates()
//    }
//
//}
