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
   @NSManaged public private(set) var title: String
   @NSManaged public private(set) var summary: String
   @NSManaged public private(set) var monthValue: Int16
   
   private lazy var _dateFormatter: NSDateFormatter = {
      return NSDateFormatter()
   }()
   
   public static func insertIntoContext(moc: NSManagedObjectContext, withTitle title: String, summary: String) -> Goal
   {
      let goal: Goal = moc.insertObject()
      goal.title = title
      goal.summary = summary
      return goal
   }
}

extension Goal: ManagedObjectType
{
   public static var entityName: String {
      return "Goal"
   }
   
   public static var defaultSortDescriptors: [NSSortDescriptor] {
      return [NSSortDescriptor(key: "title", ascending: false)]
   }
}
