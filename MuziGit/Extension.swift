//
//  Extension.swift
//  MuziGit
//
//  Created by 이지은 on 8/9/24.
//

import UIKit

extension UIViewController {
    func addNavigationBar(firstButtonImageName: String, secondButtonImageName: String) {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 44))
        
        let logo = UIButton(type: .system)
        logo.setTitle("MUZIGIT 이미지", for: .normal)
        logo.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
        customView.addSubview(logo)
        
        let firstButton = UIButton(type: .system)
        firstButton.setImage(UIImage(systemName: firstButtonImageName), for: .normal)
        firstButton.tintColor = .black
        firstButton.frame = CGRect(x: customView.frame.width - 100, y: 0, width: 50, height: 44)
        firstButton.addTarget(self, action: #selector(touchUpNotification), for: .touchUpInside)
        customView.addSubview(firstButton)
        
        let secondButton = UIButton(type: .system)
        secondButton.setImage(UIImage(systemName: secondButtonImageName), for: .normal)
        secondButton.tintColor = .black
        secondButton.frame = CGRect(x: customView.frame.width - 50, y: 0, width: 50, height: 44)
        secondButton.addTarget(self, action: #selector(touchUpMyInfo), for: .touchUpInside)
        customView.addSubview(secondButton)

        self.navigationItem.titleView = customView
    }
    
    func addNavigationBar(searchBarText: String, firstButtonImageName: String, secondButtonImageName: String) {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 44))
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: customView.frame.width - 80, height: 44))
        searchBar.placeholder = searchBarText
        customView.addSubview(searchBar)
        
        let firstButton = UIButton(type: .system)
        firstButton.setImage(UIImage(systemName: firstButtonImageName), for: .normal)
        firstButton.tintColor = .black
        firstButton.frame = CGRect(x: customView.frame.width - 80, y: 0, width: 40, height: 44)
        firstButton.addTarget(self, action: #selector(touchUpNotification), for: .touchUpInside)
        customView.addSubview(firstButton)
        
        let secondButton = UIButton(type: .system)
        secondButton.setImage(UIImage(systemName: secondButtonImageName), for: .normal)
        secondButton.tintColor = .black
        secondButton.frame = CGRect(x: customView.frame.width - 40, y: 0, width: 40, height: 44)
        secondButton.addTarget(self, action: #selector(touchUpMyInfo), for: .touchUpInside)
        customView.addSubview(secondButton)

        self.navigationItem.titleView = customView
      }
    
    @objc func touchUpNotification() {
        guard let notificationVC = self.storyboard?.instantiateViewController(identifier: "NotificationVC") else { return }
            self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func touchUpMyInfo() {
        guard let myInfoVC = self.storyboard?.instantiateViewController(identifier: "MyInfoVC") else { return }
            self.navigationController?.pushViewController(myInfoVC, animated: true)
    }
}
