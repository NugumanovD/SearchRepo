//
//  RepositoriesViewContoroller.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import UIKit

final class RepositoriesViewContoroller: UIViewController {
  
  var viewModel: RepositoriesViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    title = "Repositories"
  }
}
