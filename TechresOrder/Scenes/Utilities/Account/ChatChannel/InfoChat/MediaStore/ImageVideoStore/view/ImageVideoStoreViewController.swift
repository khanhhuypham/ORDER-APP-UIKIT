//
//  ImageVideoStoreViewController.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 29/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import JonAlert

class ImageVideoStoreViewController: BaseViewController {

    var viewModel = ImageVideoStoreViewModel()
    var router = ImageVideoStoreRouter()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var view_load_more: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var conversation_id: String = ""
    
    var indexPath: IndexPath?
    var isLoadingMore = true
    var isResetData = false
    let refreshControl = UIRefreshControl()
    var dataArrayReview: [MediaDownloadable] = []
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.style = .large
        loading.color = .systemOrange
        return loading
    }()
    
    var groupedMediaObservable: Observable<[MediaSection]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
                
        registerCell()
        bindCollectionView()
        
        collectionView.contentInset.bottom += 55
        
        collectionView.delegate = self
        
        viewModel.object_id.accept(conversation_id)
        
        getListMedia()
        
    }
    
}
