//
//  GoalPresenter.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

class GoalPresenter<Controller: UIViewController where Controller: ManagedObjectContextSettable>
{
   private var _presentingController: Controller
   private let _detailsViewController = GoalDetailsViewController()
   
   init(presentingController: Controller)
   {
      _presentingController = presentingController
      _detailsViewController.managedObjectContext = _presentingController.managedObjectContext
   }
   
   func presentDetailsForGoal(goal: Goal)
   {
      _detailsViewController.configureWithGoal(goal, allowCancel: false)
      _presentingController.presentViewController(_detailsViewController, animated: true, completion: nil)
   }
   
   func createAndPresentNewGoal()
   {
      let moc = _presentingController.managedObjectContext
      let newGoal = Goal.insertIntoContext(moc, title: "", summary: "")
      
      _detailsViewController.configureWithGoal(newGoal, allowCancel: true)
      _presentingController.presentViewController(_detailsViewController, animated: true, completion: nil)
   }
   
   func createAndPresentNewGoalWithMonth(month: Month)
   {
      let moc = _presentingController.managedObjectContext
      let newGoal = Goal.insertIntoContext(moc, month: month)
      
      _detailsViewController.configureWithGoal(newGoal, allowCancel: true)
      _presentingController.presentViewController(_detailsViewController, animated: true, completion: nil)
   }
}
