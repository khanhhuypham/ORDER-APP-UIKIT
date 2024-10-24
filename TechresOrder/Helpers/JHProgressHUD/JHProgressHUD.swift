//
//  JHProgressHUD.swift
//  JHProgressHUD
//
//  Created by Harikrishnan on 02/12/14.
//  Copyright (c) 2014 Harikrishnan T. All rights reserved.
//

import UIKit

class JHProgressHUD: UIView
{
    
//    private static var __once: () = {
//        Static.instance = JHProgressHUD()
//    }()
//
    fileprivate var backGroundView : UIView?
    fileprivate var progressIndicator : UIActivityIndicatorView?
    fileprivate var titleLabel : UILabel?
    fileprivate var footerLabel : UILabel?
    
    var headerColor : UIColor
    var footerColor : UIColor
    var backGroundColor : UIColor
    var loaderColor : UIColor
    let activityIndicator: LTActivityIndicatorView
    var isShow:Bool = false
   static let sharedHUD : JHProgressHUD =  { JHProgressHUD()}()
    
    init()
    {
        //Initialising Code
        headerColor = UIColor.white
        footerColor = UIColor.white
        backGroundColor = UIColor.black
        loaderColor = UIColor.white
        activityIndicator = LTActivityIndicatorView(frame: CGRect(x: 30, y: 30, width: 0, height: 0))
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        headerColor = UIColor.white
        footerColor = UIColor.white
        backGroundColor = UIColor.black
        loaderColor = UIColor.white
        activityIndicator = LTActivityIndicatorView(frame: CGRect(x: 25, y: 25, width: 0, height: 0))
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        headerColor = UIColor.white
        footerColor = UIColor.white
        backGroundColor = UIColor.black
        loaderColor = UIColor.white
        activityIndicator = LTActivityIndicatorView(frame: CGRect(x: 25, y: 25, width: 0, height: 0))
        super.init(frame: frame)
    }
    
    // MARK: -Public Methods
    
    // Show the loader added to the mentioned view with the provided title and footer texts
    func showInView(_ view : UIView, withHeader title : String?, andFooter footer : String?)
    {
        self.hide()
        self.frame = view.frame
        activityIndicator.backgroundColor = UIColor.clear
        activityIndicator.isOpaque = true;
        
        
        activityIndicator.setSteps(16)
        activityIndicator.setFinSize(CGSize(width: 8, height: 16))
        activityIndicator.setIndicatorRadius(25)
        activityIndicator.stepDuration = 0.03;
        activityIndicator.color = ColorUtils.toolbar()//UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        //activityIndicator.color = UIColor(red: 0, green: 34.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        activityIndicator.cornerRadii = CGSize(width: 5, height: 5)
        
        activityIndicator.startAnimating()
        
        let loading = UIImageView()
        let imageLoading = UIImage(named: "logo_loading1.png")
        loading.frame = CGRect(x: activityIndicator.frame.size.width/2, y: activityIndicator.frame.size.height/2, width: 30, height: 30)
        loading.image = imageLoading
        loading.center = CGPoint(x: activityIndicator.frame.size.width/2, y: activityIndicator.frame.size.height/2);
        loading.tintColor = ColorUtils.orange_brand_900()
        activityIndicator.addSubview(loading)
        self.addSubview(activityIndicator)
        
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.size.width/2 , y: UIScreen.main.bounds.size.height/2 );
        debugPrint(UIScreen.main.bounds.size.height, terminator: "")
        activityIndicator.setNeedsDisplay()
        
        view.addSubview(self)
    }
    
    // Show the loader added to the mentioned window with the provided title and footer texts
    func showInWindow(_ window : UIWindow, withHeader title : String?, andFooter footer : String?)
    {
        self.showInView(window, withHeader: title, andFooter: footer)
    }
    
    // Show the loader added to the mentioned view with no title and footer texts
    func showInView(_ view : UIView)
    {
        self.showInView(view, withHeader: nil, andFooter: nil)
        self.isShow = true
    }
    
    // Show the loader added to the mentioned window with no title and footer texts
    func showInWindow(_ window : UIWindow)
    {
        self.showInView(window, withHeader: nil, andFooter: nil)
    }
    
    // Removes the loader from its superview
    func hide()
    {
        self.isShow = false
        if self.superview != nil
        {
            self.removeFromSuperview()
            progressIndicator?.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    // MARK: -Set view properties
    
    fileprivate func setBackGround(_ view : UIView)
    {
        if backGroundView?.superview != nil
        {
            backGroundView?.removeFromSuperview()
            let aView = backGroundView?.viewWithTag(1001) as UIView?
            aView?.removeFromSuperview()
        }
        backGroundView = UIView(frame: getBackGroundFrame(self))
        backGroundView?.backgroundColor = UIColor.clear
        let translucentView = UIView(frame: backGroundView!.bounds)
        translucentView.backgroundColor = backGroundColor
        translucentView.alpha = 0.85
        translucentView.tag = 1001;
        translucentView.layer.cornerRadius = 15.0
        backGroundView?.addSubview(translucentView)
        backGroundView?.layer.cornerRadius = 15.0
        self.addSubview(backGroundView!)
    }
    
    fileprivate func setIndicator()
    {
        if progressIndicator?.superview != nil
        {
            progressIndicator?.removeFromSuperview()
        }
        progressIndicator = UIActivityIndicatorView(style: .whiteLarge)
        progressIndicator?.style = UIActivityIndicatorView.Style.whiteLarge
        progressIndicator?.color = loaderColor
        progressIndicator?.backgroundColor = UIColor.clear
        progressIndicator?.startAnimating()
    }
    
    fileprivate func setTitleLabel(_ text : String)
    {
        if titleLabel?.superview != nil
        {
            titleLabel?.removeFromSuperview()
        }
        titleLabel = UILabel()
        titleLabel?.text = text
        titleLabel?.font = self.boldFontWithFont(titleLabel?.font)
        titleLabel?.textColor = headerColor
        titleLabel?.textAlignment = .center
    }
    
    fileprivate func setFooterLabel(_ text : String)
    {
        if footerLabel?.superview != nil
        {
            footerLabel?.removeFromSuperview()
        }
        footerLabel = UILabel()
        footerLabel?.text = text
        footerLabel?.textColor = footerColor
        footerLabel?.textAlignment = .center
    }
    
    // MARK: -Get Frame
    
    fileprivate func getBackGroundFrame(_ view : UIView) -> CGRect
    {
        var side = progressIndicator!.frame.height
        if titleLabel?.text != nil && titleLabel?.text != ""
        {
            side = progressIndicator!.frame.height + titleLabel!.frame.width
        }
        else if (footerLabel?.text != nil && footerLabel?.text != "")
        {
            side = progressIndicator!.frame.height + footerLabel!.frame.width
        }
        let originX = view.center.x - (side/2)
        let originY = view.center.y - (side/2)
        return CGRect(x: originX, y: originY, width: side, height: side)
    }
    
    // MARK: Get Size
    
    fileprivate func getLabelSize() -> CGSize
    {
        let width = progressIndicator!.frame.width * 3
        let height = progressIndicator!.frame.height / 1.5
        return CGSize(width: width, height: height)
    }
    
    // MARK: -Get Origin
    
    fileprivate func getIndicatorOrigin(_ view : UIView, activityIndicatorView indicator : UIActivityIndicatorView) -> CGPoint
    {
        let side = indicator.frame.size.height
        let originX = (view.bounds.width/2) - (side/2)
        let originY = (view.bounds.height/2) - (side/2)
        return CGPoint(x: originX, y: originY)
    }
    
    fileprivate func getHeaderOrigin(_ view : UIView) -> CGPoint
    {
        let width = titleLabel!.frame.size.width
        let originX = (view.bounds.width/2) - (width/2)
        return CGPoint(x: originX, y: 1)
    }
    
    fileprivate func getFooterOrigin(_ view : UIView) -> CGPoint
    {
        let width = footerLabel!.frame.width
        let height = footerLabel!.frame.height
        let originX = (view.bounds.width/2) - (width/2)
        let originY = view.frame.height - (height + 1)
        return CGPoint(x: originX, y: originY)
    }
    
    // MARK: -Set Font
    func boldFontWithFont(_ font : UIFont?) -> UIFont
    {
        let fontDescriptor : UIFontDescriptor = font!.fontDescriptor.withSymbolicTraits(.traitBold)!
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect)
     {
     // Drawing code
     }
     */
    
}
