//
//  ChatChannel + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/05/2024.
//

import UIKit
import JonAlert
import HXPhotoPicker
import Photos

extension ChatChannelViewController {
    
    
    func presentModalPlayVideoViewController(urlVideo: URL) {
        let vc = PlayVideoViewController()
        vc.urlVideo = urlVideo
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func presentModalPreviewViewController(media: [MediaDownloadable], position: Int) {
        let viewModelReview = FullScreenImageBrowserViewModel(media: media)
        let controller = FullScreenImageBrowser(viewModel: viewModelReview, startingImage: media[position])
   
        if let firstMedia = media.first,firstMedia.isVideoThumbnail{
            self.presentModalPlayVideoViewController(urlVideo: media[0].videoURL!)
        }else{
            present(controller, animated: true, completion: nil)
        }
    }
    
    
     func handleSelectedMedia(message: MessageResponse,media:MediaChat? = nil) {
                
        switch message.message_type{
            case .text:
                break
            
            case .image:
                var mediaArray: [MediaDownloadable] = []
                var postition = 0
                for ( i,data) in message.media.enumerated() {
                    
                    let imageUrl = data.url_local.isEmpty
                    ? MediaUtils.getFullMediaLink(string: data.original.url,media_type: .image)
                    : data.url_local
                    
                    if data.media_id == media?.media_id {
                        postition = i
                    }
                    mediaArray.append(SingleMedia(imageURL: URL(string: imageUrl)))
                }

                presentModalPreviewViewController(media:mediaArray, position:postition)
            
            case .video:
                if let video = message.media.first{
                    let videoURL = video.url_local.isEmpty
                    ? URL(string: MediaUtils.getFullMediaLink(string: video.original.link_full, media_type: .video))
                    : URL(string: message.media[0].url_local)
                    if let url = videoURL{
                        presentModalPlayVideoViewController(urlVideo: url)
                    }
                }
            
            case .audio:
                var messageList = viewModel.messageList.value
                if let position = messageList.firstIndex(where: {$0.message_id == message.message_id}),var media = messageList[position].media.first{
                    media.is_play_audio = media.is_play_audio == ACTIVE ? DEACTIVE : ACTIVE
                    messageList[position].media[0] = media
                }
                viewModel.messageList.accept(messageList)
                
            case .file:
                if let media = message.media.first {
                    DispatchQueue.main.async {
                        let fileName = media.original.name
                        let fileManager = FileManager.default
                        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                            dLog("Could not find the Documents directory.")
                            return
                        }
                        let decodedFileName = fileName.removingPercentEncoding ?? fileName
                        let destinationURL = documentsDirectory.appendingPathComponent(decodedFileName)
                        let documentInteractionController = UIDocumentInteractionController(url: destinationURL)
                        documentInteractionController.delegate = self
                        documentInteractionController.presentPreview(animated: true)
                    }
                }
                
            default:
                break
        }
        
    }
    
}

// Delegate Open File If Exists
extension ChatChannelViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}


extension ChatChannelViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var docsData = Data()
        let maxVideoSize = 200 * 1024 * 1024 // 50MB in bytes
        
        if urls.count > 0 {
            guard let fileURL = urls.first else { return }
            if fileURL.startAccessingSecurityScopedResource() {
                do {
                    docsData = try Data(contentsOf: fileURL)
                } catch let error {
                    dLog(error.localizedDescription)
                }
                let fileName = fileURL.lastPathComponent
                let decodedFileName = fileName.removingPercentEncoding ?? fileName
                let sizeFile = MediaUtils.getSizeOfFile(url: fileURL)
                
                
                if sizeFile > maxVideoSize {
                    JonAlert.show(message: "Dung lượng media tối đa 200MB", andIcon: UIImage(named: "icon-warning"), duration: 2.0)
                } else {
                    //media.is_keep = 1 , lưu lại mãi mãi. Nếu 0 sẽ bị xoá sau 1 thời gian ( trường hợp trong group chat)
                    let media = Media(name: decodedFileName, type: .file, url: fileURL, size: sizeFile, width: 0, height: 0, is_keep: 1)
                    getGenerateMedia(medias: [media], fileData: docsData)
                    sendMessageLocal(messageType: .file, medias: [media])
                }
            }
        } else {
            dLog("Pick Documents Fail")
        }
    }
}





extension ChatChannelViewController:PhotoPickerControllerDelegate {
    
    func presentImageBrowserViewController() {
        /// Setup cho thư viện chọn và chuẩn bị dữ liệu hiển thị lên Local
        var config: PickerConfiguration = PhotoTools.getWXPickerConfig(isMoment: true)
        config.maximumSelectedCount = 10
        config.maximumSelectedVideoCount = 1
        config.maximumSelectedVideoDuration = 0
        config.selectOptions = [.photo, .video, .livePhoto, .gifPhoto]
        config.modalPresentationStyle = .fullScreen
        config.photoList.isShowFilterItem = false
        config.photoList.bottomView.isHiddenOriginalButton = true
        config.photoList.leftNavigationItems = [PhotoTextCancelItemView.self]
        config.previewView.bottomView.isHiddenOriginalButton = true
        let pickerController = PhotoPickerController(picker: config)
        pickerController.pickerDelegate = self
        pickerController.selectedAssetArray = []
        pickerController.isOriginal = true
        pickerController.autoDismiss = false
        present(pickerController, animated: true, completion: nil)
    }
    
    func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
        pickerController.dismiss(true){
            self.handleSelectedAsset(assets: result.photoAssets)
        }
    }
    
    func handleSelectedAsset(assets:[PhotoAsset]){
        let maxVideoSize = 200 * 1024 * 1024 // 50MB in bytes
        if assets.map{$0.phAsset ?? PHAsset()}.filter{MediaUtils.getAssetSize(asset:$0) > maxVideoSize}.isEmpty{
            self.setupPathFiles(assets: assets)
        }else{
            JonAlert.show(message: "Dung lượng video tối đa 200MB", andIcon: UIImage(named: "icon-warning"), duration: 2.5)
        }
    }
    
    /// Chuẩn bị dữ liệu cho Path File để upload file video
    func setupPathFiles(assets:[PhotoAsset]) {
        var medias:[Media] = []
        for ( _,asset ) in assets.enumerated() {
            
            if let image = asset.originalImage,let phAsset = asset.phAsset{
                switch phAsset.mediaType{
                    case .image:
                        let requestOptions = PHImageRequestOptions()
                        requestOptions.isSynchronous = true
                        PHImageManager.default().requestImageDataAndOrientation(for: phAsset, options: requestOptions) { (imageData, dataUTI, orientation, info) in
                            if let data = imageData, let imageURL = MediaUtils.saveImageDataToFile(data: data, fileExtension: URL(string: dataUTI ?? "jpg")?.pathExtension ?? "jpg") {
//
                                medias.append(
                                   Media(
                                       name: MediaUtils.getAssetFullName(asset: phAsset),
                                       type: .image,
                                       url: imageURL,
                                       size: 1,
                                       width: Int(image.size.width),
                                       height: Int(image.size.height),
                                       is_keep: 1
                                   )
                               )
                                
                            }
                        }
                    case .video:
                        
                        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { (avAsset, _, _) in
                            if let avAsset = avAsset as? AVURLAsset {
                                
                                
                                
                                medias.append(
                                   Media(
                                       name: MediaUtils.getAssetFullName(asset: phAsset),
                                       type: .video,
                                       url: avAsset.url,
                                       size: 1,
                                       width: Int(image.size.width),
                                       height: Int(image.size.height),
                                       is_keep: 1
                                   )
                               )
                                
                                DispatchQueue.main.async {
                                    self.getGenerateMedia(medias: medias)
                                }
                            
                                self.sendMessageLocal(messageType: .video,medias:medias)
                            }
                        }
                        break
                        
                    case .audio:
                        break
                    
                    default:
                        break
                }
            }
        }
        
    
                
        //take the first element to evaluate its type,
        if let asset = assets.first, let phAsset = asset.phAsset, phAsset.mediaType == .image{
            getGenerateMedia(medias: medias)
            sendMessageLocal(messageType: .image,medias:medias)
        }
    }
    

    func pickerController(didCancel pickerController: PhotoPickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
}
