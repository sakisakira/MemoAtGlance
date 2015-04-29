//
//  Shared.swift
//  MemoAtGlance
//
//  Created by sakira on 2015/04/23.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import UIKit

let AppGroupID = "group.jp.sakira"
let MaxNumberOfImages = 12
let ImageSize = CGSizeMake(280, 280)
let WatchImageSize = CGSizeMake(312, 312)
let ImageDirectoryName = "MemoAtGlance_Images"
let Key_ImageFilesInWatch = "MemoAtGlance_ImageFilesInWatch"
let Key_UpdatedFilenames = "MemoAtGlance_UpdatedFilenames"
let Key_Selectedfilename = "MemoAtGlance_SelectedFilename"

func FilenameOfDate(date: NSDate) -> String {
  let f = NSDateFormatter()
  f.dateFormat = "yyMMdd_HHmmss_SSSS"
  return f.stringFromDate(date)
}

func FileURLOfDate(date: NSDate) -> NSURL? {
  return FileURLOfFilename(FilenameOfDate(date))
}

func ImageExistsOfDate(date: NSDate) -> Bool {
  if let fileUrl = FileURLOfDate(date) {
    let path = fileUrl.path!
    let fm = NSFileManager.defaultManager()
    if let size = fm.attributesOfItemAtPath(path, error: nil)?[NSFileSize] as? Int {
      return size > 0
    }
  }
  return false
}

private func ImageOfData(data: NSData) -> UIImage? {
  if let img = UIImage(data: data,
    scale: UIScreen.mainScreen().scale) {
      return img
  }
  return nil
}

func ImageOfDate(date: NSDate) -> UIImage? {
  if let url = FileURLOfDate(date) {
    if let png = NSData(contentsOfURL: url) {
      return ImageOfData(png)
    }
  }
  return nil
}

func ImageOfFilename(fn: String) -> UIImage? {
  if let url = FileURLOfFilename(fn) {
    if let png = NSData(contentsOfURL: url) {
      return ImageOfData(png)
    }
  }
  return nil
}

func JPEGDataOfFilename(fn: String) -> NSData? {
  if let simg = ImageOfFilename(fn) {
    UIGraphicsBeginImageContext(WatchImageSize)
    simg.drawInRect(CGRectMake(0, 0, WatchImageSize.width, WatchImageSize.height))
    let dimg = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let jpg = UIImageJPEGRepresentation(dimg, 0.9)
    return jpg
  }
  return nil
}

func FileURLOfFilename(filename: String) -> NSURL? {
  let fm = NSFileManager.defaultManager()
  let baseURL = fm.containerURLForSecurityApplicationGroupIdentifier(AppGroupID)
  let dirURL = baseURL?.URLByAppendingPathComponent(ImageDirectoryName)
  return dirURL?.URLByAppendingPathComponent(filename)
}

func FilenamesSortedForImages() -> [String] {
  let fm = NSFileManager.defaultManager()
  let baseURL = fm.containerURLForSecurityApplicationGroupIdentifier(AppGroupID)
  if let dirURL = baseURL?.URLByAppendingPathComponent(ImageDirectoryName) {
    if let fns = fm.contentsOfDirectoryAtPath(dirURL.path!, error: nil) as? [String] {
      return fns.sorted {$0 < $1}
    }
  }
  return []
}

// NSDate: Comparable extension
public func <(a: NSDate, b: NSDate) -> Bool {
  return a.compare(b) == NSComparisonResult.OrderedAscending
}
public func ==(a: NSDate, b: NSDate) -> Bool {
  return a.compare(b) == NSComparisonResult.OrderedSame
}
extension NSDate: Comparable { }

