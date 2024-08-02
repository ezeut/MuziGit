//
//  ViewController.swift
//  MuziGit
//
//  Created by 이지은 on 8/2/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func touchUpGithubLogin(_ sender: UIButton) {
        GithubLoginManager.shared.requestCode()
    }
    
    @IBAction func touchUpCheck(_ sender: UIButton) {
        let acToken = UserDefaults.standard.string(forKey: "accessToken") as Any
        print(acToken)
    }
}

