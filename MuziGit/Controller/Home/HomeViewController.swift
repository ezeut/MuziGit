//
//  HomeViewController.swift
//  MuziGit
//
//  Created by 이지은 on 8/3/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func touchUpContribution(_ sender: UIButton) {
        let user = UserDefaults.standard.string(forKey: "userID")!
        GithubLoginManager.shared.getContributions(of: user)
    }
    
    @IBAction func touchUpNotification(_ sender: UIBarButtonItem) {
        touchUpNotification()
    }
    
    @IBAction func touchUpMyInfo(_ sender: UIBarButtonItem) {
        touchUpMyInfo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addNavigationBar(firstButtonImageName: "bell", secondButtonImageName: "person")
    }
}
