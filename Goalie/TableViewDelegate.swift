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
      var rowFrames: [CGRect] = []
      for cellIndex in 0..<_dataProvider.numberOfItemsInSection(0) {
         let indexPath = NSIndexPath(forRow: cellIndex, inSection: 0)
         if let cell = _tableView.cellForRowAtIndexPath(indexPath) {
            cell.layoutIfNeeded()
            rowFrames.append(cell.frame)
         }
      }
      
      let defaultHeight = _delegate.heightForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
      let patternImage = UIImage.patternImageForFrames(rowFrames, width: _tableView.bounds.width, firstColor: UIColor.lightCellAlternateColor(), secondColor: UIColor.darkCellAlternateColor(), extraRows: 10, defaultHeight: defaultHeight)
      _tableView.backgroundColor = UIColor(patternImage: patternImage)
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
