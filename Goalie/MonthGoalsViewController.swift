//
//  MonthGoalsViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/8/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData
import DZNEmptyDataSet

private let MonthGoalsCellIdentifier = "MonthGoalsCellIdentifier"

class MonthGoalsViewController: UIViewController, ManagedObjectContextSettable
{
   @IBOutlet private weak var _monthGoalsTableView: UITableView! {
      didSet {
         _monthGoalsTableView.registerNib(UINib(nibName: "MonthGoalsTableViewCell", bundle: nil), forCellReuseIdentifier: MonthGoalsCellIdentifier)
      }
   }
   var managedObjectContext: NSManagedObjectContext!
   
   private typealias DataProvider = FetchedResultsDataProvider<MonthGoalsViewController>
   private var _dataProvider: DataProvider!
   private var _tableViewDataSource: TableViewDataSource<MonthGoalsViewController, DataProvider, MonthGoalsTableViewCell>!
   private var _tableViewDelegate: TableViewDelegate<DataProvider, MonthGoalsViewController>!
   
   private var _goalPresenter: GoalPresenter<MonthGoalsViewController>!
   private var _month: Month = .Jan
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {  
      super.viewDidLoad()
      automaticallyAdjustsScrollViewInsets = false
      
      _monthGoalsTableView.emptyDataSetSource = self
      _monthGoalsTableView.emptyDataSetDelegate = self
      _goalPresenter = GoalPresenter(presentingController: self)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      navigationItem.title = "\(_month.fullName) Goals"
      
      _setupTableView()
      _monthGoalsTableView.reloadEmptyDataSet()
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
      return MonthGoalsCellIdentifier
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
   
   func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat
   {
      return 86
   }
}

extension MonthGoalsViewController: DZNEmptyDataSetSource
{
   func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      let text = "No Goals for \(_month.fullName)."
      let attribs = [
         NSFontAttributeName: UIFont(name: "Menlo-Bold", size: 18)!,
         NSForegroundColorAttributeName: UIColor.darkGrayColor()
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      let text = "Add new goals and set the target month."
      
      let para = NSMutableParagraphStyle()
      para.lineBreakMode = NSLineBreakMode.ByWordWrapping
      para.alignment = NSTextAlignment.Center
      
      let attribs = [
         NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 12)!,
         NSForegroundColorAttributeName: UIColor.lightGrayColor(),
         NSParagraphStyleAttributeName: para
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
      let text = "Create a Goal"
      let attribs = [
         NSFontAttributeName: UIFont(name: "Menlo-Bold", size: 16)!,
         NSForegroundColorAttributeName: UIColor.blackColor()
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
}

extension MonthGoalsViewController: DZNEmptyDataSetDelegate
{
   func emptyDataSetDidTapButton(scrollView: UIScrollView!)
   {
      _goalPresenter.createAndPresentNewGoalWithMonth(_month)
   }
   
   func emptyDataSetWillDisappear(scrollView: UIScrollView!)
   {
      _monthGoalsTableView.showSeparatorsForEmptyCells(true)
   }
   
   func emptyDataSetWillAppear(scrollView: UIScrollView!)
   {
      _monthGoalsTableView.showSeparatorsForEmptyCells(false)
   }
}
