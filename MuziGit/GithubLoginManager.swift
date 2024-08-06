//
//  GithubLoginManager.swift
//  MuziGit
//
//  Created by 이지은 on 8/2/24.
//

import Foundation
import UIKit

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
        
        guard let url = URL(string: (GitURL + "refresh_token")) else { return }
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
    
    func getUserData(with token: String) {
        let urlString = "https://api.github.com/user/public_emails"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let jsonString = String(data: data, encoding: .utf8)!
            let userData = jsonString.data(using: .utf8)
            print(jsonString)
            do {
                let user = try JSONDecoder().decode([User].self, from: userData!)
                UserDefaults.standard.set(user[1].email, forKey: "email")
//                for u in user {
//                    UserDefaults.standard.set(u.email, forKey: "email")
//                }
            } catch {
                print(String(describing: error))
            }
        }
        task.resume()
    }
}
