//
//  MonthSelectorViewController.swift
//  Goalie
//
//  Created by Gregory Klein on 12/7/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

private let MonthsPerRow: CGFloat = 6
private let MonthsPerColumn: CGFloat = 2
private let TotalMonths = MonthsPerRow * MonthsPerColumn
private let DefaultPaddingValue: CGFloat = 3

class MonthSelectorViewController: UIViewController
{
   var paddingBetweenMonths: CGFloat = DefaultPaddingValue
   var selectedMonth: Month {
      get {
         return _currentlySelectedMonthView?.month ?? .Jan
      }
      set {
         for mv in _monthViews {
            if mv.month == newValue {
               _currentlySelectedMonthView?.selected = false
               _currentlySelectedMonthView = mv
               _currentlySelectedMonthView?.selected = true
            }
         }
      }
   }
   
   private var _monthViews: [MonthSelectorMonthView] = []
   private var _currentlySelectedMonthView: MonthSelectorMonthView?
   
   // MARK: - Lifecycle
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      view.multipleTouchEnabled = false
      view.backgroundColor = UIColor.clearColor()
      _setupMonthViews()
      
      _updateCurrentMonthView(_monthViews[0])
   }
   
   override func viewDidLayoutSubviews()
   {
      super.viewDidLayoutSubviews()
      _layoutMonthViews()
   }
   
   // MARK: - Setup
   private func _setupMonthViews()
   {
      for monthValue in 0 ..< Int(TotalMonths)
      {
         let month = Month(rawValue: monthValue)!
         let monthView = MonthSelectorMonthView(month: month)
         monthView.backgroundColor = ThemeNormalStateTextColor
         monthView.layer.borderColor = ThemeTabBarColor.CGColor
         monthView.layer.borderWidth = paddingBetweenMonths * 0.5
         
         _monthViews.append(monthView)
         view.addSubview(monthView)
      }
   }
   
   func _layoutMonthViews()
   {
      let width = ((view.frame.width - (0 * (MonthsPerRow - 1))) / MonthsPerRow)
      let height = ((view.frame.height - (0 * (MonthsPerColumn - 1))) / MonthsPerColumn)
      
      var index = 0
      for colIndex in 0 ..< Int(MonthsPerColumn)
      {
         for rowIndex in 0 ..< Int(MonthsPerRow)
         {
            let x: CGFloat = CGFloat(rowIndex) * (width + 0)
            let y: CGFloat = CGFloat(colIndex) * (height + 0)
            
            _monthViews[index++].frame = CGRectMake(x, y, width, height)
         }
      }
   }
   
   func _layoutMonthViewsOLD()
   {
      let width = ((view.frame.width - (paddingBetweenMonths * (MonthsPerRow - 1))) / MonthsPerRow)
      let height = ((view.frame.height - (paddingBetweenMonths * (MonthsPerColumn - 1))) / MonthsPerColumn)
      
      var index = 0
      for colIndex in 0 ..< Int(MonthsPerColumn)
      {
         for rowIndex in 0 ..< Int(MonthsPerRow)
         {
            let x: CGFloat = CGFloat(rowIndex) * (width + paddingBetweenMonths)
            let y: CGFloat = CGFloat(colIndex) * (height + paddingBetweenMonths)
            
            _monthViews[index++].frame = CGRectMake(x, y, width, height)
         }
      }
   }
   
   private func _monthViewAtLocation(location: CGPoint) -> MonthSelectorMonthView?
   {
      var monthView: MonthSelectorMonthView?
      for v in _monthViews {
         if v.frame.contains(location) {
            monthView = v
            break
         }
      }
      return monthView
   }
   
   // MARK: - Touch Events
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
   {
      if let location = touches.first?.locationInView(view),
         let monthView = _monthViewAtLocation(location) {
            _updateCurrentMonthView(monthView)
      }
   }

   override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
   {
      if let location = touches.first?.locationInView(view),
         let monthView = _monthViewAtLocation(location) {
            _updateCurrentMonthView(monthView)
      }
   }
   
   override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
   {
      if let location = touches.first?.locationInView(view),
         let monthView = _monthViewAtLocation(location) {
            _updateCurrentMonthView(monthView)
      }
   }
   
   override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
   {
      if let location = touches?.first?.locationInView(view),
         let monthView = _monthViewAtLocation(location) {
            _updateCurrentMonthView(monthView)
      }
   }
   
   private func _updateCurrentMonthView(monthView: MonthSelectorMonthView)
   {
      if let currentMonthView = _currentlySelectedMonthView
      {
         if currentMonthView != monthView
         {
            _currentlySelectedMonthView?.selected = false
            _currentlySelectedMonthView = monthView
            _currentlySelectedMonthView?.selected = true
         }
      }
      else
      {
         _currentlySelectedMonthView = monthView
         _currentlySelectedMonthView?.selected = true
      }
   }
}
