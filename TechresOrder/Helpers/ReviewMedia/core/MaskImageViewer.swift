//
//  MaskImageViewer.swift
//  A_J_Full_Screen_Image_Browser
//
//  Created by Junliang Jiang on 25/2/18.
//  Copyright © 2018 Junliang Jiang. All rights reserved.
//

import UIKit
import Photos

public protocol MaskImageViewable: AnyObject {
    var imagesBrowser: FullScreenImageBrowser? { get set }

    func populateWithImage(_ image: MediaDownloadable)
    func setHidden(_ hidden: Bool, animated: Bool)
}

public final class MaskImageView: UIView , MaskImageViewable {
    public private(set) var navigationBar: UINavigationBar!

    public private(set) var navigationItem: UINavigationItem!
    public weak var imagesBrowser: FullScreenImageBrowser?
    private var currentMedia: MediaDownloadable?

    public var leftBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.leftBarButtonItem = leftBarButtonItem
        }
    }
    
    public var rightBarButtonItem: UIBarButtonItem? {
        didSet {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }

    #if swift(>=4.0)
    public var titleTextAttributes: [NSAttributedString.Key : AnyObject] = [:] {
        didSet {
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    #else
    public var titleTextAttributes: [String : AnyObject] = [:] {
        didSet {
            navigationBar.titleTextAttributes = titleTextAttributes
        }
    }
    #endif

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationBar()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) , hitView != self {
            return hitView
        }
        return nil
    }

    public override func layoutSubviews() {
        UIView.performWithoutAnimation {
            self.navigationBar.invalidateIntrinsicContentSize()
            self.navigationBar.layoutIfNeeded()
        }
        super.layoutSubviews()
    }

    public func setHidden(_ hidden: Bool, animated: Bool) {
        if isHidden == hidden { return }
        if !animated { isHidden = hidden; return }

        isHidden = false
        alpha = hidden ? 1.0 : 0.0

        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: [.allowAnimatedContent, .allowUserInteraction],
                       animations: { self.alpha = hidden ? 0.0 : 1.0 },
                       completion: { _ in self.alpha = 1.0; self.isHidden = hidden })
    }

    public func populateWithImage(_ media: MediaDownloadable) {
        currentMedia = media

        guard let _imagesBrowser = imagesBrowser,
              let index = imagesBrowser?.viewModel.indexOfMedia(media) else { return }

        navigationItem.title = String(format:NSLocalizedString("%d/%d",comment:""),
                                      index+1,
                                      _imagesBrowser.viewModel.numberOfImages)
    }

    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        imagesBrowser?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func downloadButtonTapped(_ sender: UIBarButtonItem) {
        if currentMedia?.isVideoThumbnail == true {
            self.imagesBrowser?.currentImageViewer?.view.bringSubviewToFront((self.imagesBrowser?.currentImageViewer?.activityIndicator)!)
            self.imagesBrowser?.currentImageViewer?.activityIndicator.startAnimating()
            if let urlString = currentMedia?.videoString {
                DispatchQueue.global(qos: .background).async {
                    if let url = URL(string: urlString),
                       let urlData = NSData(contentsOf: url) {
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                        let filePath = "\(documentsPath)/tempFile.mp4"
                        DispatchQueue.main.async {
                            urlData.write(toFile: filePath, atomically: true)
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                            }) { completed, error in
                                if completed {
                                    dLog("Video is saved!")
                                    let userInfo = ["userInfo": ["type": media_type.video.rawValue ]]
                                    NotificationCenter.default
                                        .post(name: NSNotification.Name("downloadMedia"),
                                              object: nil,
                                              userInfo: userInfo)
                                }else{
                                    dLog("Error saving video: \(error?.localizedDescription ?? "Unknown error")")
                                    let userInfo = ["userInfo": ["type":  media_type.type_error.rawValue ]]
                                    NotificationCenter.default
                                        .post(name: NSNotification.Name("downloadMedia"),
                                              object: nil,
                                              userInfo: userInfo)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.imagesBrowser?.currentImageViewer?.activityIndicator.startAnimating()
            guard let url = currentMedia?.imageURL else {
                dLog("Invalid URL Image")
                let userInfo = ["userInfo": ["type": media_type.type_error.rawValue ]]
                NotificationCenter.default
                            .post(name: NSNotification.Name("downloadMedia"),
                             object: nil,
                             userInfo: userInfo)
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let imageData = data {
                    PHPhotoLibrary.shared().performChanges({
                        if let image = UIImage(data: imageData),
                           let pngData = image.pngData() {
                            let creationRequest = PHAssetCreationRequest.forAsset()
                            creationRequest.addResource(with: .photo, data: pngData, options: nil)
                        }
                    }) { success, error in
                        if success {
                            dLog("Image saved to library successfully.")
                            let userInfo = ["userInfo": ["type": media_type.image.rawValue ]]
                            NotificationCenter.default
                                        .post(name: NSNotification.Name("downloadMedia"),
                                         object: nil,
                                         userInfo: userInfo)
                        } else if let error = error {
                            dLog("Error saving image to library: \(error.localizedDescription)")
                            let userInfo = ["userInfo": ["type": media_type.type_error.rawValue ]]
                            NotificationCenter.default
                                        .post(name: NSNotification.Name("downloadMedia"),
                                         object: nil,
                                         userInfo: userInfo)
                        }
                    }
                }
            }.resume()
        }
    }

    private func setupNavigationBar() {
        navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.barTintColor = nil
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)

        navigationItem = UINavigationItem(title: "")
        navigationBar.items = [navigationItem]
        addSubview(navigationBar)

        let topConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            topConstraint = navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        } else {
            topConstraint = navigationBar.topAnchor.constraint(equalTo: self.topAnchor)
        }
        let widthConstraint = navigationBar.widthAnchor.constraint(equalTo: self.widthAnchor)
        let horizontalConstraint = navigationBar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        NSLayoutConstraint.activate([topConstraint, widthConstraint, horizontalConstraint])

        if let bundlePath = Bundle(for: type(of: self)).path(forResource: "FullScreenImageBrowser", ofType: "bundle") {
            let bundle = Bundle(path: bundlePath)
            leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close", in: bundle, compatibleWith: nil),
                                                style: .plain,
                                                target: self,
                                                action: #selector(MaskImageView.closeButtonTapped(_:)))

            rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "fi-rr-download", in: bundle, compatibleWith: nil),
                                                style: .plain,
                                                target: self,
                                                action: #selector(MaskImageView.downloadButtonTapped(_:)))
        } else {
            leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                target: self,
                                                action: #selector(MaskImageView.closeButtonTapped(_:)))
        }
    }
}
