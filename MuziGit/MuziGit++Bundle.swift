//
//  MuziGit++Bundle.swift
//  MuziGit
//
//  Created by 이지은 on 8/2/24.
//

import Foundation

extension Bundle {
    
    var CLIENT_ID: String {
        guard let file = self.path(forResource: "GithubLoginInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["CLIENT_ID"] as? String else {
            fatalError("GithubLoginInfo.plist의 CLIENT_ID 에 유요한 값 설정을 해주세요")
        }
        return key
    }
    
    var CLIENT_SECRET: String {
        guard let file = self.path(forResource: "GithubLoginInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["CLIENT_SECRET"] as? String else {
            fatalError("GithubLoginInfo.plist의 CLIENT_SECRET 에 유요한 값 설정을 해주세요")
        }
        return key
    }
}
