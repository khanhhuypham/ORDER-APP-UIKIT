//
//  MessageCell + Extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/05/2024.
//

import UIKit
import Kingfisher
extension MessageCellTableViewCell {
    func mapMessage(message: MessageResponse, viewModel:ChatChannelViewModel){
        
        if message.user.user_id == Constants.user.id{
            content_view.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#0071BB").withAlphaComponent(0.08)
            content_view.borderColor = ColorUtils.blue_brand_400()
            view_avatar.isHidden = true
        }else{
            content_view.backgroundColor = ColorUtils.hexStringToUIColor(hex: "#F5F6FA").withAlphaComponent(0.85)
            content_view.borderColor = ColorUtils.gray_300()
            view_avatar.isHidden = false
            avatar.image = UIImage(named: "icon-techres-default")
        }
       
    

        lbl_last_message_time.text = TimeUtils.convertTimeLineForChatChannel(from: message.created_at, true)
        view_of_last_message_time.isHidden = message.is_timeline == .deactive
        msg_view_container.isHidden = true
        link_view_container.isHidden = true
        video_view_container.isHidden = true
        reply_view_container.isHidden = true
        sticker_view_container.isHidden = true
        file_view_container.isHidden = true
        audio_view_container.isHidden = true
        image_view_container.isHidden = true
        view_status_message.isHidden = !isLastMessage
        lbl_status_message.text = message.status_message == .active ?  "Đang gửi" : "Đã nhận"
        image_status_message.image = message.status_message == .active ? UIImage(systemName: "clock") : UIImage(named: "icon-check-white")
        view_reaction.isHidden = message.my_reaction == 0
        
        lbl_msg_time.text = TimeUtils.convertTimeLineForChatChannel(from: message.created_at, false)

        
 
        switch message.message_type{
            case .text:
            
                message.thumb.url.isEmpty
                ? mapText(message:message, viewModel:viewModel)
                : mapLink(message:message, viewModel:viewModel)
           
            case .file:
              
                mapfile(message:message, viewModel:viewModel)
                break
                
            case .image:
                mapImage(message:message, viewModel:viewModel)
                break
            
            case .video:
                mapVideo(message:message, viewModel:viewModel)
                break
                
            case .reply:
                mapReply(message:message, viewModel:viewModel)
                break
                
            case .sticker:
                mapSticker(message:message, viewModel:viewModel)
                break
                
            case .audio:
                mapAudio(message:message, viewModel:viewModel)
                break
            
            case .revoke_message:
                lbl_msg_text.text = "Tin nhắn đã được thu hồi"
                lbl_msg_text.textColor = ColorUtils.gray_600()
                break
            
            default:
                break
        }
        self.layoutIfNeeded()
    }
    
    
    
    private func mapText(message: MessageResponse, viewModel:ChatChannelViewModel){
        msg_view_container.isHidden = false
        setConstraint(view:msg_view,message:message)
        lbl_msg_text.text = message.message
    }
    
    
    private func mapLink(message: MessageResponse, viewModel:ChatChannelViewModel){

        link_view_container.isHidden = false
        setConstraint(view:link_view,message:message)
        lbl_link_url.text = message.thumb.url
        link_img_thumbnail.kf.setImage(with: URL(string: message.thumb.logo), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_link_domain.text = message.thumb.domain
        lbl_link_title.text = message.thumb.title
        lbl_link_description.text = message.thumb.description
        
    }
    
    private func mapReply(message: MessageResponse, viewModel:ChatChannelViewModel){
        reply_view_container.isHidden = false
        
    }
    
    private func mapSticker(message: MessageResponse, viewModel:ChatChannelViewModel){
        sticker_view_container.isHidden = false
        setConstraint(view:sticker_view,message:message)
        let stickerLocal = message.sticker.url_local.isEmpty
        ? message.sticker.original.url
        : message.sticker.url_local
        image_sticker.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: stickerLocal)), placeholder: UIImage(named: "image_defauft_medium"))
    }
    
    private func mapVideo(message: MessageResponse, viewModel:ChatChannelViewModel){
        video_view_container.isHidden = false
        setConstraint(view:video_view,message:message,width_constant: 250)
        var videoLocal = URL(string: "")
        
        if let video = message.media.first{
            
            if video.url_local == "" {
                videoLocal = URL(string: Utils.getFullMediaLink(string: video.thumb.url))
            } else {
                if let videoURL = URL(string: video.url_local) {
                    MediaUtils.generateThumbnailURLFromVideo(for: videoURL) { thumbnailURL in
                        if let thumbnailURL = thumbnailURL {
                            videoLocal = thumbnailURL
                        }
                    }
                }
            }
        }
       
        image_video.kf.setImage(with: videoLocal, placeholder: UIImage(named: "image_defauft_medium"))
        
    }
    
    private func mapfile(message: MessageResponse, viewModel:ChatChannelViewModel){
        file_view_container.isHidden = false
        setConstraint(view:file_view,message:message)
        if let media = message.media.first{
            lbl_file_name.text = media.original.name
            let size = MediaUtils.getSizeOfFile(size: Float(media.original.size))
            if let url = URL(string: media.original.link_full),!media.original.link_full.isEmpty {
                lbl_path_extension.text = url.pathExtension
                lbl_size_type_name.text = String(format: "%@ • %@", size, url.pathExtension.uppercased())
            } else {
                lbl_path_extension.text = "FILE"
                lbl_size_type_name.text = String(format: "%@ • FILE", size)
            }
            
            if fileExistsInDocumentsDirectory(fileName: media.original.name) {
                btnDownload.setImage(UIImage(named: "image-background-white-border-gray"), for: .normal)
                lbl_open_file.isHidden = false
            } else {
                btnDownload.setImage(UIImage(named: "icon-download-background-while"), for: .normal)
                lbl_open_file.isHidden = true
            }
        }
    }
    
    func fileExistsInDocumentsDirectory(fileName: String) -> Bool {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            dLog("Could not find the Documents directory.")
            return false
        }
        let decodedFileName = fileName.removingPercentEncoding ?? fileName
        let destinationURL = documentsDirectory.appendingPathComponent(decodedFileName)
        return fileManager.fileExists(atPath: destinationURL.path)
    }
    

    private func mapAudio(message: MessageResponse, viewModel:ChatChannelViewModel){
        audio_view_container.isHidden = false
        setConstraint(view:audio_view,message:message)
        audioPlayerController = AudioPlayerController()
        
        if let media = message.media.first{
            if media.is_play_audio == DEACTIVE {
                audioPlayerController?.stopAudio()
            } else {
                audioPlayerController?.playAudio(from: MediaUtils.getFullMediaLink(string: media.original.url),durationStringUpdateHandler: { duration in
                     self.lbl_time_audio.text = duration
                 }, completion: {
                     self.updatePlayStopButtonTitle()
                 })
                updatePlayStopButtonTitle()
            }
        }
        
    
    }
    
    private func updatePlayStopButtonTitle() {
        if let audio = audioPlayerController{
            image_status_play_audio.image = UIImage(named:audio.isAudioPlaying() ? "icon-pause-default" : "icon-play-default")
            image_animate_play_audio.image = UIImage(named:audio.isAudioPlaying() ? "audio_play" : "icon-chart-gray")
        }
  
    }
    
    
    private func mapImage(message: MessageResponse, viewModel:ChatChannelViewModel){
        image_view_container.isHidden = false
        var horizontalPadding:CGFloat = 0
        var verticalPadding:CGFloat = 0
        var width:CGFloat = 0
        switch message.media.count{
            case 0:
                break
            
            case 1:
                
                height_of_collectionView.constant = 250
                setConstraint(view:image_view,message: message, width_constant: 200)
            
            case 2:
                horizontalPadding = 2
                width = 300 + horizontalPadding
                height_of_collectionView.constant = 200
                setConstraint(view:image_view,message: message, width_constant: width)
                break
                
            case 3:
                horizontalPadding = 4
                width = 300 + horizontalPadding
                height_of_collectionView.constant = 100
                setConstraint(view:image_view,message: message, width_constant: width)
                break
                
            case 4:
                verticalPadding = 4
                height_of_collectionView.constant = 200 + verticalPadding
                horizontalPadding = 2
                width = 300 + horizontalPadding
                setConstraint(view:image_view,message: message, width_constant: width)
                break
                
            case 5:
                verticalPadding = 4
                height_of_collectionView.constant = 200 + verticalPadding
                horizontalPadding = 4
                width = 300 + horizontalPadding
                setConstraint(view:image_view,message: message, width_constant: width)
                break
                
            default:
                verticalPadding = 6
                let column = 3
                let multiplier = (message.media.count - 1) / column + 1
                height_of_collectionView.constant = CGFloat(multiplier*100) + verticalPadding
                horizontalPadding = 4
                width = 300 + horizontalPadding
                setConstraint(view:image_view,message: message, width_constant: width)
                break
        }
        collectionView.reloadData()
    }
    
    func handleDownLoadFile(dataMedia: MediaChat) {
        DispatchQueue.main.async {
            self.btnDownload.showCircularProgress()
        }
        guard let urlFile = URL(string: MediaUtils.getFullMediaLink(string: dataMedia.original.url)) else {
            dLog("Invalid URL: \(MediaUtils.getFullMediaLink(string: dataMedia.original.url))")
            DispatchQueue.main.async {
                self.btnDownload.hideCircularProgress()
            }
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: DownloadManager.shared, delegateQueue: OperationQueue.main)
        
        DownloadManager.shared.progressHandler = { progress in
            self.btnDownload.updateCircularProgress(progress: progress)
        }
        
        DownloadManager.shared.completionHandler = { location, error in
            if let error = error {
                dLog("Error downloading file: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.btnDownload.hideCircularProgress()
                }
                return
            }
            guard let location = location else {
                dLog("Download location is nil")
                DispatchQueue.main.async {
                    self.btnDownload.hideCircularProgress()
                }
                return
            }
            let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                dLog("Could not find the Documents directory.")
                DispatchQueue.main.async {
                    self.btnDownload.hideCircularProgress()
                }
                return
            }
            let fileURL = documentsDirectory.appendingPathComponent(dataMedia.original.name)
            do {
                try fileManager.moveItem(at: location, to: fileURL)
                DispatchQueue.main.async {
                    self.viewModel?.view?.tableView.reloadRows(at: [IndexPath(row: self.index, section: 0)], with: .none)
                    self.btnDownload.hideCircularProgress()
                    dLog("File downloaded and saved to: \(fileURL)")
                }
            } catch {
                dLog("Error saving file: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.btnDownload.hideCircularProgress()
                }
            }
        }
        let task = session.downloadTask(with: urlFile)
        task.resume()
    }
}
