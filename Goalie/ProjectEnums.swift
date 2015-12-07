//
//  ProjectEnums.swift
//  Goalie
//
//  Created by Gregory Klein on 12/7/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

public enum Month: Int
{
   case Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
}

extension Month
{
   var text: String {
      switch self
      {
      case .Jan: return "JAN"
      case .Feb: return "FEB"
      case .Mar: return "MAR"
      case .Apr: return "APR"
      case .May: return "MAY"
      case .Jun: return "JUN"
      case .Jul: return "JUL"
      case .Aug: return "AUG"
      case .Sep: return "SEP"
      case .Oct: return "OCT"
      case .Nov: return "NOV"
      case .Dec: return "DEC"
      }
   }
}