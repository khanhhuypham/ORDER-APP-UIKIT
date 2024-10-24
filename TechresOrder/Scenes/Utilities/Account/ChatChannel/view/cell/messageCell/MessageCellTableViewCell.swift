//
//  MessageCellTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/05/2024.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {
    
   

    @IBOutlet weak var view_avatar: UIView!
    @IBOutlet weak var avatar: UIImageView!
    //MARK: time line
    @IBOutlet weak var lbl_last_message_time: UILabel!
    @IBOutlet weak var view_of_last_message_time: UIView!

    @IBOutlet weak var container_view: UIView!
    @IBOutlet weak var content_view: UIView!
    
    //MARK: text
    
    @IBOutlet weak var msg_view_container: UIView!
    @IBOutlet weak var msg_view: UIView!
    @IBOutlet weak var lbl_msg_text: UILabel!
    
    //MARK: link
    @IBOutlet weak var link_view_container: UIView!
    @IBOutlet weak var link_view: UIStackView!
    @IBOutlet weak var lbl_link_url: UILabel!
    @IBOutlet weak var link_img_thumbnail: UIImageView!
    @IBOutlet weak var lbl_link_domain: UILabel!
    @IBOutlet weak var lbl_link_title: UILabel!
    @IBOutlet weak var lbl_link_description: UILabel!
    
    //MARK: reply
    
    @IBOutlet weak var reply_view_container: UIView!
    @IBOutlet weak var reply_view: UIView!
    
    
    //MARK: sticker
    @IBOutlet weak var sticker_view_container: UIView!
    @IBOutlet weak var sticker_view: UIView!
    @IBOutlet weak var image_sticker: UIImageView!
    
    //MARK: video
    @IBOutlet weak var video_view_container: UIView!
    @IBOutlet weak var video_view: UIView!
    @IBOutlet weak var image_video: UIImageView!
    
    
    //MARK: file
    
    @IBOutlet weak var file_view_container: UIView!
    @IBOutlet weak var file_view: UIView!
    @IBOutlet weak var lbl_path_extension: UILabel!
    @IBOutlet weak var lbl_file_name: UILabel!
    @IBOutlet weak var lbl_size_type_name: UILabel!
    
    
    //MARK: audio
    @IBOutlet weak var audio_view_container: UIView!
    @IBOutlet weak var audio_view: UIView!
    @IBOutlet weak var image_status_play_audio: UIImageView!
    @IBOutlet weak var image_animate_play_audio: UIImageView!
    @IBOutlet weak var lbl_time_audio: UILabel!
    
    //MARK: image
    
    @IBOutlet weak var image_view_container: UIView!
    @IBOutlet weak var image_view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var height_of_collectionView: NSLayoutConstraint!
    
    //MARK: reaction
    @IBOutlet weak var view_reaction: UIView!
    @IBOutlet weak var stack_view_reaction: UIStackView!

    
    @IBOutlet weak var view_status_message: UIView!
    @IBOutlet weak var image_status_message: UIImageView!
    @IBOutlet weak var lbl_status_message: UILabel!
    
    
    @IBOutlet weak var view_time: UIView!
    @IBOutlet weak var lbl_msg_time: UILabel!
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lbl_open_file: UILabel!
    
    var viewArray:[UIView] = []
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewArray = [msg_view,link_view,video_view,reply_view,sticker_view,file_view,image_view,audio_view]
        registerCollectionCell()
        let tapContentFullText = UITapGestureRecognizer(target: self, action: #selector(handleTapFullText))
        lbl_link_url.addGestureRecognizer(tapContentFullText)
        lbl_link_url.isUserInteractionEnabled = true
    }
    
    @objc func handleTapFullText(_ gesture: UITapGestureRecognizer) {
        guard let message = data, let viewModel = viewModel else { return }
        
        if message.message_type != .revoke_message {
            let point = gesture.location(in: lbl_link_url)
            
            guard let linkText = MediaUtils.getTappedLink(at: point, fullText: message.message, linkTexts: message.link, label: lbl_link_url) else {
                isTextExpanded.toggle()
                MediaUtils.readLessMoreLabelText(
                    fullText:message.message,
                    maxLength: 300,
                    label: lbl_link_url,
                    isTextExpanded: isTextExpanded,
                    linkTexts: message.link,
                    wordsToHighlight: []
                )
                viewModel.view?.tableView.beginUpdates()
                viewModel.view?.tableView.endUpdates()
                return
            }
            viewModel.makeWebLinkViewController(title: message.thumb.domain,link: linkText)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func actionSelectMedia(_ sender: Any) {
        guard let message = data, let viewModel = viewModel else { return }
        if let mediaFirst = message.media.first,
           message.message_type == .file && !fileExistsInDocumentsDirectory(fileName: mediaFirst.original.name) {
            handleDownLoadFile(dataMedia: mediaFirst)
        } else {
            viewModel.view?.handleSelectedMedia(message: message)
        }
    }


    var leading = NSLayoutConstraint()
    var trailing = NSLayoutConstraint()
    var width = NSLayoutConstraint()
    var isTextExpanded:Bool = false
    var isCollectionLoaded:Bool = false
    var viewModel:ChatChannelViewModel? = nil
    var isLastMessage:Bool = false
    var audioPlayerController:AudioPlayerController? = nil
    var data:MessageResponse? = nil{
        didSet {
            guard let message = data, let viewModel = viewModel else { return }
            mapMessage(message: message, viewModel: viewModel)
        }
    }
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()
    
}
