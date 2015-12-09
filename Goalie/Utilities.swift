//
//  Utilities.swift
//  Moody
//
//  Created by Florian on 08/05/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import Foundation


extension SequenceType
{   
   func findFirstOccurence(@noescape block: Generator.Element -> Bool) -> Generator.Element? {
      for x in self where block(x) {
         return x
      }
      return nil
   }
   
   func some(@noescape block: Generator.Element -> Bool) -> Bool {
      return findFirstOccurence(block) != nil
   }
   
   func all(@noescape block: Generator.Element -> Bool) -> Bool {
      return findFirstOccurence { !block($0) } == nil
   }
   
   /// Similar to
   /// ```
   /// func forEach(@noescape body: (Self.Generator.Element) -> ())
   /// ```
   /// but calls the completion block once all blocks have called their completion block. If some of the calls to the block do not call their completion blocks that will result in data leaking.
   func asyncForEachWithCompletion(completion: () -> (), @noescape block: (Generator.Element, () -> ()) -> ()) {
      let group = dispatch_group_create()
      let innerCompletion = { dispatch_group_leave(group) }
      for x in self {
         dispatch_group_enter(group)
         block(x, innerCompletion)
      }
      dispatch_group_notify(group, dispatch_get_main_queue(), completion)
   }
   
   func filterByType<T>() -> [T] {
      return filter { $0 is T }.map { $0 as! T }
   }
}

extension SequenceType where Generator.Element: AnyObject
{
   public func containsObjectIdenticalTo(object: AnyObject) -> Bool {
      return contains { $0 === object }
   }
}

extension Array
{
   func decompose() -> (Generator.Element, [Generator.Element])? {
      guard let x = first else { return nil }
      return (x, Array(self[1..<count]))
   }
   
   func slices(size: Int) -> [[Generator.Element]] {
      var result: [[Generator.Element]] = []
      for idx in startIndex.stride(to: endIndex, by: size) {
         let end = min(idx + size, endIndex)
         result.append(Array(self[idx..<end]))
      }
      return result
   }
}

extension NSIndexPath
{
   public convenience init(goal: Goal)
   {
      var _row = 0
      if let parent = goal.parent {
         _row = parent.subgoals.indexOf(goal)!
      }
      self.init(forRow: _row, inSection: 0)
   }
}

extension String {
   
   subscript (i: Int) -> Character {
      return self[self.startIndex.advancedBy(i)]
   }
   
   subscript (i: Int) -> String {
      return String(self[i] as Character)
   }
   
   subscript (r: Range<Int>) -> String {
      return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
   }
}