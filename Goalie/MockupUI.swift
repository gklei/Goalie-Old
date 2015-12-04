//
//  MockupUI.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

func monthTitleForIndexPath(indexPath: NSIndexPath) -> String
{
   var title = ""
   switch indexPath.row
   {
   case 0:
      title = "JAN"
      break
   case 1:
      title = "FEB"
      break
   case 2:
      title = "MAR"
      break
   case 3:
      title = "APR"
      break
   case 4:
      title = "MAY"
      break
   case 5:
      title = "JUN"
      break
   case 6:
      title = "JUL"
      break
   case 7:
      title = "AUG"
      break
   case 8:
      title = "SEP"
      break
   case 9:
      title = "OCT"
      break
   case 10:
      title = "NOV"
      break
   case 11:
      title = "DEC"
      break
   default:
      break
   }
   return title
}

func goalCountForIndexPath(indexPath: NSIndexPath) -> Int
{
   var count = 1
   switch indexPath.row
   {
   case 0:
      count = 1
      break
   case 1:
      count = 3
      break
   case 2:
      count = 0
      break
   case 3:
      count = 2
      break
   case 4:
      count = 0
      break
   case 5:
      count = 3
      break
   case 6:
      count = 0
      break
   case 7:
      count = 1
      break
   case 8:
      count = 0
      break
   case 9:
      count = 1
      break
   case 10:
      count = 2
      break
   case 11:
      count = 4
      break
   default:
      break
   }
   return count
}
