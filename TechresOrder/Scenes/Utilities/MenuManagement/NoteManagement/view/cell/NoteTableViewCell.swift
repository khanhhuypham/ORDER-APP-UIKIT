//
//  NoteTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 24/01/2023.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var note_avatar: UIImageView!
    
    @IBOutlet weak var lbl_view_trailling_scroll: UIView! // View color trailling scroll
    
    @IBOutlet weak var lbl_note: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbl_view_trailling_scroll.roundCorners(corners: [.topLeft,.bottomLeft], radius: CGFloat(6)) // set corrorradius
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var viewModel: NoteManagementViewModel? {
           didSet {
              
               
           }
    }
    
    // MARK: - Variable -
    public var data: Note? = nil {
        didSet {
            lbl_note.text = data?.content
            
        }
    }
    
}
