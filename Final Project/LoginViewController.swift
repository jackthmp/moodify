//
//  LoginViewController.swift
//  Final Project
//
//  Created by Jack Thompson on 12/1/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit
import SpotifyLogin

class LoginViewController: UIViewController {
    
    var delegate: LoginProtocol?

    var loginButton: SpotifyLoginButton!
    var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Login"
        
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.insertSubview(blurEffectView, at: 0)
        
        loginButton = SpotifyLoginButton(viewController: self, scopes: [.streaming, .userLibraryRead, .userReadTop, .playlistReadPrivate, .playlistModifyPublic, .playlistModifyPrivate])
        loginButton.center = view.center
        loginButton.isOpaque = false
        view.addSubview(loginButton)
        
        messageLabel = UILabel(frame: CGRect(x: 0, y: loginButton.frame.minY - 100, width: view.frame.width - 50, height: 200))
        messageLabel.text = "A Spotify account is required to use this app. Tap the button below to sign in."
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        messageLabel.center.x = view.center.x
        view.addSubview(messageLabel)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: .SpotifyLoginSuccessful, object: nil)
    }
    
    @objc func loginSuccessful(){
        NetworkManager.getUser(completion: { (user) in
            self.delegate?.user = user
            self.delegate?.setUpUser(dataRange: "long_term")
            self.dismiss(animated: true, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
