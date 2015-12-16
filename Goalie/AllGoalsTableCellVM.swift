//
//  AllGoalsTableCellVM.swift
//  Goalie
//
//  Created by Gregory Klein on 12/16/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

enum AllGoalsCellComponent {
   case MainTitle, SubTitle, AuxLabel
}

struct AllGoalsTableCellVM
{
   private weak var _goal: Goal?
   init(goal: Goal?)
   {
      _goal = goal
   }
   
   func attributedTextForComponent(component: AllGoalsCellComponent) -> NSAttributedString
   {
      let title = _titleForComponent(component)
      let attributes = _attributesForComponent(component)
      return NSAttributedString(string: title, attributes: attributes)
   }
   
   private func _titleForComponent(component: AllGoalsCellComponent) -> String
   {
      var title = ""
      switch component
      {
      case .MainTitle:
         title = _goal?.title ?? ""
         break
      case .SubTitle:
         let completed = _goal?.completedSubgoals.count ?? 0
         let total = _goal?.subgoals.count ?? 0
         title = "\(completed)/\(total) sub-goals completed"
         break
      case .AuxLabel:
         title = _goal?.month.fullName ?? ""
      }
      return title
   }
   
   private func _attributesForComponent(component: AllGoalsCellComponent) -> [String : AnyObject]
   {
      var attributes: [String : AnyObject] = [:]
      switch component
      {
      case .MainTitle:
         attributes[NSFontAttributeName] = UIFont(name: "AvenirNext-Bold", size: 14)!
         attributes[NSForegroundColorAttributeName] = UIColor.lightBlueTextColor()
         attributes[NSStrikethroughStyleAttributeName] = _goal?.completed == true ? 1 : 0
         break
      case .SubTitle, .AuxLabel:
         attributes[NSFontAttributeName] = UIFont(name: "AvenirNext-Bold", size: 12)!
         attributes[NSForegroundColorAttributeName] = UIColor.lightPurpleTextColor()
         break
      }
      return attributes
   }
}
