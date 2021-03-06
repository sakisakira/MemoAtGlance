//
//  NoPhotoMessageInterfaceController.swift
//  PhotoAtGlance
//
//  Created by Akira Suzuki on 2015/04/16.
//  Copyright (c) 2015年 OTSL. All rights reserved.
//

import Foundation
import WatchKit

class NoPhotoMessageInterfaceController : WKInterfaceController {
  
  override func willActivate() {
    super.willActivate()
    
    setTitle("Close")
    
    NSTimer.scheduledTimerWithTimeInterval(3,
      target: self,
      selector: "dismissController",
      userInfo: nil,
      repeats: false)
  }
}