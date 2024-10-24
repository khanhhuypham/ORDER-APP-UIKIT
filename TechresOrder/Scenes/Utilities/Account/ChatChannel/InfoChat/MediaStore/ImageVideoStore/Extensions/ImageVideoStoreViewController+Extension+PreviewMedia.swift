//
//  ImageVideoStoreViewController+Extension+PreviewMedia.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 25/01/2024.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit

extension ImageVideoStoreViewController {
    func presentModalPlayVideoViewController(urlVideo: URL) {
        let vc = PlayVideoViewController()
        vc.urlVideo = urlVideo
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.large()]
            }
        }
        present(nav, animated: true, completion: nil)
    }
    
    func presentModalPreviewViewController(position: Int) {
        let viewModelReview = FullScreenImageBrowserViewModel(media: dataArrayReview)
        let controller = FullScreenImageBrowser(viewModel: viewModelReview, startingImage: dataArrayReview[position])
        
        if dataArrayReview[position].isVideoThumbnail {
            if let videoURL = dataArrayReview[position].videoURL {
                presentModalPlayVideoViewController(urlVideo: videoURL)
            }
        } else {
            present(controller, animated: true, completion: nil)
        }
    }
}
