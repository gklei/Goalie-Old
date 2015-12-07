//
//  GoalDetailsViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

let SubgoalsCellIdentifier = "SubgoalsCellIdentifier"

class GoalDetailsViewController: UIViewController, ManagedObjectContextSettable
{
   private var _goal: Goal!
   private var _shouldShowCancelButton: Bool!
   private var _cancelBarButtonItem: UIBarButtonItem?

   var managedObjectContext: NSManagedObjectContext!
   private var _currentSubgoalCell: SubgoalsTableViewCell?
   
   @IBOutlet private weak var _titleTextField: JVFloatLabeledTextField!
   @IBOutlet private weak var _summaryTextField: JVFloatLabeledTextField!
   
   @IBOutlet private weak var _topNavigationBar: GoalieNavigationBar! {
      didSet {
         _cancelBarButtonItem = _topNavigationBar.leftBarButtonItem
      }
   }
   @IBOutlet private weak var _subgoalsNavigationBar: GoalieNavigationBar! {
      didSet {
         let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
         _subgoalsNavigationBar.addGestureRecognizer(tapRecognizer)
      }
   }
   
   @IBOutlet private weak var _subgoalsTableView: UITableView! {
      didSet {
         let nib = UINib(nibName: "SubgoalsTableViewCell", bundle: nil)
         _subgoalsTableView.registerNib(nib, forCellReuseIdentifier: SubgoalsCellIdentifier)
         
         // A trick for making it so that separators don't display for empty cells
         let size = CGSize(width: 0, height: 1)
         _subgoalsTableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
      }
   }
   
   private typealias DataProvider = FetchedResultsDataProvider<GoalDetailsViewController>
   private var _tableViewDataSource: TableViewDataSource<GoalDetailsViewController, DataProvider, SubgoalsTableViewCell>!
   private var _dataProvider: DataProvider!
   
   // MARK: - Init
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _subgoalsNavigationBar.updateTitleFontSize(18)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _updateTitlesAndUI()
      _hideOrShowCancelButton()
      _setupSubgoalsTable()
   }
   
   // MARK: - Private / Internal
   private func _updateTitlesAndUI()
   {
      _titleTextField.text = _goal?.title
      _summaryTextField.text = _goal?.summary
      
      let title = _goal != nil ? "Details" : "Create"
      _topNavigationBar.updateTitle(title)
   }
   
   // when a new goal is created, we want to show the cancel button, but when viewing the details of a goal that has already been
   // created, we don't want to show it
   private func _hideOrShowCancelButton()
   {
      let leftBarButtonItem: UIBarButtonItem? = (_shouldShowCancelButton == true) ? _cancelBarButtonItem : nil
      _topNavigationBar.leftBarButtonItem = leftBarButtonItem
   }
   
   private func _setupSubgoalsTable()
   {
      _dataProvider = _dataProviderForGoal(_goal)
      _tableViewDataSource = TableViewDataSource(tableView: _subgoalsTableView, dataProvider: _dataProvider, delegate: self)
   }
   
   private func _dismissSelf()
   {
      dismissKeyboard()
      self.dismissViewControllerAnimated(false, completion: nil)
   }
   
   private func _dataProviderForGoal(goal: Goal) -> DataProvider
   {
      let frc = NSFetchedResultsController(fetchRequest: goal.childrenFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      return FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
   }
   
   internal func dismissKeyboard()
   {
      _titleTextField.resignFirstResponder()
      _summaryTextField.resignFirstResponder()
      _currentSubgoalCell?.stopEditing()
   }
   
   // MARK: - Public
   func configureWithGoal(goal: Goal, allowCancel: Bool)
   {
      _goal = goal
      _shouldShowCancelButton = allowCancel
   }
   
   // MARK: - IBActions
   @IBAction private func doneButtonPressed()
   {
      managedObjectContext.performChanges({() -> () in
         
         self._goal.deleteEmptySubgoalsAndSave(false)
         
         // TODO: validate the input in a way that isn't this:
         self._goal.title = self._titleTextField.text ?? "Why don't you set the title next time bro?"
         self._goal.title = self._goal.title == "" ? "Why don't you set the title next time bro?" : self._goal.title
         self._goal.summary = self._summaryTextField.text ?? ""
      })
      _dismissSelf()
   }
   
   @IBAction private func cancelButtonPressed()
   {
      managedObjectContext.rollback()
      _dismissSelf()
   }
   
   @IBAction private func addSubgoalsButtonPressed()
   {
      Goal.insertIntoContext(managedObjectContext, title: "", parent: _goal)
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
      let child = _goal.childGoalForIndexPath(indexPath) {
         child.managedObjectContext?.saveOrRollback()
      }
      
      _currentSubgoalCell = nil
   }
}

// MARK: - DataProviderDelegate
extension GoalDetailsViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      _tableViewDataSource.processUpdates(updates)
   }
}

// MARK: - DataSourceDelegate
extension GoalDetailsViewController: DataSourceDelegate
{
   func cellIdentifierForObject(object: Object) -> String
   {
      return SubgoalsCellIdentifier
   }
   
   func configureCell(cell: UITableViewCell)
   {
      if let subgoalsCell = cell as? SubgoalsTableViewCell {
         subgoalsCell.delegate = self
      }
   }
}
