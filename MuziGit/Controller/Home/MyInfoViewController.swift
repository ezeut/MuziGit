//
//  MyInfoViewController.swift
//  MuziGit
//
//  Created by 이지은 on 8/7/24.
//

import UIKit

class MyInfoViewController: UIViewController {
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBAction func getUserData(_ sender: UIButton) {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let user = UserDefaults.standard.string(forKey: "userID") ?? "유저정보없음"
        GithubLoginManager.shared.getUserData(with: accessToken)
        userIDLabel.text = "\(user)님, 안녕하세요"
    }
    
    @IBAction func touchUpLogout(_ sender: UIButton) {
        
        print("로그아웃")
        
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: {_ in print("로그아웃 취소")}))
        alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: {_ in UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Main") as! OnboardingViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
