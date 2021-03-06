//
//  PathMenuItem.swift
//  PathMenu
//
//  Created by pixyzehn on 12/27/14.
//  Copyright (c) 2014 pixyzehn. All rights reserved.
//

import Foundation
import UIKit

protocol PathMenuItemDelegate:NSObjectProtocol {
    func PathMenuItemTouchesBegan(item: PathMenuItem)
    func PathMenuItemTouchesEnd(item:PathMenuItem)
}

class PathMenuItem: UIImageView {
    
    var contentImageView: UIImageView?
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    var nearPoint: CGPoint?
    var farPoint: CGPoint?
    
    weak var delegate: PathMenuItemDelegate!
    
    var _highlighted: Bool = false
    override var highlighted: Bool {
        get {
            return _highlighted
        }
        set {
            _highlighted = newValue
            self.contentImageView?.highlighted = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    convenience init(image:UIImage!, highlightedImage himg:UIImage?, contentImage cimg:UIImage?, highlightedContentImage hcimg:UIImage?) {
        self.init(frame: CGRectZero)
        self.image = image
        self.highlightedImage = himg
        self.userInteractionEnabled = true
        self.contentImageView = UIImageView(image: cimg)
        self.contentImageView?.highlightedImage = hcimg
        self.addSubview(self.contentImageView!)
    }

    private func ScaleRect(rect: CGRect, n: CGFloat) -> CGRect {
        let width = rect.size.width
        let height = rect.size.height
        return CGRectMake(CGFloat((width - width * n)/2), CGFloat((height - height * n)/2), CGFloat(width * n), CGFloat(height * n))
    }

    // UIView's methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = self.image {
            self.bounds = CGRectMake(0, 0, image.size.width, image.size.height)
        }
        
        if let imageView = self.contentImageView {
            let imgWidth: CGFloat! = imageView.image?.size.width
            let imgHeight: CGFloat! = imageView.image?.size.height
            imageView.frame = CGRectMake(self.bounds.size.width/2 - imgWidth/2, self.bounds.size.height/2 - imgHeight/2, imgWidth, imgHeight)
        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.highlighted = true
        if self.delegate.respondsToSelector("PathMenuItemTouchesBegan:") {
            self.delegate.PathMenuItemTouchesBegan(self)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touched = touches as NSSet
        let location:CGPoint? = touched.anyObject()?.locationInView(self)
        if let loc = location {
            if (!CGRectContainsPoint(ScaleRect(self.bounds, n: 2.0), loc))
            {
                self.highlighted = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.highlighted = false
        let touched = touches as NSSet
        let location: CGPoint? = touched.anyObject()?.locationInView(self)
        if let loc = location {
            if (CGRectContainsPoint(ScaleRect(self.bounds, n: 2.0), loc))
            {
                self.delegate.PathMenuItemTouchesEnd(self)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent!) {
        self.highlighted = false
    }
    
}
