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
   private var _emptySubgoalAtBottom: Bool {
      var emptySubgoalAtBottom = false
      if let lastSubgoal = _goal.subgoals.last {
         emptySubgoalAtBottom = lastSubgoal.title == ""
      }
      return emptySubgoalAtBottom
   }
   private var _keyboardIsShowing: Bool {
      return (_currentSubgoalCell != nil) || _titleTextField.isFirstResponder() || _summaryTextField.isFirstResponder()
   }
   
   @IBOutlet private weak var _monthSelectorContainer: UIView!
   @IBOutlet private weak var _parentKeyboardAvoidingScrollView: TPKeyboardAvoidingScrollView!
   @IBOutlet private weak var _titleTextField: JVFloatLabeledTextField! { didSet {
      _titleTextField.textColor = UIColor.whiteColor()
      _titleTextField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSForegroundColorAttributeName : ThemeTabBarColor.colorWithAlphaComponent(0.8)])
      }
   }
   @IBOutlet private weak var _summaryTextField: JVFloatLabeledTextField! { didSet {
      _summaryTextField.textColor = UIColor.whiteColor()
      _summaryTextField.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSForegroundColorAttributeName : ThemeTabBarColor.colorWithAlphaComponent(0.8)])
      }
   }
   @IBOutlet private weak var _topNavigationBar: GoalieNavigationBar! { didSet { _cancelBarButtonItem = _topNavigationBar.leftBarButtonItem }}
   @IBOutlet private weak var _subgoalsNavigationBar: GoalieNavigationBar! { didSet {
         let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
         _subgoalsNavigationBar.addGestureRecognizer(tapRecognizer)
      }
   }
   @IBOutlet private weak var _subgoalsTableView: UITableView! { didSet {
         let nib = UINib(nibName: "SubgoalsTableViewCell", bundle: nil)
         _subgoalsTableView.registerNib(nib, forCellReuseIdentifier: SubgoalsCellIdentifier)
      }
   }
   
   private var _monthSelectorViewController = MonthSelectorViewController()
   private var _shouldGiveNextCreatedCellFocus = false

   private typealias DataProvider = FetchedResultsDataProvider<GoalDetailsViewController>
   private var _tableViewDataSource: TableViewDataSource<GoalDetailsViewController, DataProvider, SubgoalsTableViewCell>!
   private var _dataProvider: DataProvider!
   
   // MARK: - Init
   convenience init() {
      self.init(nibName: nil, bundle: nil)
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _subgoalsNavigationBar.updateTitleFontSize(18)
      _monthSelectorContainer.backgroundColor = ThemeTabBarColor
      _monthSelectorContainer.addSubview(_monthSelectorViewController.view)
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      let insetAmount = _monthSelectorViewController.paddingBetweenMonths * 0.5
      _monthSelectorViewController.view.frame = _monthSelectorContainer.bounds.insetBy(dx: -insetAmount, dy: insetAmount).integral
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _updateTitlesAndUI()
      _hideOrShowCancelButton()
      _setupSubgoalsTable()
      
      _monthSelectorViewController.selectedMonth = _goal.month
   }
   
   override func viewDidAppear(animated: Bool)
   {
      super.viewDidAppear(animated)
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
      dismissViewControllerAnimated(true, completion: nil)
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
   
   private func _advanceCellFocusFromIndexPath(indexPath: NSIndexPath)
   {
      if let nextSubgoalCell = _subgoalCellForIndexPath(indexPath.next) {
         nextSubgoalCell.startEditing()
      }
      else {
         // Try one more time:
         _subgoalsTableView.scrollByPoints(1)
         if let nextSubgoalCell = _subgoalCellForIndexPath(indexPath.next) {
            nextSubgoalCell.startEditing()
         } else {
            _currentSubgoalCell?.stopEditing()
         }
      }
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
   
   func temporarilyHighlightSubgoal(subgoal: Goal)
   {
      let subgoalIndexPath = NSIndexPath(goal: subgoal)
      _subgoalsTableView.flashCellAtIndexPath(subgoalIndexPath, duration: 0.6)
   }
   
   // MARK: - IBActions
   @IBAction private func doneButtonPressed()
   {
      if _keyboardIsShowing {
         dismissKeyboard()
      }
      else {
         managedObjectContext.performChanges({() -> () in
            // we don't need to save here because this entire block will save after it's finished
            self._goal.deleteEmptySubgoalsAndSave(false)
            
            // TODO: validate the input in a way that isn't this:
            self._goal.title = self._titleTextField.text ?? "Bro, do you even set titles?"
            self._goal.title = self._goal.title == "" ? "Bro, do you even set titles?" : self._goal.title
            self._goal.summary = self._summaryTextField.text ?? ""
            self._goal.month = self._monthSelectorViewController.selectedMonth
         })
         _dismissSelf()
      }
   }
   
   @IBAction private func cancelButtonPressed()
   {
      if _keyboardIsShowing {
         dismissKeyboard()
      }
      else {
         _goal.deleteWithCompletion {
            self._dismissSelf()
         }
      }
   }
}

extension GoalDetailsViewController: SubgoalsTableViewCellDelegate
{
   func subgoalBeganEditing(cell: SubgoalsTableViewCell)
   {
      _currentSubgoalCell = cell
      _parentKeyboardAvoidingScrollView.scrollEnabled = false
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
      _parentKeyboardAvoidingScrollView.scrollEnabled = true
   }
   
   // These next two methods are so fucking messy.  They produce the exact behavior that Nico wants though...
   func titleTextFieldShouldReturnForCell(cell: SubgoalsTableViewCell) -> Bool
   {
      var shouldReturn = false
      guard let cellIndexPath = _subgoalsTableView.indexPathForCell(cell) else { return shouldReturn }
      if _subgoalsTableView.indexPathIsLast(cellIndexPath) {
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
                  _subgoalsTableView.indexPathIsLast(indexPath) {
                     newSubgoalCell.startEditing()
                     return
               }
               else {
                  // Try one more time
                  _subgoalsTableView.scrollByPoints(1)
                  if let newSubgoalCell = _subgoalCellForIndexPath(indexPath) where
                     _subgoalsTableView.indexPathIsLast(indexPath) {
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
      (cell as? SubgoalsTableViewCell)?.delegate = self
   }
}