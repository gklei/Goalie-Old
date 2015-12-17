//
//  UITableView+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/10/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension NSIndexPath
{
   var next: NSIndexPath {
      return NSIndexPath(forRow: row + 1, inSection: section)
   }
}

extension UITableView
{
   func showSeparatorsForEmptyCells(show: Bool)
   {
      let footerFrame = CGRect(x: 0, y: 0, width: 0, height: 1)
      self.tableFooterView = show ? nil : UIView(frame: footerFrame)
   }
   
   func flashCellAtIndexPath(indexPath: NSIndexPath, duration: Double)
   {
      if indexPath.row < self.numberOfRowsInSection(0) {
         UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
            
            }) { (finished: Bool) -> Void in
               
               if let subgoalCell = self.cellForRowAtIndexPath(indexPath) {
                  
                  let originalBackgroundColor = subgoalCell.backgroundColor
                  UIView.animateWithDuration(duration * 0.6, animations: { () -> Void in
                     subgoalCell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
                     
                     }) { (finished: Bool) -> Void in
                        
                        UIView.animateWithDuration(duration * 0.4, animations: { () -> Void in
                           subgoalCell.backgroundColor = originalBackgroundColor
                        })
                  }
               }
         }
      }
   }
   
   func indexPathIsLast(indexPath: NSIndexPath) -> Bool
   {
      return indexPath.row == numberOfRowsInSection(0) - 1
   }
   
   func scrollByPoints(points: CGFloat)
   {
      let offset = self.contentOffset
      self.contentOffset = CGPoint(x: offset.x, y: offset.y + points)
   }
}
