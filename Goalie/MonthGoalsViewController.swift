//
//  MonthGoalsViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class MonthGoalsViewController: UIViewController, ManagedObjectContextSettable
{
   var managedObjectContext: NSManagedObjectContext!
   
   private typealias DataProvider = FetchedResultsDataProvider<MonthGoalsViewController>
   private var _dataProvider: DataProvider!
   private var _tableViewDataSource: TableViewDataSource<MonthGoalsViewController, DataProvider, MonthGoalsTableViewCell>!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, MonthGoalsViewController>!
   
   private let _tableViewCellID = "MonthGoalsCellIdentifier"
   private var _goalPresenter: GoalPresenter<MonthGoalsViewController>!
   
   @IBOutlet private weak var _monthGoalsTableView: UITableView!
   private var _month: Month = .Jan
   
   // MARK: - Init
   convenience init()
   {
      self.init(nibName: nil, bundle: nil)
   }
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {  
      super.viewDidLoad()
      automaticallyAdjustsScrollViewInsets = false
      
      _monthGoalsTableView.registerNib(UINib(nibName: "MonthGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: _tableViewCellID)
      _goalPresenter = GoalPresenter(presentingController: self)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      navigationItem.title = "\(_month.fullName) Goals"
      
      _setupTableView()
   }
   
   // MARK: - Private
   private func _setupTableView()
   {
      _dataProvider = _dataProviderForMonth(_month)
      _tableViewDataSource = TableViewDataSource(tableView: _monthGoalsTableView, dataProvider: _dataProvider, delegate: self)
      _tableViewDelegate = TableViewDelegate(tableView: _monthGoalsTableView, dataProvider: _dataProvider, delegate: self)
   }
   
   private func _dataProviderForMonth(month: Month) -> DataProvider
   {
      let frc = NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequestForMonth(month), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      return FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
   }
   
   // MARK: - Public
   func configureWithMonth(month: Month)
   {
      _month = month
   }
   
   // MARK: - IBActions
   @IBAction func addNewGoalButtonPressed()
   {
      _goalPresenter.createAndPresentNewGoalWithMonth(_month)
   }
}

// MARK: - DataProviderDelegate
extension MonthGoalsViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      _tableViewDataSource.processUpdates(updates)
   }
}

// MARK: - DataSourceDelegate
extension MonthGoalsViewController: DataSourceDelegate
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
extension MonthGoalsViewController: TableViewDelegateProtocol
{
   func objectSelected(goal: Goal)
   {
      _goalPresenter.presentDetailsForGoal(goal)
   }
}