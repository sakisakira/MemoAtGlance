//
//  ImageEditorViewController.swift
//  MemoAtGlance
//
//  Created by sakira on 2015/04/26.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import UIKit

class ImageEditorViewController: UIViewController {
  @IBOutlet weak var photoView: UIImageView!
  @IBOutlet weak var drawingView: DrawingView!
  var image: UIImage?
  var imageUrl: NSURL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    photoView.image = self.image
  }
  
  @IBAction func colorButtonPressed(sender: UIButton) {
    if let col = sender.titleColorForState(.Normal) {
      drawingView.penColor = col
    }
  }
  
  @IBAction func doneButtonPressed(sender: UIButton) {
    if let url = imageUrl {
      if let img0 = photoView.image {
        let img = composeImages(img0, drawingView.image)
        if let png = UIImagePNGRepresentation(img) {
          png.writeToURL(url, atomically: true)
          markUpdateFlag(url)
          if let vc = self.presentingViewController as? MainViewController {
            vc.collectionView.reloadData()
          }
        }
      }
    }
    dismissViewControllerAnimated(true, completion: {
    })
  }
  
  private func composeImages(img0: UIImage, _ img1: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(img0.size, false, 0)
    img0.drawAtPoint(CGPointZero)
    img1.drawAtPoint(CGPointZero)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }
  
  private func markUpdateFlag(url: NSURL?) {
    if let fn = url?.pathComponents?.last as? String {
      let defs = NSUserDefaults(suiteName: AppGroupID)
      var fns = defs?.stringArrayForKey(Key_UpdatedFilenames) ?? [] as [String]
      fns.append(fn)
      defs?.setObject(fns, forKey: Key_UpdatedFilenames)
    }
  }
  
  @IBAction func cancelButtonPressed(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}