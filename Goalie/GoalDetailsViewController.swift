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
   private var _goal: Goal? {
      didSet {
         if let unwrappedGoal = _goal {
            _childrenFetchRequest = unwrappedGoal.childrenFetchRequest
            _childrenFetchRequest?.returnsObjectsAsFaults = false
            _childrenFetchRequest?.fetchBatchSize = 20
         }
      }
   }

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
         _subgoalsTableView.registerNib(nib, forCellReuseIdentifier: SubgoalsCellIdentifier)
         
         // A trick for making it so that separators don't display for empty cells
         let size = CGSize(width: 0, height: 1)
         _subgoalsTableView.tableFooterView = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
      }
   }
   
   private typealias DataProvider = FetchedResultsDataProvider<GoalDetailsViewController>
   private var _tableViewDataSource: TableViewDataSource<GoalDetailsViewController, DataProvider, SubgoalsTableViewCell>!
   private var _dataProvider: DataProvider!
   private var _childrenFetchRequest: NSFetchRequest?
   private var _defaultFRC: NSFetchedResultsController? {
      guard let childrenFR = _childrenFetchRequest else {return nil}
      return NSFetchedResultsController(fetchRequest: childrenFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
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
      _setupUI()
      
      if let frc = _defaultFRC
      {
         _dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
         _tableViewDataSource = TableViewDataSource(tableView: _subgoalsTableView, dataProvider: _dataProvider, delegate: self)
      }
   }
   
   // MARK: - Private / Internal
   private func _setupUI()
   {
      _titleTextField.text = _goal?.title
      _summaryTextField.text = _goal?.summary
      
      let title = _goal != nil ? "Details" : "Create"
      _topNavigationBar.updateTitle(title)
   }
   
   private func _dismissSelf()
   {
      _goal = nil
      dismissKeyboard()
      self.dismissViewControllerAnimated(false, completion: nil)
   }
   
   internal func dismissKeyboard()
   {
      _titleTextField.resignFirstResponder()
      _summaryTextField.resignFirstResponder()
      _currentSubgoalCell?.stopEditing()
   }
   
   // MARK: - Public
   func configureWithGoal(goal: Goal?)
   {
      self._goal = goal
   }
   
   // MARK: - IBActions
   @IBAction func doneButtonPressed()
   {
      if let goal = _goal
      {
         managedObjectContext.performChanges({() -> () in
            goal.title = self._titleTextField.text ?? "No title set"
            goal.summary = self._summaryTextField.text ?? ""
         })
      }
      _dismissSelf()
   }
   
   @IBAction func cancelButtonPressed()
   {
      managedObjectContext.rollback()
      _dismissSelf()
   }
   
   @IBAction func addSubgoalsButtonPressed()
   {
      if let parent = self._goal {
         Goal.insertIntoContext(managedObjectContext, title: "", parent: parent)
      }
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
      let child = _goal?.childGoalForIndexPath(indexPath) {
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
