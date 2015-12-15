//
//  UINavigationBar+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/4/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension UINavigationBar
{
   public var leftBarButtonItem: UIBarButtonItem? {
      get {
         return self.items?.first?.leftBarButtonItem
      }
      set {
         let barButtonItemAttrs = Theme.titleTextAttributesForComponent(.NavBarButtonItem)
         newValue?.setTitleTextAttributes(barButtonItemAttrs, forState: .Normal)
         self.items?.first?.leftBarButtonItem = newValue
      }
   }
   
   public var rightBarButtonItem: UIBarButtonItem? {
      return self.items?.first?.rightBarButtonItem
   }
   
   func hideBottomHairline()
   {
      let navigationBarImageView = hairlineImageViewInNavigationBar(self)
      navigationBarImageView!.hidden = true
   }
   
   func showBottomHairline()
   {
      let navigationBarImageView = hairlineImageViewInNavigationBar(self)
      navigationBarImageView!.hidden = false
   }
   
   private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView?
   {
      if view.isKindOfClass(UIImageView) && view.bounds.height <= 1.0 {
         return (view as! UIImageView)
      }
      
      let subviews = (view.subviews)
      for subview: UIView in subviews {
         if let imageView: UIImageView = hairlineImageViewInNavigationBar(subview) {
            return imageView
         }
      }
      return nil
   }
   
   func makeTransparent()
   {
      self.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      self.backgroundColor = UIColor.clearColor()
      self.translucent = true
   }
}