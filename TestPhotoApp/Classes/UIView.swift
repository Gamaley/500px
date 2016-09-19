//
//  UIView.swift
//  TestPhotoApp
//
//  Created by Vladyslav Gamalii on 19.09.16.
//  Copyright © 2016 Vladyslav Gamalii. All rights reserved.
//

import UIKit

extension UIView {
    
    func addGradientWithFrame(frame: CGRect, color: UIColor) {
        addGradiend(nil, startColor: color, endColor: UIColor.clearColor(), startPoint: CGPointMake(0.5, 1.0), endPoint: CGPointMake(0.5, 0.4))
    }
    func removeAllGradients() {
        guard let sublayers = layer.sublayers else { return }
        for subLayer in sublayers {
            if subLayer is CAGradientLayer {
                subLayer.removeFromSuperlayer()
            }
        }
    }
   private func addGradiend(rect: CGRect?, startColor: UIColor, endColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient : CAGradientLayer = CAGradientLayer()
        if let rect = rect {
            gradient.frame = rect
        } else {
            gradient.frame = bounds
        }
        gradient.colors = [startColor.CGColor, endColor.CGColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        layer.addSublayer(gradient)
    }
    
}
