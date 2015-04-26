//
//  Constants.swift
//  MemoAtGlance
//
//  Created by sakira on 2015/04/23.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import UIKit

let AppGroupID = "group.jp.sakira"
let MaxNumberOfImages = 8
let ImageSize = CGSizeMake(140, 140)
let FilenamePrefix = "MemoAtGlance_image_"
let ImageDirectoryName = "MemoAtGlanceImages"
let FilenamesDictionaryKey = "MemoAtGlanceFilenamesDictionary"

func FilenameOfDate(date: NSDate) -> String {
  let f = NSDateFormatter()
  f.dateFormat = "yyMMdd_HHmmss_SSSS"
  return f.stringFromDate(date)
}

func FileURLOfDate(date: NSDate) -> NSURL? {
  return FileURLOfFilename(FilenameOfDate(date))
}

func ImageOfDate(date: NSDate) -> UIImage? {
  if let url = FileURLOfDate(date) {
    if let png = NSData(contentsOfURL: url) {
      if let img = UIImage(data: png) {
        return img
      }
    }
  }
  return nil
}

func JPEGDataOfDate(date: NSDate) -> NSData? {
  if let img = ImageOfDate(date) {
    let jpg = UIImageJPEGRepresentation(img, 0.9)
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

func KeysSortedForImages() -> [NSDate] {
  if let defs = NSUserDefaults(suiteName: AppGroupID) {
    if let dict = defs.dictionaryForKey(FilenamesDictionaryKey) as? [NSDate:String] {
      return Array(dict.keys).sorted {$0 < $1}
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

