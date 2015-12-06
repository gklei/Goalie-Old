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
   
   @IBOutlet private weak var _topNavigationBar: GoalieNavigationBar!
   @IBOutlet private weak var _subgoalsNavigationBar: GoalieNavigationBar! {
      didSet {
         _subgoalsNavigationBar.updateTitleFontSize(16)
         
         let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
         _subgoalsNavigationBar.addGestureRecognizer(tapRecognizer)
      }
   }
   
   @IBOutlet private weak var _subgoalsTableView: UITableView! {
      didSet {
         _subgoalsTableView.dataSource = self
         
         let nib = UINib(nibName: "SubgoalsTableViewCell", bundle: nil)
         _subgoalsTableView.registerNib(nib, forCellReuseIdentifier: "SubgoalsCellIdentifier")
         
         // A trick for making it so that separators don't display for empty cells
         let size = CGSize(width: 0, height: 1)
         _subgoalsTableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
      }
   }
   
   var goal: Goal?
   var managedObjectContext: NSManagedObjectContext!
   private var _currentSubgoalCell: SubgoalsTableViewCell?
   
   // FOR TESTING
//   private var _testSubgoals: [String] = []
   private var _testSubgoals = ["subgoal 1", "subgoal 2", "subgoal 3", "subgoal 4", "subgoal 5"]
   
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      _titleTextField.text = goal?.title
      _summaryTextField.text = goal?.summary
      
      let title = goal != nil ? "Details" : "Create"
      _topNavigationBar.updateTitle(title)
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
            Goal.insertIntoContext(self.managedObjectContext, title: title, summary: summary)
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
   
   internal func dismissKeyboard()
   {
      _titleTextField.resignFirstResponder()
      _summaryTextField.resignFirstResponder()
      _currentSubgoalCell?.stopEditing()
   }
}

extension GoalDetailsViewController: UITableViewDataSource
{
   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("SubgoalsCellIdentifier", forIndexPath: indexPath) as! SubgoalsTableViewCell
      
      if indexPath.row < _testSubgoals.count {
         let title = _testSubgoals[indexPath.row]
         cell.updateTitle(title)
      }
      
      cell.delegate = self
      return cell
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return _testSubgoals.count
   }
}

extension GoalDetailsViewController: SubgoalsTabelViewCellDelegate
{
   func subgoalBeganEditing(cell: SubgoalsTableViewCell)
   {
      _currentSubgoalCell = cell
   }
   
   func subgoalCellFinishedEditing(cell: SubgoalsTableViewCell)
   {
      _currentSubgoalCell = nil
   }
}
