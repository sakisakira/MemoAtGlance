//
//  DrawingView.swift
//  DrawingTest
//
//  Created by sakira on 2015/04/21.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import UIKit

class DrawingView : UIView {
  var canvas: UIImage = UIImage()
  var penColor: UIColor = UIColor.redColor()
  let penWidth: CGFloat = 5
  var image : UIImage {
    get {
      return canvas
    }
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    NSLog("DrawingView init(frame:)")
    
    self.opaque = false
    self.backgroundColor = UIColor.clearColor()
    
    canvas = clearImageOfSize(frame.size)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    NSLog("DrawingView init(coder:)")

    self.opaque = false
    self.backgroundColor = UIColor.clearColor()
    
    canvas = clearImageOfSize(frame.size)
  }
  
  private func clearImageOfSize(size: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clearColor().set()
    UIRectFill(CGRectMake(0, 0, size.width, size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  var initialDrawRect = true
  override func drawRect(rect: CGRect) {
//    NSLog("DrawingView drawRect()")
    if initialDrawRect {
      UIColor.clearColor().set()
      UIRectFill(self.frame)
      initialDrawRect = false
    }
    
    let image = imageOfCanvas(rect)
    image.drawInRect(rect)
  }
  
  private func imageOfCanvas(rect :CGRect) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    let opt = rect.origin
    canvas.drawAtPoint(CGPointMake(-opt.x, -opt.y))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  private func imageDrawnLine(image: UIImage,
    fromPoint pt0: CGPoint, toPoint pt1: CGPoint) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
    image.drawAtPoint(CGPointZero)
    let path = UIBezierPath()
    path.moveToPoint(pt0)
    path.addLineToPoint(pt1)
    path.lineWidth = penWidth
    path.lineCapStyle = kCGLineCapRound
    penColor.setStroke()
    path.stroke()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//    NSLog("touchesBegan")
  }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
//    NSLog("touchesMoved")
    let t = touches.first as! UITouch
    let pt0 = t.previousLocationInView(self)
    let pt1 = t.locationInView(self)
    
    canvas = imageDrawnLine(canvas, fromPoint: pt0, toPoint: pt1)
    
    let pen_rect = CGRectMake(-penWidth, -penWidth, penWidth * 2, penWidth * 2)
    let rect0 = CGRectOffset(pen_rect, pt0.x, pt0.y)
    let rect1 = CGRectOffset(pen_rect, pt1.x, pt1.y)
    let rect = CGRectUnion(rect0, rect1)
    self.setNeedsDisplayInRect(rect)
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
//    NSLog("touchesEnded")
  }
}