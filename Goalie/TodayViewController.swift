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
      _tableView.emptyDataSetDelegate = self
      _tableView.emptyDataSetSource = self
      
      _goalPresenter = GoalPresenter(presentingController: self)
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

extension TodayViewController: DZNEmptyDataSetSource
{
   func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      let text = "No sub-goals for today."
      let attribs = [
         NSFontAttributeName: UIFont(name: "Menlo-Bold", size: 18)!,
         NSForegroundColorAttributeName: UIColor.darkGrayColor()
      ]
      
      return NSAttributedString(string: text, attributes: attribs)
   }
   
   func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
      let text = "Keep track of sub-goals by adding them to today."
      
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

extension TodayViewController: DZNEmptyDataSetDelegate
{
   func emptyDataSetDidTapButton(scrollView: UIScrollView!)
   {
      _goalPresenter.createAndPresentNewGoal()
   }
   
   func emptyDataSetWillDisappear(scrollView: UIScrollView!)
   {
      _tableView.showSeparatorsForEmptyCells(true)
   }
   
   func emptyDataSetWillAppear(scrollView: UIScrollView!)
   {
      _tableView.showSeparatorsForEmptyCells(false)
   }
}