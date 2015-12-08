//
//  DataRelatedProtocols.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectContextSettable: class
{
   var managedObjectContext: NSManagedObjectContext! {get set}
}

public protocol ManagedObjectType: class
{
   static var entityName: String {get}
   static var defaultSortDescriptors: [NSSortDescriptor] {get}
   static var defaultPredicate: NSPredicate {get}
   var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType
{
   public static var defaultSortDescriptors: [NSSortDescriptor] {
      return []
   }
   
   public static var defaultPredicate: NSPredicate {
      return NSPredicate(value: true)
   }
   
   public static var sortedFetchRequest: NSFetchRequest {
      let request = NSFetchRequest(entityName: entityName)
      request.predicate = defaultPredicate
      request.sortDescriptors = defaultSortDescriptors
      return request
   }
   
   public static var sortedParentGoalsFetchRequest: NSFetchRequest {
      let request = NSFetchRequest(entityName: entityName)
      request.predicate = NSPredicate(format: "parent == nil")
      request.sortDescriptors = defaultSortDescriptors
      return request
   }
   
   public static func sortedParentGoalsFetchRequestForMonth(month: Month) -> NSFetchRequest
   {
      let request = NSFetchRequest(entityName: entityName)
      
      let parentGoalPredicate = NSPredicate(format: "parent == nil")
      let monthPredicate = NSPredicate(format: "monthValue == \(Int16(month.rawValue))")
      let compoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [parentGoalPredicate, monthPredicate])

      request.predicate = compoundPredicate
      request.sortDescriptors = defaultSortDescriptors
      return request
   }
}
