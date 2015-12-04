//
//  NSManagedObjectContext+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import CoreData

extension NSManagedObjectContext
{
   func insertObject<T: ManagedObject where T: ManagedObjectType>() -> T
   {
      guard let obj = NSEntityDescription.insertNewObjectForEntityForName(T.entityName, inManagedObjectContext: self) as? T else {
         fatalError("Wrong object type")
      }
      return obj
   }
   
   func saveOrRollback() -> Bool
   {
      var didSave = true
      do {
         try save()
      } catch {
         rollback()
         didSave = false
      }
      return didSave
   }
   
   func performChanges(block: () -> ())
   {
      performBlock {
         block()
         self.saveOrRollback()
      }
   }
}
