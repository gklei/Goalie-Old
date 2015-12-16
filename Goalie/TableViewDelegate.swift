//
//  AllGoalsTableViewDelegate.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class TableViewDelegate<Data: DataProviderProtocol, Delegate: TableViewDelegateProtocol where Data.Object: ManagedObject, Data.Object == Delegate.Object>: NSObject, UITableViewDelegate
{
   private var _tableView: UITableView
   private var _dataProvider: Data
   private var _delegate: Delegate
   
   private var _deleteIndexPath: NSIndexPath?
   
   var useAutomaticRowHeight = true
   var editActions: [UITableViewRowAction]?
   
   init(tableView: UITableView, dataProvider: Data, delegate: Delegate)
   {
      _tableView = tableView
      _tableView.rowHeight = UITableViewAutomaticDimension
      _dataProvider = dataProvider
      _delegate = delegate
      
      super.init()
      
      _tableView.allowsMultipleSelectionDuringEditing = false
      tableView.delegate = self
   }
   
   func updateBackgroundPattern()
   {
//      let height = _delegate.heightForRowAtIndexPath(NSIndexPath())
//      let image = UIImage.sampleAlternatingColorImageWithSize(CGSize(width: _tableView.bounds.width, height: (height + 1.5) * 2.0))
//      
////      let anotherImage = UIImage.alternateImageWithWidth(_tableView.bounds.width, height: 2 * (height + 1.5), topPadding: 284)
////      _tableView.backgroundColor = UIColor(patternImage: anotherImage)
//      _tableView.backgroundColor = UIColor(patternImage: image)
//      _tableView.separatorStyle = .None
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      let object = _dataProvider.objectAtIndexPath(indexPath)
      _tableView.deselectRowAtIndexPath(indexPath, animated: true)
      _delegate.objectSelected(object)
   }
   
   func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
      return editActions
   }
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
   {
      return useAutomaticRowHeight ? UITableViewAutomaticDimension : _delegate.heightForRowAtIndexPath(indexPath)
   }
   
   func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
   {
      return useAutomaticRowHeight ? UITableViewAutomaticDimension : _delegate.heightForRowAtIndexPath(indexPath)
   }
}
