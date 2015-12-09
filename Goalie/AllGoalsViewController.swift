//
//  FirstViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class AllGoalsViewController: UIViewController, ManagedObjectContextSettable, UITableViewDelegate
{
   @IBOutlet private weak var _allGoalsTableView: UITableView!
   
   var managedObjectContext: NSManagedObjectContext!
   
   private typealias DataProvider = FetchedResultsDataProvider<AllGoalsViewController>
   private var _tableViewDataSource: TableViewDataSource<AllGoalsViewController, DataProvider, AllGoalsTableViewCell>!
   private var _dataProvider: DataProvider!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, AllGoalsViewController>!
   
   private var _defaultFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   private var _goalPresenter: GoalPresenter<AllGoalsViewController>!
   private let _tableViewCellID = "AllGoalsCellIdentifier"
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "All Goals"
      automaticallyAdjustsScrollViewInsets = false
      
      _goalPresenter = GoalPresenter(presentingController: self)
      setupTableViewDataSourceAndDelegate()
   }
   
   private func setupTableViewDataSourceAndDelegate()
   {
      _allGoalsTableView.registerNib(UINib(nibName: "AllGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: _tableViewCellID)
      _dataProvider = FetchedResultsDataProvider(fetchedResultsController: _defaultFRC, delegate: self)
      _tableViewDataSource = TableViewDataSource(tableView: _allGoalsTableView, dataProvider: _dataProvider, delegate: self)
      _tableViewDelegate = TableViewDelegate(tableView: _allGoalsTableView, dataProvider: _dataProvider, delegate: self)
   }
   
   // MARK: - IBActions
   @IBAction func addNewGoal()
   {
      _goalPresenter.createAndPresentNewGoal()
   }
}

// MARK: - DataProviderDelegate
extension AllGoalsViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      _tableViewDataSource.processUpdates(updates)
   }
}

// MARK: - DataSourceDelegate
extension AllGoalsViewController: DataSourceDelegate
{
   func cellIdentifierForObject(object: Object) -> String
   {
      return _tableViewCellID
   }
   
   func configureCell(cell: UITableViewCell)
   {
   }
}

// MARK: - TableViewDelegateProtocol
extension AllGoalsViewController: TableViewDelegateProtocol
{
   func objectSelected(goal: Goal)
   {
      _goalPresenter.presentDetailsForGoal(goal)
   }
   
   func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat
   {
      return 55
   }
}