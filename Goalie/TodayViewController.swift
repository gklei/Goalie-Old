//
//  TodayViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/9/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class TodayViewController: UIViewController, ManagedObjectContextSettable
{
   var managedObjectContext: NSManagedObjectContext!
   @IBOutlet weak private var _tableView: UITableView!
   
   
   private typealias DataProvider = FetchedResultsDataProvider<TodayViewController>
   private var _tableViewDataSource: TableViewDataSource<TodayViewController, DataProvider, TodayTableViewCell>!
   private var _dataProvider: DataProvider!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, TodayViewController>!
   
   private var _defaultFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ChildGoalsFetchRequestProvider.fetchRequestForActiveState(.Today), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   private var _goalPresenter: GoalPresenter<TodayViewController>!
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _setupTableViewDataSourceAndDelegate()
      _goalPresenter = GoalPresenter(presentingController: self)
   }
   
   // MARK: - IBActions
   @IBAction private func _tapGestureRecognized(recognizer: UIGestureRecognizer)
   {
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