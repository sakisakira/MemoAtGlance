//
//  DetailInterfaceController.swift
//  MemoAtGlance
//
//  Created by Akira Suzuki on 2015/04/28.
//  Copyright (c) 2015年 sakira. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController : WKInterfaceController {
  @IBOutlet weak var image: WKInterfaceImage!

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    setTitle("Close")
    
    if let name = context as? String {
      image.setImageNamed(name)
      let result = saveFilename(name)
      NSLog("saved \(result) #\(name) to glance.")
    }
  }
  
  private func saveFilename(name: String) -> Bool {
    if let defs = NSUserDefaults(suiteName: AppGroupID) {
      defs.setObject(name, forKey: Key_Selectedfilename)
      return defs.synchronize()
    }
    return false
  }
  
}