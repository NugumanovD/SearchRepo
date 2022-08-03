//
//  Int+RoundedWithAbbreviations.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 31.07.2022.
//

import Foundation

extension Int {
  
  var roundedWithAbbreviations: String {
    let number = Double(self)
    let thousand = number / 1000
    let million = number / 1000000
    if million >= 1.0 {
      return "\(round(million * 10) / 10)m"
    }
    else if thousand >= 1.0 {
      return "\(round(thousand * 10) / 10)k"
    }
    else {
      return "\(self)"
    }
  }
  
}
