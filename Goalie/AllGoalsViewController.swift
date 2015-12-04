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
   
   // For testing
   private let _goalTitles = ["A", "B", "C", "D", "E", "F", "G"]
   private var _goalTitleIndex = 0
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "All Goals"
      automaticallyAdjustsScrollViewInsets = false
      
      setupTableView()
   }
   
   private func setupTableView()
   {
      _allGoalsTableView.registerNib(UINib(nibName: "AllGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllGoalsCellIdentifier")
      
      let request = Goal.sortedFetchRequest
      request.returnsObjectsAsFaults = false
      request.fetchBatchSize = 20
      
      let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      _dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
      _tableViewDataSource = TableViewDataSource(tableView: _allGoalsTableView, dataProvider: _dataProvider, delegate: self)
   }
   
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

extension AllGoalsViewController: DataProviderDelegate
{
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Goal>]?)
   {
      print("data provider did update")
      _tableViewDataSource.processUpdates(updates)
   }
}

extension AllGoalsViewController: DataSourceDelegate
{
   func cellIdentifierForObject(object: Object) -> String
   {
      return "AllGoalsCellIdentifier"
   }
}

