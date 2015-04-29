//
//  PhotoFetcher.swift
//  PhotoAtGlance
//
//  Created by Akira Suzuki on 2015/04/14.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import Photos

class PhotoGrabber {
  var filenamesSorted = [] as [String]
  
  init() {
    createImageDirectory()
  }
  
  // do not call this func. from WatchKit Extension
  func grabRecentPhotos()  {
    var new_dates = [] as [NSDate]
    
    let fetch_opt = PHFetchOptions()
    fetch_opt.sortDescriptors =
      [NSSortDescriptor(key: "creationDate", ascending: false)]
    let assets = PHAsset.fetchAssetsWithMediaType(.Image, options: fetch_opt)
    
    let req_opt = PHImageRequestOptions()
    req_opt.synchronous = true
    req_opt.deliveryMode = .HighQualityFormat
    
    let manager = PHImageManager()
    assets.enumerateObjectsUsingBlock {
      (asset, index, stop) -> Void in
      let date = asset.creationDate as NSDate
      self.touchImageFile(ofDate: date)
      manager.requestImageForAsset(asset as! PHAsset,
        targetSize: ImageSize,
        contentMode: PHImageContentMode.AspectFill,
        options: req_opt, resultHandler:
        {(image, info) in
          NSLog("found photo at \(date)")
          if !ImageExistsOfDate(date) {
            self.savePhoto(self.resizeImage(image), forDate: date)
          }
          new_dates.append(date)
      })
      if index >= MaxNumberOfImages {
        stop.initialize(true)
      }
    }
    
    removeFilesExceptOf(new_dates)
    filenamesSorted = FilenamesSortedForImages()
    NSLog("filenames = \(filenamesSorted)")
  }
  
  private func createImageDirectory() {
    let fm = NSFileManager.defaultManager()
    if let dir_url = fm.containerURLForSecurityApplicationGroupIdentifier(AppGroupID)?.URLByAppendingPathComponent(ImageDirectoryName) {
      fm.createDirectoryAtURL(dir_url, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
  }
  
  private func removeFilesExceptOf(new_dates: [NSDate]) {
    let defs = NSUserDefaults(suiteName: AppGroupID)
    var old_fns = FilenamesSortedForImages()
    for d in new_dates {
      let fn = FilenameOfDate(d)
      if let i = find(old_fns, fn) {
        old_fns.removeAtIndex(i)
      }
    }
    
    NSLog("removing files \(old_fns)")
    let fm = NSFileManager.defaultManager()
    for fn in old_fns {
      if let url = FileURLOfFilename(fn) {
        fm.removeItemAtURL(url, error: nil)
      }
    }
  }
  
  func clearPhotos() {
    let fm = NSFileManager.defaultManager()
    if let dirURL = fm.containerURLForSecurityApplicationGroupIdentifier(AppGroupID)?.URLByAppendingPathComponent(ImageDirectoryName) {
      fm.removeItemAtURL(dirURL, error: nil)
    }
  }
  
  private func touchImageFile(ofDate date: NSDate) -> Bool {
    if let fileURL = FileURLOfDate(date) {
      NSLog("touch \(fileURL.path!)")
      let fm = NSFileManager.defaultManager()
      let path = fileURL.path!
      if !fm.fileExistsAtPath(path) {
        return fm.createFileAtPath(path, contents: NSData(), attributes: nil)
      }
    }
    return false
  }
  
  private func resizeImage(image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(ImageSize, false, 0)
    let iw = min(image.size.width, image.size.height)
    let ratio = ImageSize.width / iw
    image.drawInRect(CGRectMake(0, 0, image.size.width * ratio, image.size.height * ratio))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  private func savePhoto(image: UIImage, forDate date: NSDate) -> Bool {
    if let fileURL = FileURLOfDate(date) {
      if let png = UIImagePNGRepresentation(image) {
        if !png.writeToURL(fileURL, atomically: true) {
          NSLog("saved image at \(fileURL)")
          return true
        }
      }
    }
    NSLog("saving fails for \(date)")
    return false
  }
  
}

  