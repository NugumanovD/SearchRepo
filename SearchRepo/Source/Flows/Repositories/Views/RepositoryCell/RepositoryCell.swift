//
//  RepositoryCell.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 31.07.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import AlamofireImage

final class RepositoryCell: UITableViewCell {
  
  private let avatarView = UIImageView()
  private let titleLabel = UILabel()
  private let starsContainerView = UIView()
  private let starsImageView = UIImageView()
  private let starsCountLabel = UILabel()
  private let languageLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupView()
  }
  
  override func prepareForReuse() {
    avatarView.image = nil
    titleLabel.text = nil
  }
  
  private func setupView() {
    guard contentView.subviews.isEmpty else { return }
    
    backgroundColor = .clear
    selectionStyle = .none
    
    addSubview(avatarView)
    
    avatarView.snp.makeConstraints {
      $0.top.leading.equalTo(16.0)
      $0.height.width.equalTo(40.0)
    }
    
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(16.0)
      $0.leading.equalTo(avatarView.snp.trailing).offset(16.0)
      $0.trailing.equalToSuperview().inset(16.0)
    }
    
    addSubview(starsContainerView)
    
    starsContainerView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5.0)
      $0.leading.equalTo(avatarView.snp.trailing).offset(16.0)
      $0.height.equalTo(20.0)
    }
    
    starsContainerView.addSubview(starsCountLabel)
    
    starsCountLabel.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
    }
    
    starsContainerView.addSubview(starsImageView)
    
    starsImageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalTo(starsCountLabel.snp.trailing).offset(2.0)
      $0.width.equalTo(20.0)
    }
    
    addSubview(languageLabel)

    languageLabel.snp.makeConstraints {
      $0.trailing.equalTo(titleLabel.snp.trailing)
      $0.height.equalTo(20.0)
      $0.bottom.equalTo(starsContainerView.snp.bottom)
    }
  }
  
  func bind(with configuration: RepositoryConfiguration) {
    avatarView.af.setImage(
      withURL: configuration.avatarURL,
      placeholderImage: UIImage(named: "gitHubLogo"),
      imageTransition: .crossDissolve(0.2)
    )
    starsImageView.image = UIImage(named: "starsIcon")
    titleLabel.text = configuration.title
    titleLabel.textColor = .red
    starsCountLabel.text = configuration.stargazersCount?.roundedWithAbbreviations
    languageLabel.text = configuration.language
  }
  
}
