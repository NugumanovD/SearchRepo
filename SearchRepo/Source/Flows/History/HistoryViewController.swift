//
//  HistoryViewController.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import UIKit

final class HistoryViewController: UIViewController {
  
  var viewModel: HistoryViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    self.view.backgroundColor = .white
    
    title = "History"
  }
}
