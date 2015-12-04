//
//  UIImage+Extensions.swift
//  Goalie
//
//  Created by Gregory Klein on 12/3/15.
//  Copyright © 2015 Incipia. All rights reserved.
//

import UIKit

extension UIImage
{
   class func imageWithColor(color: UIColor, size: CGSize) -> UIImage
   {
      let rect = CGRectMake(0, 0, size.width, size.height)
      UIGraphicsBeginImageContextWithOptions(size, false, 0)
      
      color.setFill()
      UIRectFill(rect)
      
      let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return image
   }
   
   // Meant for tiling
   class func imageWithColor(color: UIColor) -> UIImage
   {
      return imageWithColor(color, size: CGSize(width: 1, height: 1))
   }
}
