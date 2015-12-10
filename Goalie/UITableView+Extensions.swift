//
//  UITableView+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/10/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension UITableView
{
   func showSeparatorsForEmptyCells(show: Bool)
   {
      let footerFrame = CGRect(x: 0, y: 0, width: 0, height: 1)
      self.tableFooterView = show ? nil : UIView(frame: footerFrame)
   }
}
