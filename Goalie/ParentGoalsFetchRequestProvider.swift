//
//  ParentGoalsFetchRequestProvider.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation
import CoreData

class ParentGoalsFetchRequestProvider
{
   private static let _sharedProvider = ParentGoalsFetchRequestProvider()
   
   private lazy var fetchRequest: NSFetchRequest = {
      let request = Goal.sortedParentGoalsFetchRequest
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      return request
   }()
   
   class var fetchRequest: NSFetchRequest {
      return _sharedProvider.fetchRequest
   }
   
   class func fetchRequestForMonth(month: Month) -> NSFetchRequest
   {
      let request = Goal.sortedParentGoalsFetchRequestForMonth(month)
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      
      return request
   }
}

class ChildGoalsFetchRequestProvider
{
   private static let _sharedProvider = ChildGoalsFetchRequestProvider()
   
   private lazy var fetchRequest: NSFetchRequest = {
      let request = Goal.sortedChildrenGoalsFetchRequest
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      return request
   }()
   
   class var fetchRequest: NSFetchRequest {
      return _sharedProvider.fetchRequest
   }
   
   class func fetchRequestForActiveState(state: ActiveState) -> NSFetchRequest
   {
      let request = Goal.sortedChildrenGoalsFetchRequestForActiveState(state)
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      
      return request
   }
}