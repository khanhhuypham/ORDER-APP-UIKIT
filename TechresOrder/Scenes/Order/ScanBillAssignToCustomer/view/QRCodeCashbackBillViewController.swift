//
//  QRCodeCashbackBillViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 27/01/2023.
//
import Foundation
import UIKit
import AVFoundation
import ObjectMapper

class QRCodeCashbackBillViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    var viewModel = QRCodeCashbackBillViewModel()
    var router = QRCodeCashbackBillRouter()
    
    @IBOutlet weak var lbl_header_order_id_table_name: UILabel!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isWaiting = false
    
    @IBOutlet weak var qrCodeLayout: UIView!
    var delegate:QRCodeCashbackBillDelegate? = nil
    var order_id = 0
    var table_name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        qrCodeLayout.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lbl_header_order_id_table_name.text = String(format: "#%d %@", order_id, table_name)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
   
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            let alert = UIAlertController(title: "Tính năng này cần truy cập vào máy ảnh", message: "Trong ứng dụng Cài đặt trên iPhone, hãy nhấn vào Techres - Order rồi cho phép truy cập vào camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Để sau", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cài đặt", style: .default, handler: {action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }))
            self.present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            break
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
            isWaiting = false
        }
       
        checkCameraAccess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            if isWaiting{
                return
            };
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            debugPrint(stringValue)
            self.navigationController?.popViewController(animated: false)
            captureSession.stopRunning()
            delegate?.callBackQRCodeCashbackBill(order_id:self.order_id, qrcode: stringValue)
            
        }
        
        dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

