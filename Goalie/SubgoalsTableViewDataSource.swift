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
      if let children = _goal?.children {
         let title = children.first?.title ?? ""
         cell.updateTitle(title)
      }
      
      return cell
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
      // We want to show an extra cell for the "Add subgoal text"
//      var count = 1
//      if let subgoalCount = _goal?.children?.count {
//         count = subgoalCount + 1
//      }
//      return count
      
      return _goal?.children.count ?? 0
   }
}
