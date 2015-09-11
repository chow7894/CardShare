//
//  MyBrowserTableViewCell.swift
//  CardShare
//
//  Created by Christine Abernathy on 10/12/14.
//  Copyright (c) 2014 Elidora LLC. All rights reserved.
//

import UIKit

class MyBrowserTableViewCell: UITableViewCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .None
    self.accessoryType = .None
    self.accessoryView = nil
    
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    self.textLabel.textColor = delegate.mainColor()
  }
  
  override func setHighlighted(highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    if highlighted {
      let delegate = UIApplication.sharedApplication().delegate as AppDelegate
      self.textLabel.textColor = delegate.mainColor()
    } else {
      self.textLabel.textColor = UIColor.blackColor()
    }
  }
}
