//
//  SubgoalsTableViewDataSource.swift
//  Goalie
//
//  Created by Gregory Klein on 12/5/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class SubgoalsTableViewDataSource: NSObject, UITableViewDataSource
{
   private weak var _goal: Goal?
   private var _tableView: UITableView
   private var _subgoalCellDelegate: SubgoalsTableViewCellDelegate
   
   init(goal: Goal?, tableView: UITableView, subgoalCellDelegate: SubgoalsTableViewCellDelegate)
   {
      _goal = goal
      _tableView = tableView
      _subgoalCellDelegate = subgoalCellDelegate
      
      super.init()
      
      _tableView.dataSource = self
   }
   
   func updateGoal(goal: Goal?)
   {
      _goal = goal
      _tableView.reloadData()
   }
}

extension SubgoalsTableViewDataSource
{
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
   {
      return 1
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
   {
      let cell = tableView.dequeueReusableCellWithIdentifier("SubgoalsCellIdentifier", forIndexPath: indexPath) as! SubgoalsTableViewCell
      
      cell.delegate = _subgoalCellDelegate
      if let children = _goal?.children,
         let child = children.objectAtIndex(indexPath.row) as? Goal
      {
         cell.configureForObject(child)
      }
      
      return cell
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      return _goal?.children.count ?? 0
   }
   
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete
      {
//         let goal = _dataProvider.objectAtIndexPath(indexPath)
//         goal.managedObjectContext?.performChanges({ () -> () in
//            goal.managedObjectContext?.deleteObject(goal)
//         })
         if let children = _goal?.children,
         let child = children.objectAtIndex(indexPath.row) as? Goal
         {
            child.delete()
         }
      }
   }
   
   func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
   {
      return true
   }
}
