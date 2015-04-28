//
//  GlanceController.swift
//  MemoAtGlance WatchKit Extension
//
//  Created by sakira on 2015/04/23.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
  @IBOutlet weak var image: WKInterfaceImage!

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
  }
  
  override func willActivate() {
    super.willActivate()
    
    setImage()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  private func setImage() {
    if let name = NSUserDefaults(suiteName: AppGroupID)?
      .stringForKey(Key_Selectedfilename) {
        self.image.setImageNamed(name)
    }
    
  }

}
