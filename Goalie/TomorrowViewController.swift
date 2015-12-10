//
//  TomorrowViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/9/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

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
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      _setupTableViewDataSourceAndDelegate()
      _goalPresenter = GoalPresenter(presentingController: self)
   }
   
   // MARK: - Private
   private func _setupTableViewDataSourceAndDelegate()
   {
      _tableView.registerNib(UINib(nibName: "TomorrowTableViewCell", bundle: nil), forCellReuseIdentifier: "TomorrowTableViewCellIdentifier")
      _dataProvider = FetchedResultsDataProvider(fetchedResultsController: _defaultFRC, delegate: self)
      _tableViewDataSource = TableViewDataSource(tableView: _tableView, dataProvider: _dataProvider, delegate: self)
      _tableViewDelegate = TableViewDelegate(tableView: _tableView, dataProvider: _dataProvider, delegate: self)
   }
   
   // MARK: - IBActions
   @IBAction private func _tapGestureRecognized(recognizer: UIGestureRecognizer)
   {
      let location = recognizer.locationInView(_tableView)
      if let indexPath = _tableView.indexPathForRowAtPoint(location) {
         let subgoal = _dataProvider.objectAtIndexPath(indexPath)
         subgoal.completed = !subgoal.completed
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
