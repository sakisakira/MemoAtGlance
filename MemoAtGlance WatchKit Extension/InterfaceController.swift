//
//  InterfaceController.swift
//  MemoAtGlance WatchKit Extension
//
//  Created by sakira on 2015/04/23.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  @IBOutlet weak var table: WKInterfaceTable!
  
  let imageFetcher = ImageFetcher()
  var timer: NSTimer?
  var lastImageNames: [String]?
  
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
  }

  override func willActivate() {
    super.willActivate()
    startTimer()
  }

  override func didDeactivate() {
    super.didDeactivate()
    
    stopTimer()
  }
  
  private func startTimer() {
    timer = NSTimer.scheduledTimerWithTimeInterval(5,
      target: self,
      selector: "checkPhotos",
      userInfo: nil,
      repeats: true)
  }
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  @objc
  private func checkPhotos() {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
      self.imageFetcher.update()
//    })
    let image_names = imageFetcher.imageNames
    if (lastImageNames == nil || image_names != lastImageNames!) {
      configureTable()
      if image_names.count == 0 {
        displayNoImageMessage()
      }
    }
    lastImageNames = image_names
    NSLog("checkPhotos \(image_names.count)")
  }
  
  private func configureTable() {
    let image_names = imageFetcher.imageNameDatas
    let num = image_names.count
    table.setNumberOfRows(num, withRowType: "MainRow")
    for i in 0 ..< num {
      let row = table.rowControllerAtIndex(i) as! MainRow
      row.image.setImageNamed(image_names[i].name)
    }
  }
  
  private func displayNoImageMessage() {
    presentControllerWithName("NoPhotoMessageInterfaceController", context: nil)
  }
  
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    if rowIndex >= imageFetcher.imageNameDatas.count {return}
    
    stopTimer()
    let name = imageFetcher.imageNameDatas[rowIndex].name
    presentControllerWithName("DetailInterfaceController", context: name)
  }
  
  // menu items
  @IBAction func clearItemSelected() {
    NSLog("clearItemSelected()")
    let defs = NSUserDefaults(suiteName: AppGroupID)
    defs?.setObject([] as [String], forKey: Key_ImageFilesInWatch)
    defs?.synchronize()
    
    let device = WKInterfaceDevice.currentDevice()
    device.removeAllCachedImages()
    
    checkPhotos()
    stopTimer()
    startTimer()
  }
  
  @IBAction func reloadItemSelected() {
    NSLog("reloadItemSelected()")
    let info = ["Reload" : "Albums"]
    let result =
    WKInterfaceController.openParentApplication(info, reply:
      {reply in
        NSLog("reloadItemSelected reply received \(reply)")
        self.checkPhotos()
      })
    NSLog("reloadItemSelected result \(result)")
    
    checkPhotos()
    stopTimer()
    startTimer()
  }
}

class MainRow : NSObject {
  @IBOutlet weak var image: WKInterfaceImage!
}