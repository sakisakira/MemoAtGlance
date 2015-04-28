//
//  ImageFetcher.swift
//  MemoAtGlance
//
//  Created by sakira on 2015/04/27.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import UIKit
import WatchKit

class ImageFetcher {
  let watch = WKInterfaceDevice.currentDevice()
  var imageNameDatas = [] as [(name: String, data: NSData)]
  var imageNames: [String] {
    get {
      return imageNameDatas.map {$0.name}
    }
  }
  
  var updating = false
  func update() {
    if updating {return}
    updating = true
    updateMarkedFlags()
    let defs = NSUserDefaults(suiteName: AppGroupID)
    var watch_fns = defs?.stringArrayForKey(Key_ImageFilesInWatch) as? [String] ?? [] as [String]
    
    self.imageNameDatas = []
    for fn in FilenamesSortedForImages() {
      if let jpeg = JPEGDataOfFilename(fn) {
        imageNameDatas.append(name: fn, data: jpeg)
      }
    }
    NSLog("fetchJPEGDatas: \(imageNameDatas.count) datas fetched")
    
    let new_fns = imageNames
    for fn: String in watch_fns {
      let i = find(new_fns, fn)
      if i == nil {
        watch.removeCachedImageWithName(fn)
        watch_fns.filter({$0 != fn})
      }
    }
    for (fn, data) in imageNameDatas {
      let index = find(watch_fns, fn)
      if index == nil {
        if (watch.addCachedImageWithData(data, name: fn)) {
          watch_fns.append(fn)
        }
      }
    }
    
    defs?.setObject(watch_fns, forKey: Key_ImageFilesInWatch)
    defs?.synchronize()
    updating = false
  }
  
  private func updateMarkedFlags() {
    if let defs = NSUserDefaults(suiteName: AppGroupID) {
      if let updated_fns = defs.stringArrayForKey(Key_UpdatedFilenames) as? [String] {
        if let watch_fns = defs.stringArrayForKey(Key_ImageFilesInWatch) as? [String] {
          let new_fns = watch_fns.filter({fn in find(updated_fns, fn) != nil})
          defs.setObject(new_fns, forKey: Key_ImageFilesInWatch)
        }
      }
      defs.setObject([] as [String], forKey: Key_UpdatedFilenames)
    }
  }
  
}