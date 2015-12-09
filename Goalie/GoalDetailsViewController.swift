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
   private var _selectedMonth: Month {
      return _monthSelectorViewController.selectedMonth
   }

   var managedObjectContext: NSManagedObjectContext!
   private var _currentSubgoalCell: SubgoalsTableViewCell?
   private var _emptySubgoalAtBottom: Bool {
      var emptySubgoalAtBottom = false
      if let lastSubgoal = _goal.subgoals.last {
         emptySubgoalAtBottom = lastSubgoal.title == ""
      }
      return emptySubgoalAtBottom
   }
   
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
      }
   }
   
   @IBOutlet private weak var _monthSelectorContainer: UIView!
   private var _monthSelectorViewController = MonthSelectorViewController()
   
   private typealias DataProvider = FetchedResultsDataProvider<GoalDetailsViewController>
   private var _tableViewDataSource: TableViewDataSource<GoalDetailsViewController, DataProvider, SubgoalsTableViewCell>!
   private var _dataProvider: DataProvider!
   
   private var _shouldGiveNextCreatedCellFocus = false
   
   // MARK: - Init
   convenience init() {
      self.init(nibName: nil, bundle: nil)
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _subgoalsNavigationBar.updateTitleFontSize(18)
      
      _monthSelectorContainer.backgroundColor = UIColor.blackColor()
      _monthSelectorContainer.addSubview(_monthSelectorViewController.view)
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      
      let insetAmount = _monthSelectorViewController.paddingBetweenMonths * 0.5
      _monthSelectorViewController.view.frame = _monthSelectorContainer.bounds.insetBy(dx: insetAmount, dy: insetAmount).integral
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _updateTitlesAndUI()
      _hideOrShowCancelButton()
      _setupSubgoalsTable()
      
      _monthSelectorViewController.selectedMonth = _goal.month
      _createNewSubgoal()
   }
   
   // MARK: - Private / Internal
   private func _updateTitlesAndUI()
   {
      _titleTextField.text = _goal?.title
      _summaryTextField.text = _goal?.summary
      
      let title = (_shouldShowCancelButton == false) ? "Details" : "New Goal"
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
      _tableViewDataSource.allowEditingLast = false
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
   
   private func _createNewSubgoal()
   {
      Goal.insertIntoContext(managedObjectContext, title: "", parent: _goal)
   }
   
   private func _subgoalCellForIndexPath(indexPath: NSIndexPath) -> SubgoalsTableViewCell?
   {
      return _subgoalsTableView.cellForRowAtIndexPath(indexPath) as? SubgoalsTableViewCell
   }
   
   private func _indexPathIsLast(indexPath: NSIndexPath) -> Bool
   {
      return indexPath.row == _goal.subgoals.count - 1
   }
   
   private func _advanceCellFocusFromIndexPath(indexPath: NSIndexPath)
   {
      let nextCellIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: 0)
      if let nextSubgoalCell = _subgoalCellForIndexPath(nextCellIndexPath) {
         nextSubgoalCell.startEditing()
      }
      else {
         _scrollSubgoalsTableViewByOnePoint()
         // Try one more time:
         if let nextSubgoalCell = _subgoalCellForIndexPath(nextCellIndexPath) {
            nextSubgoalCell.startEditing()
         }
         else {
            _currentSubgoalCell?.stopEditing()
         }
      }
   }
   
   private func _scrollSubgoalsTableViewByOnePoint()
   {
      let offset = _subgoalsTableView.contentOffset
      _subgoalsTableView.contentOffset = CGPoint(x: offset.x, y: offset.y + 1)
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
   
   func giveTitleFocus()
   {
      _titleTextField.becomeFirstResponder()
   }
   
   // MARK: - IBActions
   @IBAction private func doneButtonPressed()
   {
      if let currentCell = _currentSubgoalCell {
         currentCell.stopEditing()
      }
      else {
         managedObjectContext.performChanges({() -> () in
            
            // we don't need to save here because this entire block will save after it's finished
            self._goal.deleteEmptySubgoalsAndSave(false)
            
            // TODO: validate the input in a way that isn't this:
            self._goal.title = self._titleTextField.text ?? "Bro, do you even set titles?"
            self._goal.title = self._goal.title == "" ? "Bro, do you even set titles?" : self._goal.title
            self._goal.summary = self._summaryTextField.text ?? ""
            self._goal.month = self._selectedMonth
         })
         _dismissSelf()
      }
   }
   
   @IBAction private func cancelButtonPressed()
   {
      managedObjectContext.rollback()
      _dismissSelf()
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
      let child = _goal.subgoalForIndexPath(indexPath) {
         child.managedObjectContext?.saveOrRollback()
      }
      
      if _emptySubgoalAtBottom == false {
         _createNewSubgoal()
      }
      
      _currentSubgoalCell = nil
   }
   
   // These next two methods are so fucking messy.  They produce the exact behavior that Nico wants though...
   func titleTextFieldShouldReturnForCell(cell: SubgoalsTableViewCell) -> Bool
   {
      var shouldReturn = false
      if let cellIndexPath = _subgoalsTableView.indexPathForCell(cell) {
         if _indexPathIsLast(cellIndexPath) {
            if cell.titleText == "" {
               shouldReturn = true
               cell.stopEditing()
            }
            else {
               shouldReturn = false
               _createNewSubgoal()
               _shouldGiveNextCreatedCellFocus = true
            }
         }
         else {
            shouldReturn = false
            _advanceCellFocusFromIndexPath(cellIndexPath)
         }
      }
      
      return shouldReturn
   }
   
   func returnKeyTypeForCell(cell: SubgoalsTableViewCell) -> UIReturnKeyType
   {
      var returnKeyType = UIReturnKeyType.Next
      if let lastSubgoal = _goal.subgoals.last
         where cell.subgoal == lastSubgoal {
            returnKeyType = .Default
      }
      return returnKeyType
   }
   
   func subgoalButtonPressedWithState(state: ActiveState, cell: SubgoalsTableViewCell)
   {
      var newState: ActiveState = .Idle
      switch state
      {
      case .Today:
         newState = cell.subgoal.activeState != .Today ? .Today : .Idle
         break
      case .Tomorrow:
         newState = cell.subgoal.activeState != .Tomorrow ? .Tomorrow : .Idle
         break
      case .Idle:
         break
      }
      managedObjectContext.performChanges { () -> () in
         cell.subgoal.activeState = newState
      }
   }
}

// MARK: - DataProviderDelegate
extension GoalDetailsViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      _tableViewDataSource.processUpdates(updates)
      
      if _shouldGiveNextCreatedCellFocus {
         _shouldGiveNextCreatedCellFocus = false
         guard let updates = updates else { return }
         for update in updates {
            switch update {
            case .Insert(let indexPath):
               if let newSubgoalCell = _subgoalCellForIndexPath(indexPath) where
                  _indexPathIsLast(indexPath) {
                     newSubgoalCell.startEditing()
                     return
               }
               else {
                  _scrollSubgoalsTableViewByOnePoint()
                  // Try one more time
                  if let newSubgoalCell = _subgoalCellForIndexPath(indexPath) where
                     _indexPathIsLast(indexPath) {
                        newSubgoalCell.startEditing()
                        return
                  }
                  else {
                     _currentSubgoalCell?.stopEditing()
                  }
               }
            default:
               return
            }
         }
      }
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
