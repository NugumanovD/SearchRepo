//
//  UITableView+Extension.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import UIKit

extension UITableView {
  
  func register(cellClass: UITableViewCell.Type) {
    register(cellClass.self, forCellReuseIdentifier: String(describing: cellClass.self))
  }
  
  func registerWithNib<CellClass: UITableViewCell>(cellClass: CellClass.Type) {
    let cellClassName = String(describing: cellClass.self)
    let nib = UINib(nibName: cellClassName, bundle: nil)
    register(nib, forCellReuseIdentifier: cellClassName)
  }
  
  func dequeue<CellClass: UITableViewCell>(_ cellClass: CellClass.Type, for indexPath: IndexPath) -> CellClass {
    let cellClassName = String(describing: cellClass.self)
    let cell = dequeueReusableCell(withIdentifier: cellClassName, for: indexPath)
    guard let typedCell = cell as? CellClass else {
      fatalError("Could not deque cell with type \(CellClass.self)")
    }
    return typedCell
  }
  
}
