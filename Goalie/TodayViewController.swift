//
//  TodayViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/9/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

class TodayViewController: UIViewController, ManagedObjectContextSettable
{
   var managedObjectContext: NSManagedObjectContext!
   @IBOutlet weak private var _tableView: UITableView!
   @IBOutlet weak private var _navBar: GoalieNavigationBar!
   
   private typealias DataProvider = FetchedResultsDataProvider<TodayViewController>
   private var _tableViewDataSource: TableViewDataSource<TodayViewController, DataProvider, TodayTableViewCell>!
   private var _dataProvider: DataProvider!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, TodayViewController>!
   
   private var _defaultFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ChildGoalsFetchRequestProvider.fetchRequestForActiveState(.Today), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   private var _goalPresenter: GoalPresenter<TodayViewController>!
   private var _emptyTableViewDataSourceDelegate: EmptyTableViewDataSourceDelegate!
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _setupTableViewDataSourceAndDelegate()
      
      _navBar.updateTitleFontSize(14)
      _navBar.updateTitleColor(UIColor.lightPurpleTextColor())
      
      let backgroundColor = UIColor(red: 59/255.0, green: 63/255.0, blue: 90/255.0, alpha: 1)
      _navBar.updateBackgroundColor(UIColor.clearColor())
      view.backgroundColor = backgroundColor
      _tableView.backgroundColor = backgroundColor
      let navBarFont = UIFont(name: "AvenirNext-Bold", size: 14)!
      _navBar.updateTitleFont(navBarFont)
      
      _goalPresenter = GoalPresenter(presentingController: self)
      _emptyTableViewDataSourceDelegate = EmptyTableViewDataSourceDelegate(tableView: _tableView, title: "No sub-goals for today.", description: "Keep track of sub-goals by adding them to today.", buttonTappedBlock: { () -> Void in
         self._goalPresenter.createAndPresentNewGoal()
      })
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _tableView.reloadEmptyDataSet()
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
   
   @IBAction private func _longPressGestureRecognized(recognizer: UIGestureRecognizer)
   {
      if recognizer.state == .Began {
         let location = recognizer.locationInView(_tableView)
         if let indexPath = _tableView.indexPathForRowAtPoint(location) {
            let subgoal = _dataProvider.objectAtIndexPath(indexPath)
            _goalPresenter.presentDetailsForSubgoal(subgoal)
         }
      }
   }
   
   // MARK: - Private
   private func _setupTableViewDataSourceAndDelegate()
   {
      _tableView.registerNib(UINib(nibName: "TodayTableViewCell", bundle: nil), forCellReuseIdentifier: "TodayTableViewCellIdentifier")
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
}

// MARK: - DataProviderDelegate
extension TodayViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      _tableViewDataSource.processUpdates(updates)
   }
}

// MARK: - DataSourceDelegate
extension TodayViewController: DataSourceDelegate
{
   func cellIdentifierForObject(object: Object) -> String
   {
      return "TodayTableViewCellIdentifier"
   }
   
   func configureCell(cell: UITableViewCell)
   {
   }
}

// MARK: - TableViewDelegateProtocol
extension TodayViewController: TableViewDelegateProtocol
{
   func objectSelected(goal: Goal)
   {
   }
   
   func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat
   {
      return 60
   }
}