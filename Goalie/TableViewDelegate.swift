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
   
   init(tableView: UITableView, dataProvider: Data, delegate: Delegate)
   {
      _tableView = tableView
      _dataProvider = dataProvider
      _delegate = delegate
      
      super.init()
      
      _tableView.allowsMultipleSelectionDuringEditing = false
      tableView.delegate = self
   }
   
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
   {
      let object = _dataProvider.objectAtIndexPath(indexPath)
      _tableView.deselectRowAtIndexPath(indexPath, animated: true)
      _delegate.objectSelected(object)
   }
}