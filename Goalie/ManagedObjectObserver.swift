//
//  ManagedObjectObserver.swift
//  Goalie
//
//  Created by Gregory Klein on 12/6/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import CoreData

public final class ManagedObjectObserver
{
   public enum ChangeType {
   case Delete
   case Update
   }
   
   public init?(object: ManagedObjectType, changeHandler: ChangeType -> ())
   {
      guard let moc = object.managedObjectContext else { return nil }
      _objectHasBeenDeleted = !object.dynamicType.defaultPredicate.evaluateWithObject(object)
      
      _token = moc.addObjectsDidChangeNotificationObserver { [weak self] note in
         
         guard let changeType = self?.changeTypeOfObject(object, inNotification: note) else { return }
         self?._objectHasBeenDeleted = changeType == .Delete
         changeHandler(changeType)
      }
   }
   
   deinit {
      NSNotificationCenter.defaultCenter().removeObserver(_token)
   }
   
   // MARK: Private
   private var _token: NSObjectProtocol!
   private var _objectHasBeenDeleted: Bool = false
   
   private func changeTypeOfObject(object: ManagedObjectType, inNotification note: ObjectsDidChangeNotification) -> ChangeType?
   {
      let deleted = note.deletedObjects.union(note.invalidatedObjects)
      if note.invalidatedAllObjects || deleted.containsObjectIdenticalTo(object) {
         return .Delete
      }
      let updated = note.updatedObjects.union(note.refreshedObjects)
      if updated.containsObjectIdenticalTo(object) {
         let predicate = object.dynamicType.defaultPredicate
         if predicate.evaluateWithObject(object) {
            return .Update
         } else if !_objectHasBeenDeleted {
            return .Delete
         }
      }
      return nil
   }

}