//
//  HistoryViewController.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

final class HistoryViewController: UIViewController {
  
  var viewModel: HistoryViewModel!
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    
    return tableView
  }()
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    self.view.backgroundColor = .white
    
    title = "History"
    setupView()
    initializeBindings()
  }
  
  private func initializeBindings() {
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    viewModel.items
      .observe(on: MainScheduler.instance)
      .asObservable()
      .bind(
        to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)
      ) { index, element, cell in
        print(index, element, cell)
        
        var presentableElement = element
        presentableElement.viewed = false
        
        cell.bind(with: presentableElement)
      }.disposed(by: disposeBag)
  }
  
  private func setupView() {
    tableView.register(cellClass: RepositoryCell.self)
    setupLayoutTableView()
  }
  
  private func setupLayoutTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
  }
}

extension HistoryViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
  
}


//
//extension HistoryViewController: UITableViewDataSource {
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 5
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeue(RepositoryCell.self, for: indexPath)
//    
//    cell.bind(with: .init(id: 0, viewed: true))
//    
//    return cell
//  }
//
//}
//
//extension HistoryViewController: NSFetchedResultsControllerDelegate {
//  
//  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    tableView.beginUpdates()
//  }
//  
//  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//    
//    switch type {
//    case .insert:
//      if let indexPath = newIndexPath {
//        tableView.insertRows(at: [indexPath], with: .fade)
//      }
//      
//    default: break
//      
//    }
//  }
//  
//  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    tableView.endUpdates()
//  }
//  
//}
