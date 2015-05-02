//
//  ViewController.swift
//  MemoAtGlance
//
//  Created by sakira on 2015/04/23.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import UIKit
import AssetsLibrary

class MainViewController: UIViewController,
  UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var collectionView: UICollectionView!
  var timer: NSTimer?
  
  var photoGrabber = PhotoGrabber()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
//    collectionView.reloadData()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(5,
      target: collectionView,
      selector: "reloadData",
      userInfo: nil,
      repeats: true)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    timer?.invalidate()
    timer = nil
  }
  
  // UICollectionViewDataSource
  var alertController: UIAlertController?
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch ALAssetsLibrary.authorizationStatus() {
    case .NotDetermined, .Authorized:
      //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
      self.photoGrabber.grabRecentPhotos()
      //    })
      return photoGrabber.filenamesSorted.count
    case .Restricted, .Denied:
      if alertController == nil {
        alertController = UIAlertController(title: "Photo Album Accessing",
          message: "Please allow accessing to your Photo Album.",
          preferredStyle: .Alert)
        alertController?.addAction(
          UIAlertAction(title: "OK",
            style: .Default,
            handler: {action in self.alertController = nil}))
        presentViewController(alertController!,
          animated: true,
          completion: nil)
      }
        return 0
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MainCell", forIndexPath: indexPath) as! MainCell
    let fn = photoGrabber.filenamesSorted[indexPath.row]
    if let image = ImageOfFilename(fn) {
      cell.imageView.image = image
    } else {
      NSTimer.scheduledTimerWithTimeInterval(1, target: collectionView, selector: "reloadData", userInfo: nil, repeats: false)
    }
    return cell
  }
  
  // UICollectionViewDelegate
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let index = indexPath.row
    if let image = (collectionView.cellForItemAtIndexPath(indexPath) as? MainCell)?.imageView.image {
      if let vc = storyboard?.instantiateViewControllerWithIdentifier("ImageEditorViewController") as? ImageEditorViewController {
        let fn = photoGrabber.filenamesSorted[index]
        vc.image = image
        vc.imageUrl = FileURLOfFilename(fn)
        presentViewController(vc, animated: true, completion: nil)
      }
    }
  }
  

}

class MainCell : UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
}
