//
//  TokenReponse.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import Foundation

struct TokenResponse: Decodable {
  let accessToken: String
  let scope: String
  let tokenType: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case scope
    case tokenType = "token_type"
  }
}
