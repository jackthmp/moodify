//
//  ProfileViewController.swift
//  Final Project
//
//  Created by Jack Thompson on 12/1/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit
import SpotifyLogin
import Alamofire

protocol LoginProtocol {
    var user: User? { get set }
    func setUpUser(dataRange: String)
}

class ProfileViewController: UIViewController, LoginProtocol {
    
    var user: User?
    var topTracks: [Track]?
    var stats: [String: Float] = [:]
    
    var nameLabel:UILabel!
    var profileImage:UIImageView!
    var statsTitleLabel: UILabel!
    var statsGraph:StatsGraphView!
    var statsBreakdown: UITextView!
    
    var signOutButton:UIBarButtonItem!
    var rangeButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewArea = view.frame.height - (self.tabBarController?.tabBar.frame.height)! -  UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.height)!
        
        title = "Profile"
        view.backgroundColor = Constants.bgColor
        
        signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        signOutButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = signOutButton
        
        rangeButton = UIBarButtonItem(title: "Data Range", style: .plain, target: self, action: #selector(selectDataRange))
        rangeButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = rangeButton
        
        profileImage = UIImageView(frame: CGRect(x: 0, y:20, width: 80, height: 80))
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.center.x = view.center.x
        profileImage.alpha = 0.0
        view.addSubview(profileImage)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: profileImage.frame.maxY + 10, width: view.frame.width - 20, height: 30))
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.center.x = view.center.x
        nameLabel.alpha = 0.0
        view.addSubview(nameLabel)
        
        statsTitleLabel = UILabel(frame: CGRect(x: 20, y: nameLabel.frame.maxY + 10, width: 0, height: 0))
        statsTitleLabel.text = "Your statistics over the past year:"
        statsTitleLabel.sizeToFit()
        statsTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        statsTitleLabel.alpha = 0.0
        view.addSubview(statsTitleLabel)
        
        statsBreakdown = UITextView(frame: CGRect(x: 20, y: viewArea - 110, width: view.frame.width - 40, height: 120))
        statsBreakdown.textAlignment = .center
        statsBreakdown.font = UIFont.systemFont(ofSize: 16, weight: .light)
        statsBreakdown.backgroundColor = Constants.bgColor
        statsBreakdown.isEditable = false
        statsBreakdown.isSelectable = false
        statsBreakdown.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        statsBreakdown.alpha = 0.0
        view.addSubview(statsBreakdown)
        
        statsGraph = StatsGraphView(vertical: false, frame: CGRect(x: 20, y: statsTitleLabel.frame.maxY + 10, width: view.frame.width - 40, height: viewArea - statsTitleLabel.frame.maxY - statsBreakdown.frame.height - 20))
        statsGraph.alpha = 1.0
        view.addSubview(statsGraph)
        
        perform(#selector(checkLogin), with: nil, afterDelay: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUser(dataRange: String){
        self.tabBarController?.tabBar.items![1].isEnabled = true
        self.tabBarController?.tabBar.items![2].isEnabled = true
        
        nameLabel.text = user?.displayName
        
        NetworkManager.getImage(url: (user?.imageURL)!) { (image) in
            self.profileImage.image = image
            self.profileImage.fadeIn(alpha: 1.0)
            self.nameLabel.fadeIn(alpha: 1.0)
        }
        
        NetworkManager.getTopTracks(userid: (user?.id)!, timeRange: dataRange, limit: 50) { (topTracks) in
            self.topTracks = topTracks
            NetworkManager.analyzeTracks(tracks: topTracks) { (stats) in
                self.stats = stats
                if dataRange == "short_term" { self.statsTitleLabel.text = "Your statistics over the past two weeks:" }
                else if dataRange == "medium_term" { self.statsTitleLabel.text = "Your statistics over the six months:" }
                else { self.statsTitleLabel.text = "Your statistics over the past year:" }
                self.statsTitleLabel.sizeToFit()
                self.statsGraph.stats = stats
                self.statsGraph.setBars()
                
                let detail = "Based on your top 50 songs on Spotify, you are a " + (stats["energy"]! <= Float(0.5) ? "chill" : "energetic")
                    + " person who often listens to music " + (stats["valence"]! <= Float(0.5) ? "when feeling down." : "to brighten your mood.")
                    + " You typically " + (stats["danceability"]! <= Float(0.5) ? "vibe" : "groove") + " to your music, which is usually "
                    + (stats["acousticness"]! <= Float(0.5) ? "electronic" : "acoustic") + " and "
                    + (stats["instrumentalness"]! <= Float(0.5) ? "vocalic." : "instrumental.")
                
                self.statsBreakdown.text = detail
                self.statsTitleLabel.fadeIn(alpha: 1.0)
                self.statsBreakdown.fadeIn(alpha: 1.0)
            }
        }
    }
    
    @objc func signOut(){
        SpotifyLogin.shared.logout()
        user = nil
        checkLogin()
    }
    
    @objc func selectDataRange(){
        let timePicker = UIAlertController(title: "Choose a Data Range", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        timePicker.addAction(UIAlertAction(title: "Short Term", style: .default, handler: { (action) in
            self.setUpUser(dataRange: "short_term")
        }))
        timePicker.addAction(UIAlertAction(title: "Medium Term", style: .default, handler: { (action) in
            self.setUpUser(dataRange: "medium_term")
        }))
        timePicker.addAction(UIAlertAction(title: "Long Term", style: .default, handler: { (action) in
            self.setUpUser(dataRange: "long_term")
        }))
        timePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(timePicker, animated: true, completion: nil)
    }
    
    @objc func checkLogin(){
        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
            if error != nil {
                print("User is not logged in.")
                self.tabBarController?.tabBar.items![1].isEnabled = false
                self.tabBarController?.tabBar.items![2].isEnabled = false
                let loginViewController = LoginViewController()
                
                loginViewController.modalPresentationStyle = .overCurrentContext
                loginViewController.modalTransitionStyle = .crossDissolve
                loginViewController.delegate = self
                
                self.present(loginViewController, animated: true, completion: {
                    NetworkManager.getUser(completion: { (user) in
                        self.user = user
                        self.setUpUser(dataRange: "long_term")
                    })
                })
            }
            else {
                NetworkManager.getUser(completion: { (user) in
                    self.user = user
                    self.setUpUser(dataRange: "long_term")
                })
            }
        }
    }
    
    
}

