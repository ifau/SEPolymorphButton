//
//  SEPolymorphButton.swift
//  PolymorphButton
//
//  https://github.com/ifau/SEPolymorphButton
//
//  Created by Seliverstov Evgeney on 13/07/15.
//  Copyright (c) 2015 Seliverstov Evgeney. All rights reserved.
//

import UIKit

class SEPolymorphButton: UIControl
{
    private var outlanePath : CAShapeLayer!
    private var gradientLayer : CAGradientLayer?
    private var vibrancyView : UIVisualEffectView?
    private var isAnimating : Bool = false
    private(set) var currentStyle : SEPolymorphButtonStyle!
    
    enum SEPolymorphButtonStyleEmoji
    {
        case 🌕, 💛, 💜, 💚, 💙, 💗, 🌟
    }
    
    enum SEPolymorphButtonStyle
    {
        case circleStyle, heartStyle, starStyle
    }
    
    var margins : Float = 0
    {
        didSet
        {
            outlanePath.frame = getCenteredFrame(margins: margins)
            changeStyle(currentStyle)
        }
    }
    
    var lineWidth : Float = 1
    {
        didSet
        {
            outlanePath.lineWidth = CGFloat(lineWidth)
        }
    }
    
    var strokeColor : UIColor = UIColor.blackColor()
    {
        didSet
        {
            outlanePath.strokeColor = strokeColor.CGColor
        }
    }
    
    var fillColor : UIColor = UIColor.clearColor()
    {
        didSet
        {
            outlanePath.fillColor = fillColor.CGColor
        }
    }
    
    var gradientColors : [UIColor]?
    {
        didSet
        {
            if gradientColors != nil
            {
                if gradientLayer == nil
                {
                    gradientLayer = CAGradientLayer()
                    gradientLayer!.frame = self.bounds
                    gradientLayer!.mask = outlanePath
                    self.layer.addSublayer(gradientLayer!)
                }
                
                var cgGradientColors : [CGColorRef] = []
                for color in gradientColors!
                {
                    cgGradientColors.append(color.CGColor)
                }
                gradientLayer!.colors = cgGradientColors
            }
            else if gradientLayer != nil
            {
                gradientLayer!.removeFromSuperlayer()
                gradientLayer = nil
                vibrancyView == nil ? self.layer.addSublayer(outlanePath) : vibrancyView!.contentView.layer.addSublayer(outlanePath)
            }
        }
    }
    
    var vibrancyForBlurEffectStyle : UIBlurEffectStyle?
    {
        didSet
        {
            let effect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: vibrancyForBlurEffectStyle!))
            if vibrancyView != nil
            {
                outlanePath.removeFromSuperlayer()
                vibrancyView!.removeFromSuperview()
            }
            
            if gradientLayer != nil
            {
                gradientLayer!.removeFromSuperlayer()
            }
            
            vibrancyView = UIVisualEffectView(effect: effect)
            vibrancyView!.frame = self.bounds
            self.addSubview(vibrancyView!)
            vibrancyView!.contentView.layer.addSublayer(outlanePath)
        }
    }
    
    var defaultOpacity : Float = 0.7
    {
        didSet
        {
            outlanePath.opacity = defaultOpacity
        }
    }
    
    var highlightedOpacity : Float = 1.0
    var highlightedFillColor : UIColor = UIColor.clearColor()
    
    override var highlighted : Bool
    {
        willSet(newValue)
        {
            if newValue
            {
                changeLayerOpacity(outlanePath, toValue: CGFloat(highlightedOpacity), animationDuration: 0.3)
                changeLayerFillColor(outlanePath, toValue: highlightedFillColor.CGColor, animationDuration: 0.3)
            }
            else
            {
                changeLayerOpacity(outlanePath, toValue: CGFloat(defaultOpacity), animationDuration: 0.3)
                changeLayerFillColor(outlanePath, toValue: fillColor.CGColor, animationDuration: 0.3)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect, vibrancyForBlurEffectStyle: UIBlurEffectStyle)
    {
        super.init(frame: frame)
        
        let effect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: vibrancyForBlurEffectStyle))
        vibrancyView = UIVisualEffectView(effect: effect)
        vibrancyView!.frame = self.bounds
        self.addSubview(vibrancyView!)
        
        setup()
    }
    
    private func setup()
    {
        self.backgroundColor = UIColor.clearColor()
        
        outlanePath = CAShapeLayer()
        outlanePath.frame = getCenteredFrame(margins: margins)
        outlanePath.strokeColor = strokeColor.CGColor
        outlanePath.fillColor = fillColor.CGColor
        outlanePath.backgroundColor = UIColor.clearColor().CGColor
        outlanePath.lineWidth = CGFloat(lineWidth)
        outlanePath.opacity = defaultOpacity

        vibrancyView == nil ? self.layer.addSublayer(outlanePath) : vibrancyView!.contentView.layer.addSublayer(outlanePath)
        changeStyle(.circleStyle)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent: event)
        
        if !isAnimating
        {
            highlighted = true
            self.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesEnded(touches, withEvent: event)
        
        highlighted = false
    }
    
    func changeStyle(style: SEPolymorphButtonStyleEmoji)
    {
        changeStyle(style, animationDuration: 0)
    }
    
    func changeStyle(style: SEPolymorphButtonStyleEmoji, animationDuration: NSTimeInterval)
    {
        switch style
        {
            case .🌕:
                changeStyle(.circleStyle, animationDuration: animationDuration)
            case .💛, .💜, .💚, .💙, .💗:
                changeStyle(.heartStyle, animationDuration: animationDuration)
            case .🌟:
                changeStyle(.starStyle, animationDuration: animationDuration)
        }
    }
    
    func changeStyle(style: SEPolymorphButtonStyle)
    {
        changeStyle(style, animationDuration: 0)
    }
    
    func changeStyle(style: SEPolymorphButtonStyle, animationDuration: NSTimeInterval)
    {
        var finalPath : UIBezierPath
        switch style
        {
            case .circleStyle:
                finalPath = getCirclePath(outlanePath.frame)
            case .heartStyle:
                finalPath = getHeartPath(outlanePath.frame)
            case .starStyle:
                finalPath = getStarPath(outlanePath.frame)
        }
        
        transformLayerPath(outlanePath, finalPath: finalPath.CGPath, animationDuration: animationDuration)
        currentStyle = style
    }
    
    private func transformLayerPath(layer: CAShapeLayer, finalPath: CGPathRef, animationDuration: CFTimeInterval)
    {
        let originalPath = layer.path
        layer.path = finalPath
        
        if animationDuration > 0
        {
            let animation = CABasicAnimation(keyPath: "path")
            
            animation.fromValue = originalPath
            animation.toValue = finalPath
            animation.duration = animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            animation.delegate = self
            
            layer.addAnimation(animation, forKey: animation.keyPath)
            isAnimating = true
        }
    }
    
    private func changeLayerOpacity(layer: CAShapeLayer, toValue: CGFloat, animationDuration: CFTimeInterval)
    {
        let originalValue = layer.opacity
        layer.opacity = Float(toValue)
        
        if animationDuration > 0
        {
            let animation = CABasicAnimation(keyPath: "opacity")
            
            animation.fromValue = originalValue
            animation.toValue = toValue
            animation.duration = animationDuration
            animation.delegate = self
            
            layer.addAnimation(animation, forKey: animation.keyPath)
            isAnimating = true
        }
    }
    
    private func changeLayerFillColor(layer: CAShapeLayer, toValue: CGColorRef, animationDuration: CFTimeInterval)
    {
        let originalValue = layer.fillColor
        layer.fillColor = toValue
        
        if animationDuration > 0
        {
            let animation = CABasicAnimation(keyPath: "fillColor")
            
            animation.fromValue = originalValue
            animation.toValue = toValue
            animation.duration = animationDuration
            animation.delegate = self
            
            layer.addAnimation(animation, forKey: animation.keyPath)
            isAnimating = true
        }
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool)
    {
        isAnimating = false
    }
    
    func applicationDidEnterBackground()
    {
        outlanePath.removeAllAnimations()
        isAnimating = false
    }
    
    private func getCenteredFrame(margins margins: Float) -> CGRect
    {
        let frame : CGRect
        let offset = CGFloat(margins)
        
        if self.frame.size.width >= self.frame.height
        {
            let x : CGFloat = (self.frame.size.width - self.frame.height) / 2
            let y : CGFloat = 0
            frame = CGRect(x: x + offset, y: y + offset, width: self.frame.height - offset*2, height: self.frame.height - offset*2)
        }
        else
        {
            let x : CGFloat = 0
            let y : CGFloat = (self.frame.height - self.frame.size.width) / 2
            frame = CGRect(x: x + offset, y: y + offset, width: self.frame.size.width - offset*2, height: self.frame.size.width - offset*2)
        }
        
        return frame
    }
    
    private func getHeartPath(frame: CGRect) -> UIBezierPath
    {
        let d : CGFloat = min(frame.size.height, frame.size.width)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(d*0.9572, d*0.2701))
        path.addCurveToPoint(CGPointMake(d*0.5, d*0.2387), controlPoint1: CGPointMake(d*0.9006, d*0.1151), controlPoint2: CGPointMake(d*0.6378, d*0.0323))
        path.addCurveToPoint(CGPointMake(d*0.0427, d*0.2701), controlPoint1: CGPointMake(d*0.3621, d*0.0323), controlPoint2: CGPointMake(d*0.0993, d*0.1151))
        path.addCurveToPoint(CGPointMake(d*0.1947, d*0.6767), controlPoint1: CGPointMake(-d*0.0139, d*0.4253), controlPoint2: CGPointMake(d*0.0326, d*0.5157))
        path.addCurveToPoint(CGPointMake(d*0.4999, d*0.8843), controlPoint1: CGPointMake(d*0.3563, d*0.8373), controlPoint2: CGPointMake(d*0.4992, d*0.884))
        path.addCurveToPoint(CGPointMake(d*0.5, d*0.8843), controlPoint1: CGPointMake(d*0.5, d*0.8843), controlPoint2: CGPointMake(d*0.5, d*0.8843))
        path.addCurveToPoint(CGPointMake(d*0.8052, d*0.6767), controlPoint1: CGPointMake(d*0.5007, d*0.884), controlPoint2: CGPointMake(d*0.6436, d*0.8373))
        path.addCurveToPoint(CGPointMake(d*0.9572, d*0.2701), controlPoint1: CGPointMake(d*0.9672, d*0.5157), controlPoint2: CGPointMake(d*1.0139, d*0.4253))
        path.closePath()
        
        return path
    }
    
    private func getCirclePath(frame: CGRect) -> UIBezierPath
    {
        let d : CGFloat = min(frame.size.height, frame.size.width)
        
        let path = UIBezierPath(ovalInRect: CGRectMake(d*0.1, d*0.1, d*0.8, d*0.8))
        
        return path.bezierPathByReversingPath()
    }
    
    private func getStarPath(frame: CGRect) -> UIBezierPath
    {
        let d : CGFloat = min(frame.size.height, frame.size.width)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(d*0.5014, d*0.0428))
        path.addLineToPoint(CGPointMake(d*0.6485, d*0.3411))
        path.addLineToPoint(CGPointMake(d*0.9776, d*0.3888))
        path.addLineToPoint(CGPointMake(d*0.7394, d*0.6209))
        path.addLineToPoint(CGPointMake(d*0.7957, d*0.9486))
        path.addLineToPoint(CGPointMake(d*0.5014, d*0.7938))
        path.addLineToPoint(CGPointMake(d*0.2070, d*0.9486))
        path.addLineToPoint(CGPointMake(d*0.2634, d*0.6209))
        path.addLineToPoint(CGPointMake(d*0.0252, d*0.3888))
        path.addLineToPoint(CGPointMake(d*0.3543, d*0.3411))
        path.closePath()
        
        return path.bezierPathByReversingPath()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
