//
//  UITableView+ScrollToBottom.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 01.08.2022.
//

import UIKit

extension UITableView {
  
  func scrollToBottomRow() {
    DispatchQueue.main.async {
      guard self.numberOfSections > 0 else { return }
      
      var section = max(self.numberOfSections - 1, 0)
      var row = max(self.numberOfRows(inSection: section) - 1, 0)
      var indexPath = IndexPath(row: row, section: section)

      while !self.indexPathIsValid(indexPath) {
        section = max(section - 1, 0)
        row = max(self.numberOfRows(inSection: section) - 1, 0)
        indexPath = IndexPath(row: row, section: section)
        
        if indexPath.section == 0 {
          indexPath = IndexPath(row: 0, section: 0)
          break
        }
      }
      
      guard self.indexPathIsValid(indexPath) else { return }
      
      self.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
  }
  
  private func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
    let section = indexPath.section
    let row = indexPath.row
    return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
  }
  
}

