//
//  IntermetTouchView.swift
//  CungMua
//
//  Created by Tuan Le on 6/30/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
class InternetTouchView: UIView {

    var faceImageView = UIImageView()
    var view: UIView!
    @IBOutlet weak var btnReconnect:UIButton?
    @IBOutlet weak var lbTitle:UILabel?
    var touchTaget : AnyObject!
    var touchSelector : Selector!
    var touchObject : String = ""
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setTarget(_ delegate : AnyObject, selector : Selector, message : String){
        touchTaget = delegate
        touchSelector = selector
        lbTitle?.text = message
    }
    
    func setTargetWithObject(_ delegate : AnyObject, selector : Selector, object : String, message : String){
        touchTaget = delegate
        touchSelector = selector
        lbTitle?.text = message
        touchObject = object
    }
    
    func setup()
    {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "InternetTouchView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    @IBAction func Reconnect(_ sender: UIButton) {
        self.removeFromSuperview()
        if(self.touchTaget != nil){
            if(self.touchObject != ""){
                Timer.scheduledTimer(timeInterval: 0.0, target: self.touchTaget, selector: self.touchSelector, userInfo: ["Index" : self.touchObject], repeats: false)
            }else{
                Timer.scheduledTimer(timeInterval: 0.0, target: self.touchTaget, selector: self.touchSelector, userInfo: nil, repeats: false)
            }
        }
    }
}
