//
//  GithubLoginManager.swift
//  MuziGit
//
//  Created by 이지은 on 8/2/24.
//

import Foundation
import UIKit
import Alamofire

class GithubLoginManager {
    
    static let shared = GithubLoginManager()
    
    private let CLIENT_ID = Bundle.main.CLIENT_ID
    private let CLIENT_SECRET = Bundle.main.CLIENT_SECRET
    let SCOPE = "repo, user"
    let GitURL = "https://github.com/login/oauth/"
    
    func requestCode() {
        let urlString = GitURL + "authorize?client_id=\(CLIENT_ID)&scope=\(SCOPE)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAccessToken(with code: String) {
        print("requestAccessToken 호출 완료")
        
        guard let url = URL(string: (GitURL + "access_token")) else { return }
        let parameters = ["client_id": CLIENT_ID, "client_secret": CLIENT_SECRET, "code": code]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(
            with: request as URLRequest, completionHandler: { data, response, error in
                guard let data = data else { return }
                print(data)
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print(String(data: data, encoding: .utf8) ?? "Not String!")
                    return
                }
                UserDefaults.standard.set(json["access_token"], forKey: "accessToken")
            })
        task.resume()
    }
    
    func requestRefreshToken(with code: String) {
        print("requestRefreshToken 호출 완료")

        guard let url = URL(string: (GitURL + "access_token")) else { return }
        let parameters = ["client_id": CLIENT_ID, "client_secret": CLIENT_SECRET, "code": code]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(
            with: request as URLRequest, completionHandler: { data, response, error in
                guard let data = data else { return }
//                print(data)
                guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print(String(data: data, encoding: .utf8) ?? "Not String!")
                    return
                }
                UserDefaults.standard.set(json["refresh_token"], forKey: "refreshToken")
            })
        task.resume()
    }
}
