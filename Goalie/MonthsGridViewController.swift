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
   var managedObjectContext: NSManagedObjectContext!
   
   @IBOutlet weak private var _monthGridCollectionView: UICollectionView!
   private let _collectionViewCellID = "MonthCellIdentifier"
   private var _parentGoalsProvider: ParentGoalsDataProvider!
   
   private var _parentGoalsFRC: NSFetchedResultsController {
      return NSFetchedResultsController(fetchRequest: ParentGoalsFetchRequestProvider.fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
   }
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      navigationItem.title = "Months"
      automaticallyAdjustsScrollViewInsets = false
      
      setupFlowLayout()
      registerCellNib()
      
      _parentGoalsProvider = ParentGoalsDataProvider(managedObjectContext: managedObjectContext, delegate: self)
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

extension MonthsGridViewController: ParentGoalsDataProviderDelegate
{
   func parentGoalsDidChange()
   {
      _monthGridCollectionView.reloadData()
   }
}