//
//  GoalProvider.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import CoreData

class ParentGoalsDataProvider: NSObject, NSFetchedResultsControllerDelegate
{
   private var _moc: NSManagedObjectContext
   private var _parentGoalsFRC: NSFetchedResultsController
   
   init(managedObjectContext: NSManagedObjectContext)
   {
      _moc = managedObjectContext
      _parentGoalsFRC = NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequest, managedObjectContext: _moc, sectionNameKeyPath: nil, cacheName: nil)
      
      super.init()
      _parentGoalsFRC.delegate = self
      
      try! _parentGoalsFRC.performFetch()
   }
   
   func parentGoalsInMonth(month: Month) -> [Goal]
   {
      var parentGoals: [Goal] = []
      if let fetchedGoals = _parentGoalsFRC.fetchedObjects as? [Goal] {
         for goal in fetchedGoals {
            if goal.month == month {
               parentGoals.append(goal)
            }
         }
      }
      return parentGoals
   }
}

extension ParentGoalsDataProvider
{
   func controllerDidChangeContent(controller: NSFetchedResultsController)
   {
      NSFetchedResultsController.deleteCacheWithName(_parentGoalsFRC.cacheName)
      do { try _parentGoalsFRC.performFetch() } catch { fatalError("fetch request failed") }
   }
}
