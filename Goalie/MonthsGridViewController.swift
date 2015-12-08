//
//  SecondViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit
import CoreData

private let NumberOfMonths = 12

class MonthsGridViewController: UIViewController, ManagedObjectContextSettable
{
   var managedObjectContext: NSManagedObjectContext! {
      didSet {
         _parentGoalsProvider = ParentGoalsDataProvider(managedObjectContext: managedObjectContext)
      }
   }

   @IBOutlet weak private var _monthGoalsSegue: UIStoryboardSegue!
   @IBOutlet weak private var _monthGridCollectionView: UICollectionView! {
      didSet {
         _monthGridCollectionView.registerNib(UINib(nibName: "MonthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: _collectionViewCellID)
      }
   }
   
   private let _collectionViewCellID = "MonthCellIdentifier"
   private var _parentGoalsProvider: ParentGoalsDataProvider!
   
   private var _goalPresenter: GoalPresenter<MonthsGridViewController>!
   private var _selectedMonth: Month?
   
   private var _parentGoalsFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "Months"
      automaticallyAdjustsScrollViewInsets = false
      
      _updateBackBarButtonItem()
      _setupCollectionViewLayout()
      
      _goalPresenter = GoalPresenter(presentingController: self)
      _monthGridCollectionView.delegate = self
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _monthGridCollectionView.reloadData()
   }
   
   // MARK: - Private
   private func _setupCollectionViewLayout()
   {
      let collectionViewLayout = _monthGridCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
      
      let padding: CGFloat = 6.0
      let width: CGFloat = (view.bounds.width / 3.0) - (padding * 2.0)
      
      collectionViewLayout.minimumInteritemSpacing = 0
      collectionViewLayout.itemSize = CGSizeMake(width, width)
      collectionViewLayout.sectionInset = UIEdgeInsets(top: padding * 3, left: padding * 1.5, bottom: padding * 1.5, right: padding * 1.5)
   }
   
   private func _updateBackBarButtonItem()
   {
      let updatedButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
      let attrs = Theme.titleTextAttributesForComponent(.NavBarButtonItem)
      updatedButtonItem.setTitleTextAttributes(attrs, forState: .Normal)
      navigationItem.backBarButtonItem = updatedButtonItem
   }
   
   // MARK: IBActions
   @IBAction func addNewGoalButtonPressed()
   {
      _goalPresenter.createAndPresentNewGoal()
   }
   
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   {
      if let monthGoalsViewController = segue.destinationViewController as? MonthGoalsViewController,
      let selectedMonth = _selectedMonth {
         monthGoalsViewController.managedObjectContext = managedObjectContext
         monthGoalsViewController.configureWithMonth(selectedMonth)
      }
   }
}

// MARK: - UICollectionViewDataSource
extension MonthsGridViewController: UICollectionViewDataSource
{
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      return NumberOfMonths
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(_collectionViewCellID, forIndexPath: indexPath) as! MonthCollectionViewCell
      
      let month = Month(rawValue: indexPath.row)!
      let goalCount = _parentGoalsProvider.parentGoalsInMonth(month).count
      
      cell.updateTitle(month.text)
      cell.updateGoalCount(goalCount)
      
      return cell
   }
}

extension MonthsGridViewController: UICollectionViewDelegate
{
   func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
   {
      _selectedMonth = Month(rawValue: indexPath.row)
      performSegueWithIdentifier("ShowGoalsForMonthSegue", sender: nil)
   }
}