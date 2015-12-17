//
//  File.swift
//  Goalie
//
//  Created by Gregory Klein on 12/16/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import Foundation

enum MonthGoalsCellComponent {
   case MainTitle, SubTitle, AuxLabel
}

struct MonthGoalsTableCellVM
{
   private weak var _goal: Goal?
   init(goal: Goal?)
   {
      _goal = goal
   }
   
   func attributedTextForComponent(component: MonthGoalsCellComponent) -> NSAttributedString
   {
      let title = _titleForComponent(component)
      let attributes = _attributesForComponent(component)
      return NSAttributedString(string: title, attributes: attributes)
   }
   
   private func _titleForComponent(component: MonthGoalsCellComponent) -> String
   {
      var title = ""
      switch component
      {
      case .MainTitle:
         title = _goal?.title ?? ""
         break
      case .SubTitle:
         title = _goal?.summary ?? ""
         break
      case .AuxLabel:
         let completed = _goal?.completedSubgoals.count ?? 0
         let total = _goal?.subgoals.count ?? 0
         title = "\(completed)/\(total) sub-goals completed"
         title = (_goal!.title == "") ? "" : title
      }
      return title
   }
   
   private func _attributesForComponent(component: MonthGoalsCellComponent) -> [String : AnyObject]
   {
      var attributes: [String : AnyObject] = [:]
      switch component
      {
      case .MainTitle:
         attributes[NSFontAttributeName] = UIFont.boldGoalieFontWithSize(14)
         attributes[NSForegroundColorAttributeName] = UIColor(red: 115/255.0, green: 222/255.0, blue: 236/255.0, alpha: 1)
         attributes[NSStrikethroughStyleAttributeName] = _goal?.completed == true ? 1 : 0
         break
      case .SubTitle, .AuxLabel:
         attributes[NSFontAttributeName] = UIFont.boldGoalieFontWithSize(12)
         attributes[NSForegroundColorAttributeName] = UIColor(red: 124/255.0, green: 124/255.0, blue: 164/255.0, alpha: 1)
         break
      }
      return attributes
   }
}
