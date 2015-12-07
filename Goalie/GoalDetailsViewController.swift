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
   var goal: Goal? {
      didSet {
         if let unwrappedGoal = goal {
            _observer = ManagedObjectObserver(object: unwrappedGoal) { [unowned self] type in
               guard type == .Update else { return }
               self._subgoalsTableView.reloadData()
            }
         }
      }
   }
   
   private var _observer: ManagedObjectObserver?
   
   var managedObjectContext: NSManagedObjectContext!
   private var _currentSubgoalCell: SubgoalsTableViewCell?
   private var _subgoalsTableViewDataSource: SubgoalsTableViewDataSource?
   
   @IBOutlet private weak var _titleTextField: JVFloatLabeledTextField!
   @IBOutlet private weak var _summaryTextField: JVFloatLabeledTextField!
   
   @IBOutlet private weak var _topNavigationBar: GoalieNavigationBar!
   @IBOutlet private weak var _subgoalsNavigationBar: GoalieNavigationBar! {
      didSet {
         let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
         _subgoalsNavigationBar.addGestureRecognizer(tapRecognizer)
      }
   }
   
   @IBOutlet private weak var _subgoalsTableView: UITableView! {
      didSet {
         let nib = UINib(nibName: "SubgoalsTableViewCell", bundle: nil)
         _subgoalsTableView.registerNib(nib, forCellReuseIdentifier: "SubgoalsCellIdentifier")
         
         // A trick for making it so that separators don't display for empty cells
         let size = CGSize(width: 0, height: 1)
         _subgoalsTableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
         
         // The subgoalCellDelegate is for being told when the cells' textfields start/stop editing
         _subgoalsTableViewDataSource = SubgoalsTableViewDataSource(goal: self.goal, tableView: _subgoalsTableView, subgoalCellDelegate: self)
      }
   }
   
   private var subgoalCount = 0
   
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _subgoalsNavigationBar.updateTitleFontSize(18)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      
      _titleTextField.text = goal?.title
      _summaryTextField.text = goal?.summary
      
      let title = goal != nil ? "Details" : "Create"
      _topNavigationBar.updateTitle(title)
   }
   
   func configureWithGoal(goal: Goal?)
   {
      self.goal = goal
      subgoalCount = goal?.children.count ?? 0
      _subgoalsTableViewDataSource?.updateGoal(self.goal)
   }
   
   @IBAction func doneButtonPressed()
   {
      if let goal = goal
      {
         managedObjectContext.performChanges({() -> () in
            goal.title = self._titleTextField.text ?? "No title set"
            goal.summary = self._summaryTextField.text ?? ""
         })
      }
      else // Create a new goal
      {
         managedObjectContext.performChanges {() -> () in
            let title = self._titleTextField.text ?? "No title set"
            let summary = self._summaryTextField.text ?? ""
            Goal.insertIntoContext(self.managedObjectContext, title: title, summary: summary)
         }
      }
      dismissSelf()
   }
   
   @IBAction func cancelButtonPressed()
   {
      dismissSelf()
   }
   
   @IBAction func addSubgoalsButtonPressed()
   {
      if let parent = self.goal {
         Goal.insertIntoContext(managedObjectContext, title: "", parent: parent)
      }
   }
   
   private func dismissSelf()
   {
      goal = nil
      dismissKeyboard()
      self.dismissViewControllerAnimated(false, completion: nil)
   }
   
   internal func dismissKeyboard()
   {
      _titleTextField.resignFirstResponder()
      _summaryTextField.resignFirstResponder()
      _currentSubgoalCell?.stopEditing()
   }
}

extension GoalDetailsViewController: SubgoalsTableViewCellDelegate
{
   func subgoalBeganEditing(cell: SubgoalsTableViewCell)
   {
      _currentSubgoalCell = cell
   }
   
   func subgoalCellFinishedEditing(cell: SubgoalsTableViewCell)
   {
      if let indexPath = _subgoalsTableView.indexPathForCell(cell),
      let child = goal?.childGoalForIndexPath(indexPath) {
         child.managedObjectContext?.saveOrRollback()
      }
      
      _currentSubgoalCell = nil
   }
}
