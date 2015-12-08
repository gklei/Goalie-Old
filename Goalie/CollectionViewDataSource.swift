//
//  TableViewDataSource.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

class CollectionViewDataSource<Delegate: DataSourceDelegate, Data: DataProviderProtocol, Cell: UICollectionViewCell where Delegate.Object == Data.Object, Cell: ConfigurableCell, Cell.DataSource == Data.Object>: NSObject, UICollectionViewDataSource
{
   private let _collectionView: UICollectionView
   private let _dataProvider: Data
   private weak var _delegate: Delegate!
   
   required init(collectionView: UICollectionView, dataProvider: Data, delegate: Delegate)
   {
      _collectionView = collectionView
      _dataProvider = dataProvider
      _delegate = delegate
      super.init()
      
      _collectionView.dataSource = self
      _collectionView.reloadData()
   }
   
   var selectedObject: Data.Object? {
      guard let indexPath = _collectionView.indexPathsForSelectedItems()?.first else { return nil }
      return _dataProvider.objectAtIndexPath(indexPath)
   }
   
   func processUpdates(updates: [DataProviderUpdate<Data.Object>]?)
   {
      guard let updates = updates else { return _collectionView.reloadData() }
      _collectionView.performBatchUpdates({
         for update in updates
         {
            switch update
            {
            case .Insert(let indexPath):
               self._collectionView.insertItemsAtIndexPaths([indexPath])
            case .Update(let indexPath, let object):
               guard let cell = self._collectionView.cellForItemAtIndexPath(indexPath) as? Cell else { fatalError("wrong cell type") }
               cell.configureForObject(object)
            case .Move(let indexPath, let newIndexPath):
               self._collectionView.deleteItemsAtIndexPaths([indexPath])
               self._collectionView.insertItemsAtIndexPaths([newIndexPath])
            case .Delete(let indexPath):
               self._collectionView.deleteItemsAtIndexPaths([indexPath])
            }
         }}, completion: nil)
   }
   
   // MARK: UICollectionViewDataSource
   func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
      return _dataProvider.numberOfItemsInSection(section)
   }
   
   func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
   {
      let object = _dataProvider.objectAtIndexPath(indexPath)
      let identifier = _delegate.cellIdentifierForObject(object)
      guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? Cell else {
         fatalError("Unexpected cell type at \(indexPath)")
      }
      cell.configureForObject(object)
      return cell
   }
   
}

