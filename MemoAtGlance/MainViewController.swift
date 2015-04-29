//
//  ViewController.swift
//  MemoAtGlance
//
//  Created by sakira on 2015/04/23.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import UIKit

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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
//    collectionView.reloadData()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1,
      target: collectionView,
      selector: "reloadData",
      userInfo: nil,
      repeats: true)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    timer?.invalidate()
    timer = nil
  }

  // UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    photoGrabber.grabRecentPhotos()
    return photoGrabber.filenamesSorted.count
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
