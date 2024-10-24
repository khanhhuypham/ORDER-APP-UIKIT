//
//  PrintingQueueViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/06/2024.
//

import UIKit
import RealmSwift
import HXPhotoPicker
class PrintingQueueViewController: UIViewController {
    
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    var viewmodel = PrintingQueueViewModel()
    weak var timer: Timer?
    var isFoodApp:Bool = false
    
    //MARK: po Realm.Configuration.defaultConfiguration.fileURL
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.bind(view: self)
        setupUI()
    }
    
    func setupUI() {
        lbl_time.text = TimeUtils.getCurrentDateTime().today
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
   
            self?.lbl_time.text = TimeUtils.getCurrentDateTime().today
        }
        //tableview
        tableView.register(UINib(nibName: "PrintingQueueTableViewCell", bundle: .main), forCellReuseIdentifier: "PrintingQueueTableViewCell")
        viewmodel.delegate = self
        viewmodel.setupObserve()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        fetchData()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    
    func fetchData() {
        viewmodel.fetchData{ (done) in
            if done {
                self.updateUI()
            } else {
                print("Lỗi fetch data từ realm")
            }
        }
    }
    
}


//MARK: - TableView Delegate & Datasource
extension PrintingQueueViewController: UITableViewDataSource, UITableViewDelegate,PrintingQueueViewModelDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewmodel.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrintingQueueTableViewCell", for: indexPath) as! PrintingQueueTableViewCell

        let data = viewmodel.getItem(at: indexPath)
        
        if data.type == .tsc {
            cell.tscdata = data.item as? TSCQueuedItemObject
        }else{
            cell.wifidata = data.item as? WIFIQueuedItemObject
        }
        
        cell.viewModel = viewmodel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let queuedtem = viewmodel.getItem(at: indexPath)
        var medias:[MediaDownloadable] = []
        let media = SingleMedia(imageURL: nil)
        
        if queuedtem.type == .tsc {
            
            let TSCItem = queuedtem.item as? TSCQueuedItemObject
            
            var image:UIImage = UIImage()
            
            

            for data in TSCItem!.data{
                
               image = MediaUtils.combineScreenshots(image, UIImage(data: data)) ?? UIImage()
                
            }
            
            media.image = image
        }else{
            let wifiItem = queuedtem.item as? WIFIQueuedItemObject
            media.image = UIImage(data: wifiItem?.data ?? Data())
        }
        
       
        medias.append(media)
        let viewModelReview = FullScreenImageBrowserViewModel(media: medias)
        let controller = FullScreenImageBrowser(viewModel: viewModelReview, startingImage: medias[0])
        present(controller, animated: true, completion: nil)
        
    
    }
    
    func viewModel(_ viewModel: PrintingQueueViewModel, needperfomAction action: PrintingQueueViewModel.Action) {
        fetchData()
    }
    
    
    
}
