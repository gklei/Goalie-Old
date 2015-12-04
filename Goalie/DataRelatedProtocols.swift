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
}

extension ManagedObjectType
{
   public static var defaultSortDescriptors: [NSSortDescriptor] {
      return []
   }
   
   public static var sortedFetchRequest: NSFetchRequest {
      let request = NSFetchRequest(entityName: entityName)
      request.sortDescriptors = defaultSortDescriptors
      return request
   }
}
