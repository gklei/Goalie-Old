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
   
   var managedObjectContext: NSManagedObjectContext! {
      didSet {
         _detailsViewController.managedObjectContext = managedObjectContext
      }
   }
   
   private typealias DataProvider = FetchedResultsDataProvider<AllGoalsViewController>
   private var _tableViewDataSource: TableViewDataSource<AllGoalsViewController, DataProvider, AllGoalsTableViewCell>!
   private var _dataProvider: DataProvider!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, AllGoalsViewController>!
   
   private lazy var _goalFetchRequest: NSFetchRequest = {
      let request = Goal.sortedFetchRequest
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      return request
   }()
   
   private var _defaultFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: _goalFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   private let _detailsViewController = GoalDetailsViewController()
   private let _tableViewCellID = "AllGoalsCellIdentifier"
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "All Goals"
      automaticallyAdjustsScrollViewInsets = false
      
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
      let newGoal = Goal.insertIntoContext(managedObjectContext, title: "", summary: "")
      
      _detailsViewController.configureWithGoal(newGoal, allowCancel: true)
      presentViewController(_detailsViewController, animated: true, completion: nil)
   }
   
   private func presentDetailsForGoal(goal: Goal)
   {
      _detailsViewController.configureWithGoal(goal, allowCancel: false)
      presentViewController(_detailsViewController, animated: true, completion: nil)
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
      presentDetailsForGoal(goal)
   }
}

