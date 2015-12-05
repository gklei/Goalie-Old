//
//  GoalDetailsViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class GoalDetailsViewController: UIViewController, ManagedObjectContextSettable
{
   @IBOutlet private weak var _titleTextField: JVFloatLabeledTextField!
   @IBOutlet private weak var _summaryTextField: JVFloatLabeledTextField!
   @IBOutlet private weak var _navigationItem: UINavigationItem!
   
   var goal: Goal?
   var managedObjectContext: NSManagedObjectContext!
   
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      _titleTextField.text = goal?.title
      _summaryTextField.text = goal?.summary
      
      _navigationItem.title = goal != nil ? "Details" : "Create"
      
      let attrs = Theme.titleTextAttributesForComponent(.NavBarButtonItem)
      
      _navigationItem.leftBarButtonItem?.title = "Cancel"
      _navigationItem.leftBarButtonItem?.setTitleTextAttributes(attrs, forState: .Normal)
      
      _navigationItem.rightBarButtonItem?.setTitleTextAttributes(attrs, forState: .Normal)
      _navigationItem.rightBarButtonItem?.title = "Done"
   }
   
   func configureWithGoal(goal: Goal)
   {
      self.goal = goal
   }
   
   @IBAction func doneButtonPressed()
   {
      // if we don't have a goal, then we want to createa  new one
      if goal == nil
      {
         managedObjectContext.performChanges { () -> () in
            let title = self._titleTextField.text ?? "No Title Set"
            let summary = self._summaryTextField.text ?? "No Summary Set"
            Goal.insertIntoContext(self.managedObjectContext, withTitle: title, summary: summary)
         }
      }
      dismissSelf()
   }
   
   @IBAction func cancelButtonPressed()
   {
      dismissSelf()
   }
   
   private func dismissSelf()
   {
      goal = nil
      _titleTextField.resignFirstResponder()
      _summaryTextField.resignFirstResponder()
      self.dismissViewControllerAnimated(false, completion: nil)
   }
}
