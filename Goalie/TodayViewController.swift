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
      _setupNavigationBar()
      _setupBackgroundColors()
      _setupTableViewDataSourceAndDelegate()
      _setupEmptyDataSourceDelegate()
      _goalPresenter = GoalPresenter(presentingController: self)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _tableView.reloadEmptyDataSet()
   }
   
   // MARK: - Private
   private func _setupNavigationBar()
   {
      let navBarFont = UIFont.boldGoalieFontWithSize(13)
      _navBar.updateTitleFont(navBarFont)
      _navBar.updateTitle("TODAY")
      _navBar.updateTitleColor(UIColor.lightPurpleTextColor())
      _navBar.makeTransparent()
   }
   
   private func _setupBackgroundColors()
   {
      view.backgroundColor = UIColor.lightPurpleBackgroundColor()
      _tableView.backgroundColor = UIColor.lightPurpleBackgroundColor()
   }
   
   private func _setupEmptyDataSourceDelegate()
   {
      _emptyTableViewDataSourceDelegate = EmptyTableViewDataSourceDelegate(tableView: _tableView, title: "Goals or sub-goals due today will show up here. Try adding some to stay organized.", description: "Keep track of sub-goals by adding them to tomorrow.", buttonTappedBlock: { () -> Void in
         self._goalPresenter.createAndPresentNewGoal()
      })
      _emptyTableViewDataSourceDelegate.useImage = true
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