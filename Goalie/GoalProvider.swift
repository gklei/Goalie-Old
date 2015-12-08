//
//  GoalProvider.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import CoreData

protocol ParentGoalsDataProviderDelegate
{
   func parentGoalsDidChange()
}

class ParentGoalsDataProvider: NSObject, NSFetchedResultsControllerDelegate
{
   private var _moc: NSManagedObjectContext
   private var _parentGoalsFRC: NSFetchedResultsController
   private var _delegate: ParentGoalsDataProviderDelegate
   
   init(managedObjectContext: NSManagedObjectContext, delegate: ParentGoalsDataProviderDelegate)
   {
      _moc = managedObjectContext
      _parentGoalsFRC = NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequest, managedObjectContext: _moc, sectionNameKeyPath: nil, cacheName: nil)
      _delegate = delegate
      
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
   
   func reloadData()
   {
      NSFetchedResultsController.deleteCacheWithName(_parentGoalsFRC.cacheName)
      do { try _parentGoalsFRC.performFetch() } catch { fatalError("fetch request failed") }
   }
}

extension ParentGoalsDataProvider
{
   func controllerDidChangeContent(controller: NSFetchedResultsController)
   {
      reloadData()
      _delegate.parentGoalsDidChange()
   }
}
