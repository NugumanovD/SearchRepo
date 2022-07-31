//
//  RepositoriesViewContoroller.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 29.07.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

final class RepositoriesViewContoroller: UIViewController {
  
  var viewModel: RepositoriesViewModel!
  
  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchTextField.addDoneButtonOnKeyboard()
    searchBar.delegate = self
    
    return searchBar
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    
    return tableView
  }()
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    title = "Repositories"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Log out",
      style: .plain,
      target: self,
      action: #selector(logoutAction)
    )
    
    tableView.register(cellClass: RepositoryCell.self)
    
    setupLayoutSearchBar()
    setupLayoutTableView()
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.items
      .asObservable()
      .bind(
        to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)
      ) { index, element, cell in
        
        cell.bind(with: element)
      }.disposed(by: disposeBag)
   
    searchBar.searchTextField.rx.text
      .orEmpty
      .debounce(.milliseconds(30), scheduler: MainScheduler.instance)
      .bind(to: viewModel.searchInput)
      .disposed(by: disposeBag)
    
    tableView.rx.didScroll.doOnNext { [weak self] _ in
      guard let self = self else { return }
      
      let offsetY = self.tableView.contentOffset.y
      let contentHeight = self.tableView.contentSize.height
      
      if offsetY > (contentHeight - self.tableView.frame.size.height - 100) {
        if self.viewModel.state.value != .loading {
          self.viewModel.loadNextPageAction.onNext(())
        }
      }
    }
    .disposed(by: disposeBag)
    
  }
  
  private func setupLayoutSearchBar() {
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupLayoutTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  @objc func logoutAction() {
    viewModel.logOutAction.onNext(())
  }
  
}

extension RepositoriesViewContoroller: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let configuration = viewModel.items.value[indexPath.row]
    viewModel.selectedCellAction.onNext(configuration.pageURL)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }
  
}

extension RepositoriesViewContoroller: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
    self.tableView.reloadData()
    searchBar.endEditing(true)
  }

}
