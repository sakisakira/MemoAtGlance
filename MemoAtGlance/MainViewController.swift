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
  
  var photoGrabber = PhotoGrabber()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
      // ToDo: 再読み込み
    }
    return cell
  }
  
  // UICollectionViewDelegate
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
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
