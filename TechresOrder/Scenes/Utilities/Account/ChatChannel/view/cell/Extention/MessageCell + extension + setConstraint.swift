//
//  MessageCell + extension + setConstraint.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/05/2024.
//

import UIKit

extension MessageCellTableViewCell {
    
    func setConstraint(view:UIView,message: MessageResponse,width_constant:CGFloat = 60){

        for element in viewArray{
        
            if let superview = element.superview{
                superview.removeConstraints(superview.constraints)
            }
            

            if element == view{
                if let superview = element.superview{
                    element.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        element.topAnchor.constraint(equalTo: superview.topAnchor),
                        element.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                        element.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                        element.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
                    ])
                }
            }
        }
        
        

        self.removeConstraints([leading,trailing,width])
        container_view.removeConstraints(container_view.constraints.filter{$0.firstAttribute == .leading || $0.firstAttribute == .trailing})
        content_view.translatesAutoresizingMaskIntoConstraints = false
        /*
            If messaageType is image
            we have to set it's relation to equal, otherwise set it's relation to greater Than or equal
            
            On the other hand, the constant for it's leading contraints is 60 rather than 120
         */
        switch message.message_type {
        case .image,.video:
                width = content_view.widthAnchor.constraint(equalToConstant: width_constant)
      
            default:
                width = content_view.widthAnchor.constraint(greaterThanOrEqualToConstant: width_constant)
        }
        
    
        if message.user.user_id == Constants.user.id{
    
            leading = NSLayoutConstraint(
                item: content_view as Any, attribute: .leading, relatedBy: .greaterThanOrEqual,
                toItem: container_view, attribute: .leading, multiplier: 1.0, constant: message.message_type == .image ? 8 : 40
            )
            
            trailing = NSLayoutConstraint(
                item: container_view as Any, attribute: .trailing, relatedBy: .equal,
                toItem: content_view, attribute: .trailing, multiplier: 1.0, constant: 5
            )
            
        
        }else{
   
            leading = NSLayoutConstraint(
                item: content_view as Any, attribute: .leading, relatedBy: .equal,
                toItem: container_view, attribute: .leading, multiplier: 1.0, constant: 0
            )
    
            trailing = NSLayoutConstraint(
                item: container_view as Any, attribute: .trailing, relatedBy: .greaterThanOrEqual,
                toItem: content_view, attribute: .trailing, multiplier: 1.0, constant: message.message_type == .image ? 8 : 40
            )
            
            
        }
        self.addConstraints([leading,trailing,width])
    }
}
