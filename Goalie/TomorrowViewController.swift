//
//  TomorrowViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/9/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class TomorrowViewController: UIViewController, ManagedObjectContextSettable
{
   var managedObjectContext: NSManagedObjectContext!
   @IBOutlet weak private var _tableView: UITableView!
   
   private typealias DataProvider = FetchedResultsDataProvider<TomorrowViewController>
   private var _tableViewDataSource: TableViewDataSource<TomorrowViewController, DataProvider, TomorrowTableViewCell>!
   private var _dataProvider: DataProvider!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, TomorrowViewController>!
   
   private var _defaultFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ChildGoalsFetchRequestProvider.fetchRequestForActiveState(.Tomorrow), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   private var _goalPresenter: GoalPresenter<TomorrowViewController>!
   private var _emptyTableViewDataSourceDelegate: EmptyTableViewDataSourceDelegate!
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _setupTableViewDataSourceAndDelegate()
      _goalPresenter = GoalPresenter(presentingController: self)
      
      _emptyTableViewDataSourceDelegate = EmptyTableViewDataSourceDelegate(tableView: _tableView, title: "No sub-goals for tomorrow.", description: "Keep track of sub-goals by adding them to tomorrow.", buttonTappedBlock: { () -> Void in
         self._goalPresenter.createAndPresentNewGoal()
      })
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _tableView.reloadEmptyDataSet()
   }
   
   // MARK: - Private
   private func _setupTableViewDataSourceAndDelegate()
   {
      _tableView.registerNib(UINib(nibName: "TomorrowTableViewCell", bundle: nil), forCellReuseIdentifier: "TomorrowTableViewCellIdentifier")
      _dataProvider = FetchedResultsDataProvider(fetchedResultsController: _defaultFRC, delegate: self)
      _tableViewDataSource = TableViewDataSource(tableView: _tableView, dataProvider: _dataProvider, delegate: self)
      _tableViewDelegate = TableViewDelegate(tableView: _tableView, dataProvider: _dataProvider, delegate: self)
      
      let removeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove", handler: { (rowAction, indexPath) -> Void in
         
         let goal = self._dataProvider.objectAtIndexPath(indexPath)
         self.managedObjectContext.performChanges({ () -> () in
            goal.activeState = .Idle
         })
      })
      removeAction.backgroundColor = UIColor(red: 25/255.0, green: 140/255.0, blue: 1, alpha: 1)
      _tableViewDelegate.editActions = [removeAction]
   }
   
   // MARK: - IBActions
   @IBAction private func _tapGestureRecognized(recognizer: UIGestureRecognizer)
   {
      let location = recognizer.locationInView(_tableView)
      if let indexPath = _tableView.indexPathForRowAtPoint(location) {
         let subgoal = _dataProvider.objectAtIndexPath(indexPath)
         
         self.managedObjectContext.performChanges({ () -> () in
            subgoal.completed = !subgoal.completed
         })
      }
   }
   
   @IBAction func _longPressRecognized(recognizer: UIGestureRecognizer)
   {
      if recognizer.state == .Began {
         let location = recognizer.locationInView(_tableView)
         if let indexPath = _tableView.indexPathForRowAtPoint(location) {
            let subgoal = _dataProvider.objectAtIndexPath(indexPath)
            _goalPresenter.presentDetailsForSubgoal(subgoal)
         }
      }
   }
}

// MARK: - DataProviderDelegate
extension TomorrowViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      _tableViewDataSource.processUpdates(updates)
   }
}

// MARK: - DataSourceDelegate
extension TomorrowViewController: DataSourceDelegate
{
   func cellIdentifierForObject(object: Object) -> String
   {
      return "TomorrowTableViewCellIdentifier"
   }
   
   func configureCell(cell: UITableViewCell)
   {
   }
}

// MARK: - TableViewDelegateProtocol
extension TomorrowViewController: TableViewDelegateProtocol
{
   func objectSelected(goal: Goal)
   {
   }
   
   func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat
   {
      return 60
   }
}
