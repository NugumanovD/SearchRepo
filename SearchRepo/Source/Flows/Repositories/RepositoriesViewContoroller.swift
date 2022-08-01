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
    tableView.tableFooterView = UIView(frame: .zero)
    
    return tableView
  }()
  
  private lazy var viewSpinner: UIView = {
    let view = UIView(frame: CGRect(
      x: 0,
      y: 0,
      width: view.frame.size.width,
      height: 100)
    )
    let spinner = UIActivityIndicatorView()
    spinner.center = view.center
    view.addSubview(spinner)
    spinner.startAnimating()
    
    return view
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    
    return refreshControl
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
    
    initializeBindings()
    tableView.register(cellClass: RepositoryCell.self)
    refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    setupLayoutSearchBar()
    setupLayoutTableView()
  }
  
  private func initializeBindings() {
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    viewModel.items
      .asObservable()
      .bind(
        to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)
      ) { index, element, cell in
        
        cell.bind(with: element)
      }.disposed(by: disposeBag)
    
    tableView.rx.didScroll
      .doOnNext { [weak self] _ in
        guard let self = self else { return }
        
        let offsetY = self.tableView.contentOffset.y
        let contentHeight = self.tableView.contentSize.height
        
        if offsetY > (contentHeight - self.tableView.frame.size.height) {
          self.viewModel.loadNextPageAction.onNext(())
        }
      }
      .disposed(by: disposeBag)
    
    viewModel.isLoadingSpinnerAvaliable
      .observe(on: MainScheduler.instance)
      .doOnNext { [weak self] isAvaliable in
        guard let self = self else { return }
        self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
      }
      .disposed(by: disposeBag)
    
    viewModel.onShowError
      .map { [weak self] in
        self?.tableView.scrollToBottomRow()
        self?.presentSingleButtonDialog(model: $0)
      }
      .takeLast(1)
      .subscribe()
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
  
  private func presentSingleButtonDialog(model: AlertControllerModel) {
    let alertController = UIAlertController(
      title: model.title,
      message: model.message,
      preferredStyle: .alert
    )
    
    let action = UIAlertAction(title: model.buttonTitle, style: .default) { [weak self] _ in
      self?.viewModel.alertButtonAction.onNext(())
    }
    
    alertController.addAction(action)
    navigationController?.present(alertController, animated: true)
  }
  
  @objc private func logoutAction() {
    viewModel.logOutAction.onNext(())
  }
  
  @objc private func refreshControlTriggered() {
    viewModel.loadNextPageAction.onNext(())
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
    searchBar.endEditing(true)
    viewModel.searchInput.accept(searchBar.searchTextField.text)
  }
  
}
