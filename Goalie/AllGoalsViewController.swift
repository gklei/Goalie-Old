//
//  FirstViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

class AllGoalsViewController: UIViewController, ManagedObjectContextSettable
{
   @IBOutlet private weak var _allGoalsTableView: UITableView!
   
   var managedObjectContext: NSManagedObjectContext!
   
   private typealias Data = FetchedResultsDataProvider<AllGoalsViewController>
   private var _tableViewDataSource: TableViewDataSource<AllGoalsViewController, Data, AllGoalsTableViewCell>!
   private var _dataProvider: Data!
   private var _tableViewDelegate: AllGoalsTableViewDelegate<Data>!
   
   private lazy var _goalFetchRequest: NSFetchRequest = {
      let request = Goal.sortedFetchRequest
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      return request
   }()
   
   // For testing
   private let _goalTitles = ["A", "B", "C", "D", "E", "F", "G"]
   private var _goalTitleIndex = 0
   
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
      _allGoalsTableView.registerNib(UINib(nibName: "AllGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllGoalsCellIdentifier")
      
      let frc = NSFetchedResultsController(fetchRequest: _goalFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      _dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
      _tableViewDataSource = TableViewDataSource(tableView: _allGoalsTableView, dataProvider: _dataProvider, delegate: self)
      _tableViewDelegate = AllGoalsTableViewDelegate(tableView: _allGoalsTableView, managedObjectContext: managedObjectContext, dataProvider: _dataProvider)
   }
   
   // MARK: - IBActions
   @IBAction func addNewGoal()
   {
      managedObjectContext.performChanges { () -> () in
         let title = self._goalTitles[self._goalTitleIndex++ % self._goalTitles.count]
         Goal.insertIntoContext(self.managedObjectContext, withTitle: title, summary: "hi there")
      }
   }
   
   @IBAction func deleteFirst()
   {
      if _dataProvider.numberOfItemsInSection(0) > 0
      {
         let firstGoal: Goal = _dataProvider.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
         firstGoal.managedObjectContext?.performChanges({ () -> () in
            firstGoal.managedObjectContext?.deleteObject(firstGoal)
         })
      }
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
      return "AllGoalsCellIdentifier"
   }
}

