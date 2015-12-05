//
//  FetchedResultsDataProvider.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import CoreData

class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProviderProtocol
{
   private weak var _delegate: Delegate!
   private let _fetchedResultsController: NSFetchedResultsController
   private var _updates: [DataProviderUpdate<Object>] = []
   
   typealias Object = Delegate.Object
   
   init(fetchedResultsController: NSFetchedResultsController, delegate: Delegate)
   {
      _fetchedResultsController = fetchedResultsController
      _delegate = delegate
      super.init()
      
      _fetchedResultsController.delegate = self
      try! _fetchedResultsController.performFetch()
   }
   
   func objectAtIndexPath(indexPath: NSIndexPath) -> Object
   {
      guard let result = _fetchedResultsController.objectAtIndexPath(indexPath) as? Object else { fatalError("Unexpected object at \(indexPath)") }
      return result
   }
   
   func numberOfItemsInSection(section: Int) -> Int
   {
      guard let sec = _fetchedResultsController.sections?[section] else { return 0 }
      return sec.numberOfObjects
   }
   
   func controllerWillChangeContent(controller: NSFetchedResultsController)
   {
      _updates = []
   }
   
   func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
   {
      switch type
      {
      case .Insert:
         guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
         _updates.append(.Insert(indexPath))
      case .Update:
         guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
         let object = objectAtIndexPath(indexPath)
         _updates.append(.Update(indexPath, object))
      case .Move:
         guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
         guard let newIndexPath = newIndexPath else { fatalError("New index path should be not nil") }
         _updates.append(.Move(indexPath, newIndexPath))
      case .Delete:
         guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
         _updates.append(.Delete(indexPath))
      }
   }
   
   func controllerDidChangeContent(controller: NSFetchedResultsController)
   {
      _delegate.dataProviderDidUpdate(_updates)
   }
}
