//
//  EmptyTableViewDataSourceDelegate.swift
//  Goalie
//
//  Created by Gregory Klein on 12/14/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EmptyTableViewDataSourceDelegate: NSObject
{
   private weak var _tableView: UITableView?
   private var _title: String
   private var _description: String
   private var _buttonTappedBlock: (() -> Void)?
   
   // FOR NOW!
   var useImage = false
   
   init(tableView: UITableView, title: String, description: String, buttonTappedBlock: (() -> Void)?)
   {
      _tableView = tableView
      _title = title
      _description = description
      _buttonTappedBlock = buttonTappedBlock
      
      super.init()
      
      _tableView?.emptyDataSetDelegate = self
      _tableView?.emptyDataSetSource = self
   }
}

extension EmptyTableViewDataSourceDelegate: DZNEmptyDataSetSource
{
   func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      let text = _title
      let attribs = [
         NSFontAttributeName: UIFont.mediumGoalieFontWithSize(useImage ? 14 : 18),
         NSForegroundColorAttributeName: UIColor.lightPurpleTextColor()
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      var text = _description
      
      let para = NSMutableParagraphStyle()
      para.lineBreakMode = NSLineBreakMode.ByWordWrapping
      para.alignment = NSTextAlignment.Center
      
      let attribs = [
         NSFontAttributeName: UIFont.mediumGoalieFontWithSize(useImage ? 14 : 16),
         NSForegroundColorAttributeName: UIColor.lightPurpleTextColor().colorWithAlphaComponent(0.6),
         NSParagraphStyleAttributeName: para
      ]
      
      if useImage {
         text = ""
      }
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
   {
      return useImage ? -15 : 0
   }
   
   func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString!
   {
      let text = "ADD A NEW GOAL"
      let attribs = [
         NSFontAttributeName: UIFont.boldGoalieFontWithSize(12),
         NSForegroundColorAttributeName: state == .Normal ? UIColor.whiteColor() : UIColor.whiteColor().colorWithAlphaComponent(0.6),
         NSKernAttributeName : 4
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage!
   {
      return useImage ? UIImage(named: "Empty")! : UIImage.imageWithColor(UIColor.clearColor())
   }
   
   func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat
   {
      return 6
   }
}

extension EmptyTableViewDataSourceDelegate: DZNEmptyDataSetDelegate
{
   func emptyDataSetDidTapButton(scrollView: UIScrollView!)
   {
      _buttonTappedBlock?()
   }
   
   func emptyDataSetWillDisappear(scrollView: UIScrollView!)
   {
      _tableView?.showSeparatorsForEmptyCells(true)
   }
   
   func emptyDataSetWillAppear(scrollView: UIScrollView!)
   {
      _tableView?.showSeparatorsForEmptyCells(false)
   }
}
