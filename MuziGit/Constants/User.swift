//
//  User.swift
//  MuziGit
//
//  Created by 이지은 on 8/7/24.
//

import Foundation

struct User: Decodable {
    let email: String
    let primary: Bool
    let verified: Bool
    let visibility: Bool?
}
