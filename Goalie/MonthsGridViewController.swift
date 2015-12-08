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
         _detailsViewController.managedObjectContext = managedObjectContext
      }
   }
   
   @IBOutlet weak private var _monthGridCollectionView: UICollectionView!
   private let _collectionViewCellID = "MonthCellIdentifier"
   private var _parentGoalsProvider: ParentGoalsDataProvider!
   
   private var _parentGoalsFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   private var _detailsViewController = GoalDetailsViewController()
   private var _shouldReloadCollectionViewOnChange = true
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "Months"
      automaticallyAdjustsScrollViewInsets = false
      
      setupFlowLayout()
      registerCellNib()
      
      _parentGoalsProvider = ParentGoalsDataProvider(managedObjectContext: managedObjectContext)
   }
   
   override func viewWillAppear(animated: Bool)
   {
      super.viewWillAppear(animated)
      _monthGridCollectionView.reloadData()
   }
   
   private func setupFlowLayout()
   {
      let collectionViewLayout = _monthGridCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
      
      let padding: CGFloat = 6.0
      let width: CGFloat = (view.bounds.width / 3.0) - (padding * 2.0)
      
      collectionViewLayout.minimumInteritemSpacing = 0
      collectionViewLayout.itemSize = CGSizeMake(width, width)
      collectionViewLayout.sectionInset = UIEdgeInsets(top: padding * 3, left: padding * 1.5, bottom: padding * 1.5, right: padding * 1.5)
   }
   
   private func registerCellNib()
   {
      _monthGridCollectionView.registerNib(UINib(nibName: "MonthCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: _collectionViewCellID)
   }
   
   @IBAction func addNewGoalButtonPressed()
   {
      let newGoal = Goal.insertIntoContext(managedObjectContext, title: "", summary: "")
      
      _detailsViewController.configureWithGoal(newGoal, allowCancel: true)
      presentViewController(_detailsViewController, animated: true, completion: nil)
   }
}

extension MonthsGridViewController: UICollectionViewDataSource
{
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      return NumberOfMonths
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(_collectionViewCellID, forIndexPath: indexPath) as! MonthCollectionViewCell
      
      let title = monthTitleForIndexPath(indexPath)
      cell.updateTitle(title)
      
      let month = Month(rawValue: indexPath.row)!
      let goalCount = _parentGoalsProvider.parentGoalsInMonth(month).count
      
      cell.updateGoalCount(goalCount)
      return cell
   }
}