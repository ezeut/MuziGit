//
//  GithubLoginManager.swift
//  MuziGit
//
//  Created by 이지은 on 8/2/24.
//

import Foundation
import UIKit
import SwiftSoup
import SwiftDate

class GithubLoginManager {
    
    static let shared = GithubLoginManager()
    
    func requestCode() {
        let urlString = OAuthURL + "authorize?client_id=\(CLIENT_ID)&scope=\(SCOPE)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAccessToken(with code: String) {
        print("requestAccessToken 호출 완료")
        
        guard let url = URL(string: (OAuthURL + "access_token")) else { return }
        let parameters = ["client_id": CLIENT_ID, "client_secret": CLIENT_SECRET, "code": code]
        var request = URLRequest(url: url)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        request.httpMethod = "POST"
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
        
        guard let url = URL(string: (OAuthURL + "refresh_token")) else { return }
        let parameters = ["client_id": CLIENT_ID, "client_secret": CLIENT_SECRET, "code": code]
        var request = URLRequest(url: url)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.httpMethod = "POST"
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
        let urlString = APIURL + "user"
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
            do {
                let user = try JSONDecoder().decode(User.self, from: userData!)
                UserDefaults.standard.set(user.login, forKey: "userID")
            } catch {
                print(String(describing: error))
            }
        }
        task.resume()
    }
    
    func getContributions(of user: String) {
        let urlString = GithubURL + "users/\(user)/contributions"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let htmlString = String(data: data, encoding: .utf8)!
            
            do {
                let doc: Document = try SwiftSoup.parse(htmlString)
                let td: Elements = try! doc.select("td.ContributionCalendar-day")
                let toolTip: Elements = try! doc.select("tool-tip")
                let cnt: Int = toolTip.count
                
                for i in 0..<cnt {
                    let dataDate = try td[i].attr("data-date")
                    let dataLevel = try td[i].attr("data-level")
                    let countText = try toolTip[i].text()
                    
                    print(i,": ", dataDate, dataLevel, countText)
                }
//                for j in td {

//                }
            } catch {
                print(String(describing: error))
            }
        }
        task.resume()
    }
}
