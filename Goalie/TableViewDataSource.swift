//
//  TableViewDataSource.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class TableViewDataSource<Delegate: DataSourceDelegate, Data: DataProvider, Cell: UITableViewCell where  Delegate.Object: ManagedObject, Delegate.Object == Data.Object, Cell: ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UITableViewDataSource
{
   private let _tableView: UITableView
   private let _dataProvider: Data
   private weak var _delegate: Delegate!
   
   var selectedObject: Data.Object? {
      guard let indexPath = _tableView.indexPathForSelectedRow else {
         return nil
      }
      return _dataProvider.objectAtIndexPath(indexPath)
   }
   
   required init(tableView: UITableView, dataProvider: Data, delegate: Delegate)
   {
      _tableView = tableView
      _dataProvider = dataProvider
      _delegate = delegate
      super.init()
      
      tableView.dataSource = self
      tableView.reloadData()
   }
   
   func processUpdates(updates: [DataProviderUpdate<Data.Object>]?)
   {
      guard let updates = updates else { return _tableView.reloadData() }
      
      _tableView.beginUpdates()
      for update in updates
      {
         switch update
         {
         case .Insert(let indexPath):
            _tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         case .Update(let indexPath, let object):
            guard let cell = _tableView.cellForRowAtIndexPath(indexPath) as? Cell else {
               break
            }
            cell.configureForObject(object)
         case .Move(let indexPath, let newIndexPath):
            _tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            _tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
         case .Delete(let indexPath):
            _tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         }
      }
      _tableView.endUpdates()
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return _dataProvider.numberOfItemsInSection(section)
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let object = _dataProvider.objectAtIndexPath(indexPath)
      let identifier = _delegate.cellIdentifierForObject(object)
      guard let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? Cell else {
         fatalError("Unexpected cell type at \(indexPath)")
      }
      
      cell.configureForObject(object)
      return cell
   }
   
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete
      {  
         let goal = _dataProvider.objectAtIndexPath(indexPath)
         goal.managedObjectContext?.performChanges({ () -> () in
            goal.managedObjectContext?.deleteObject(goal)
         })
      }
   }
   
   func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
   {
      return true
   }
}
