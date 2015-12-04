//
//  AllGoalsTableViewDelegate.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class AllGoalsTableViewDelegate<Data: DataProvider where Data.Object: ManagedObject>: NSObject, ManagedObjectContextSettable, UITableViewDelegate
{
   var managedObjectContext: NSManagedObjectContext!
   private var _tableView: UITableView
   private var _dataProvider: Data
   
   private var _deleteIndexPath: NSIndexPath?
   
   init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, dataProvider: Data)
   {
      self.managedObjectContext = managedObjectContext
      _tableView = tableView
      _dataProvider = dataProvider
      super.init()
      
      _tableView.allowsMultipleSelectionDuringEditing = false
      _tableView.delegate = self
   }
}

extension AllGoalsTableViewDelegate
{
}
