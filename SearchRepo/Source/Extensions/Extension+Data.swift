//
//  Extension+Data.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation

extension Data {
    
  var toString: String? {
    return String(data: self, encoding: .utf8)
  }
  
}
