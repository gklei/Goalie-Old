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
         NSFontAttributeName: UIFont(name: ThemeNavigationFontName, size: 18)!,
         NSForegroundColorAttributeName: UIColor(red: 124/255.0, green: 124/255.0, blue: 164/255.0, alpha: 1)
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      let text = _description
      
      let para = NSMutableParagraphStyle()
      para.lineBreakMode = NSLineBreakMode.ByWordWrapping
      para.alignment = NSTextAlignment.Center
      
      let attribs = [
         NSFontAttributeName: UIFont(name: ThemeNavigationFontName, size: 14)!,
         NSForegroundColorAttributeName: UIColor(red: 124/255.0, green: 124/255.0, blue: 164/255.0, alpha: 0.6),
         NSParagraphStyleAttributeName: para
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
      let text = "Create a Goal"
      let attribs = [
         NSFontAttributeName: UIFont(name: ThemeFontName, size: 16)!,
         NSForegroundColorAttributeName: state == .Normal ? UIColor.whiteColor() : UIColor.whiteColor().colorWithAlphaComponent(0.6)
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
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
