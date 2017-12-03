//
//  AnimationClass.swift
//  testApplicationCalendar
//
//  Created by JayT on 2016-03-06.
//  Copyright © 2016 OS-Tech. All rights reserved.
//

import UIKit

extension UIView {
    enum FoldDirection {
        case open, closed
    }
    
    func fold(withTransparency: Bool, completionHandler:(()->Void)?, inDirection: FoldDirection ) {
        let topAndBottomView = self.prepareSplitImage()
        let topHalfView = topAndBottomView[0]
        let bottomHalfView = topAndBottomView[1]
        
        let animationContainer = UIView(frame: self.bounds)
        let originalBackgroundColor = self.backgroundColor
        if (withTransparency) {
            animationContainer.backgroundColor = UIColor.clear
            self.backgroundColor = UIColor.clear
            for subview in self.subviews {
                subview.isHidden = true
            }
        } else {
            animationContainer.backgroundColor = UIColor.black
        }
        
        self.addSubview(animationContainer)
        animationContainer.addSubview(topHalfView)
        animationContainer.addSubview(bottomHalfView)
        
        var startingTransform = CATransform3DIdentity
        startingTransform.m34 = -1 / 500
        
        let startingFrame = CGRect(x: 0,
                                   y: -topHalfView.frame.size.height / 2,
                                   width: topHalfView.frame.size.width,
                                   height: topHalfView.frame.size.height)
        
        topHalfView.frame = startingFrame
        bottomHalfView.frame = startingFrame
        
        
        topHalfView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        bottomHalfView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        topHalfView.layer.transform = startingTransform;
        bottomHalfView.layer.transform = startingTransform;
        
        let topShadowLayer = CAGradientLayer()
        topShadowLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        topShadowLayer.frame = topHalfView.bounds
        topHalfView.layer.addSublayer(topShadowLayer)
        
        let bottomShadowLayer = CAGradientLayer()
        bottomShadowLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        bottomShadowLayer.frame = bottomHalfView.bounds
        bottomHalfView.layer.addSublayer(bottomShadowLayer)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        
        CATransaction.setCompletionBlock { 
            self.backgroundColor = originalBackgroundColor
            
            if (withTransparency) {
                for subview in self.subviews {
                    subview.isHidden = false
                }
            }
            
            animationContainer.removeFromSuperview()
            completionHandler?()
        }
        
        
        
        let topRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        topRotationAnimation.fillMode = kCAFillModeForwards
        topRotationAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            topRotationAnimation.fromValue = -(.pi / 2.0)
            topRotationAnimation.toValue = 0
            break;
        case .closed:
            topRotationAnimation.fromValue = 0
            topRotationAnimation.toValue = -(.pi / 2.0)
        }
        
        topHalfView.layer.add(topRotationAnimation, forKey:nil)
        
        
        let bottomRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        bottomRotationAnimation.fillMode = kCAFillModeForwards;
        bottomRotationAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            bottomRotationAnimation.fromValue = (.pi / 2.0)
            bottomRotationAnimation.toValue = 0
            break;
        case .closed:
            bottomRotationAnimation.fromValue = 0
            bottomRotationAnimation.toValue = (.pi / 2.0)
        }
        bottomHalfView.layer.add(bottomRotationAnimation, forKey:nil)
        
        let bottomTranslationAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        bottomTranslationAnimation.fillMode = kCAFillModeForwards
        bottomTranslationAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            bottomTranslationAnimation.fromValue = topHalfView.frame.minY
            bottomTranslationAnimation.toValue = 2 * bottomHalfView.frame.size.height
            bottomTranslationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            break;
        case .closed:
            bottomTranslationAnimation.fromValue = 2 * bottomHalfView.frame.size.height
            bottomTranslationAnimation.toValue = topHalfView.frame.minY
            bottomTranslationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        }
        
        //TODO: figure out a more precise timing function
        bottomHalfView.layer.add(bottomTranslationAnimation, forKey:nil)
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false
        switch (inDirection) {
        case .open:
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.0
            break;
        case .closed:
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
        }
        
        topShadowLayer.add(opacityAnimation, forKey: nil)
        bottomShadowLayer.add(opacityAnimation, forKey: nil)
        
        CATransaction.commit()
    }
    
    func prepareSplitImage() -> [UIImageView] {
        
        
        let topImageFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: floor(self.frame.size.height / 2.0))
        let bottomImageFrame = CGRect(x: 0, y: topImageFrame.maxY, width: self.frame.size.width, height: ceil(self.frame.size.height / 2))

        UIGraphicsBeginImageContext(self.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)

        let fullViewImage = UIGraphicsGetImageFromCurrentImageContext()!
        var imageRef = fullViewImage.cgImage!.cropping(to: topImageFrame)!
        let topHalf = UIImage(cgImage: imageRef)
        
        imageRef = fullViewImage.cgImage!.cropping(to: bottomImageFrame)!
        let bottomHalf = UIImage(cgImage: imageRef)

        
        UIGraphicsEndImageContext();
        
        let topHalfView = UIImageView(image: topHalf)
        topHalfView.frame = topImageFrame
        
        let bottomHalfView = UIImageView(image: bottomHalf)
        bottomHalfView.frame = bottomImageFrame
        
        return [topHalfView, bottomHalfView]
    }
}

class AnimationClass {
    

    class func BounceEffect() -> (UIView, @escaping (Bool) -> Void) -> () {

        return {
            view, completion in
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(
                withDuration: 0.5,
                delay: 0, usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.1,
                options: UIViewAnimationOptions.beginFromCurrentState,
                animations: {
                    view.transform = CGAffineTransform(scaleX: 1, y: 1)
                },
                completion: completion
            )
        }

    }

    class func fadeOutEffect() -> (UIView, @escaping (Bool) -> Void) -> () {

        return {
            view, completion in
            UIView.animate(withDuration: 0.6,
                           delay: 0, usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                                view.alpha = 0
                            },
                           completion: completion)
        }

    }

    fileprivate class func get3DTransformation(_ angle: Double) ->
                                                            CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform,
                                CGFloat(angle * .pi / 180.0), 0, 1, 0.0)
        return transform
    }

    class func flipAnimation(_ view: UIView, completion: (() -> Void)?) {
        let angle = 180.0
        view.layer.transform = get3DTransformation(angle)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: { () -> Void in
                            view.layer.transform = CATransform3DIdentity
                        }) { (finished) -> Void in
                            completion?()
        }
    }

}
