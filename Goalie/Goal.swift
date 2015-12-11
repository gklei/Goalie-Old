//
//  Goal.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

public final class Goal: ManagedObject
{
   @NSManaged public var title: String
   @NSManaged public var summary: String
   @NSManaged public private(set) var monthValue: Int16
   @NSManaged public private(set) var creationDate: NSDate
   @NSManaged public private(set) var activeStateValue: Int16
   @NSManaged public var completed: Bool
   
   @NSManaged public private(set) var parent: Goal?
   @NSManaged public private(set) var children: NSOrderedSet
   
   public static func insertIntoContext(moc: NSManagedObjectContext, title: String, summary: String) -> Goal
   {
      let goal: Goal = moc.insertObject()
      goal.title = title
      goal.summary = summary
      return goal
   }
   
   public static func insertIntoContext(moc: NSManagedObjectContext, month: Month) -> Goal
   {
      let goal: Goal = moc.insertObject()
      goal.month = month
      
      return goal
   }
   
   public static func insertIntoContext(moc: NSManagedObjectContext, title: String, parent: Goal) -> Goal
   {
      let goal: Goal = moc.insertObject()
      goal.title = title
      
      guard goal != parent else { return goal }
      goal.parent = parent
      goal.month = parent.month
      
      return goal
   }
   
   public override func awakeFromInsert() {
      creationDate = NSDate()
      title = ""
      summary = ""
      month = .Jan
      activeState = .Idle
   }
}

extension Goal
{
   public var subgoals: Array<Goal> {
      guard let subgoalArray = children.array as? [Goal] else {
         fatalError("children must be an NSOrderedSet of Goal objects")
      }
      return subgoalArray
   }
   
   public var completedSubgoals: Array<Goal> {
      var completedArray: [Goal] = []
      for subgoal in subgoals {
         if subgoal.completed {
            completedArray.append(subgoal)
         }
      }
      return completedArray
   }
   
   public var month: Month {
      get {
         return Month(rawValue: Int(monthValue))!
      }
      set {
         monthValue = Int16(newValue.rawValue)
         for subgoal in subgoals {
            subgoal.monthValue = monthValue
         }
      }
   }
   
   public var activeState: ActiveState {
      get {
         return ActiveState(rawValue: Int(activeStateValue))!
      }
      set {
         activeStateValue = Int16(newValue.rawValue)
      }
   }
   
   public func subgoalForIndexPath(indexPath: NSIndexPath) -> Goal?
   {
      var child: Goal?
      if indexPath.row < children.count {
         child = children.objectAtIndex(indexPath.row) as? Goal
      }
      return child
   }
   
   public var childrenFetchRequest: NSFetchRequest {
      let request = NSFetchRequest(entityName: Goal.entityName)
      request.predicate = NSPredicate(format: "parent == %@", self)
      request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      return request
   }
   
   public func deleteEmptySubgoalsAndSave(save: Bool)
   {
      if save {
         managedObjectContext?.performChanges({ () -> () in
            self._removeEmptySubgoals()
         })
      }
      else {
         _removeEmptySubgoals()
      }
   }
   
   private func _removeEmptySubgoals()
   {
      for subgoal in self.subgoals {
         if subgoal.title == "" {
            subgoal.managedObjectContext?.deleteObject(subgoal)
         }
      }
   }
}

extension Goal: ManagedObjectType
{
   public static var entityName: String {
      return "Goal"
   }
   
   public static var defaultSortDescriptors: [NSSortDescriptor] {
      return [NSSortDescriptor(key: "title", ascending: true)]
   }
   
   public func delete()
   {
      self.managedObjectContext?.performChanges({ () -> () in
         self.managedObjectContext?.deleteObject(self)
      })
   }
}
