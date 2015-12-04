//
//  DataProvider.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

protocol DataProvider: class
{
   typealias Object
   func objectAtIndexPath(indexPath: NSIndexPath) -> Object
   func numberOfItemsInSection(section: Int) -> Int
}


protocol DataProviderDelegate: class
{
   typealias Object
   func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object>
{
   case Insert(NSIndexPath)
   case Update(NSIndexPath, Object)
   case Move(NSIndexPath, NSIndexPath)
   case Delete(NSIndexPath)
}

// PUT THIS IN IT'S OWN FILE
protocol DataSourceDelegate: class
{
   typealias Object
   func cellIdentifierForObject(object: Object) -> String
}

protocol ConfigurableCell
{
   typealias DataSource
   func configureForObject(object: DataSource)
}

protocol TableViewDelegate
{
   typealias Object
   func objectSelected(object: Object)
}
