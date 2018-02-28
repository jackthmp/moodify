//
//  CreatePlaylistViewController.swift
//  Final Project
//
//  Created by Jack Thompson on 12/12/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit

class CreatePlaylistViewController: UIViewController {
    
    var titleLabel: UILabel!
    
    var padding:CGFloat = 10
    
    var minEnergyLabel:UILabel!
    var energySlider:UISlider!
    var maxEnergyLabel:UILabel!
    
    var minMoodLabel:UILabel!
    var moodSlider:UISlider!
    var maxMoodLabel:UILabel!
    
    var minDanceLabel:UILabel!
    var danceSlider:UISlider!
    var maxDanceLabel:UILabel!
    
    //    var minInstrumentalLabel:UILabel!
    //    var instrumentalSlider:UISlider!
    //    var maxInstrumentalLabel:UILabel!
    
    var createButton:UIBarButtonItem!
    var activityWheel:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Playlist"
        view.backgroundColor = Constants.bgColor
        
        createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createPlaylist))
        createButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = createButton
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: padding*2, width: view.frame.width - 2 * padding, height: 30))
        titleLabel.text = "How are you feeling?"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.sizeToFit()
        titleLabel.center.x = view.center.x
        view.addSubview(titleLabel)
        
        minEnergyLabel = UILabel(frame: CGRect(x: padding, y: titleLabel.frame.maxY + 30, width: 80, height: 30))
        energySlider = UISlider(frame: CGRect(x: minEnergyLabel.frame.maxX + padding, y: titleLabel.frame.maxY + 30, width: view.frame.width - 4 * padding - 2 * minEnergyLabel.frame.width, height: 30))
        maxEnergyLabel = UILabel(frame: CGRect(x: energySlider.frame.maxX + padding, y: titleLabel.frame.maxY + 30, width: 80, height: 30))
        
        minEnergyLabel.text = "Sleepy"
        minEnergyLabel.textAlignment = .right
        view.addSubview(minEnergyLabel)
        
        maxEnergyLabel.text = "Energetic"
        maxEnergyLabel.textAlignment = .left
        view.addSubview(maxEnergyLabel)
        
        energySlider.maximumValue = 1.0
        energySlider.minimumValue = 0.0
        energySlider.value = 0.5
        view.addSubview(energySlider)
        
        minMoodLabel = UILabel(frame: CGRect(x: padding, y: energySlider.frame.maxY + 30, width: 80, height: 30))
        moodSlider = UISlider(frame: CGRect(x: minMoodLabel.frame.maxX + padding, y: energySlider.frame.maxY + 30, width: view.frame.width - 4 * padding - 2 * minMoodLabel.frame.width, height: 30))
        maxMoodLabel = UILabel(frame: CGRect(x: moodSlider.frame.maxX + padding, y: energySlider.frame.maxY + 30, width: 80, height: 30))
        
        minMoodLabel.text = "Sad"
        minMoodLabel.textAlignment = .right
        view.addSubview(minMoodLabel)
        
        maxMoodLabel.text = "Happy"
        maxMoodLabel.textAlignment = .left
        view.addSubview(maxMoodLabel)
        
        moodSlider.maximumValue = 1.0
        moodSlider.minimumValue = 0.0
        moodSlider.value = 0.5
        view.addSubview(moodSlider)
        
        minDanceLabel = UILabel(frame: CGRect(x: padding, y: moodSlider.frame.maxY + 30, width: 80, height: 30))
        danceSlider = UISlider(frame: CGRect(x: minDanceLabel.frame.maxX + padding, y: moodSlider.frame.maxY + 30, width: view.frame.width - 4 * padding - 2 * minDanceLabel.frame.width, height: 30))
        maxDanceLabel = UILabel(frame: CGRect(x: danceSlider.frame.maxX + padding, y: moodSlider.frame.maxY + 30, width: 80, height: 30))
        
        minDanceLabel.text = "Lazy"
        minDanceLabel.textAlignment = .right
        view.addSubview(minDanceLabel)
        
        maxDanceLabel.text = "Bouncy"
        maxDanceLabel.textAlignment = .left
        view.addSubview(maxDanceLabel)
        
        danceSlider.maximumValue = 1.0
        danceSlider.minimumValue = 0.0
        danceSlider.value = 0.5
        view.addSubview(danceSlider)
        
        //        minInstrumentalLabel = UILabel(frame: CGRect(x: padding, y: danceSlider.frame.maxY + 30, width: 80, height: 30))
        //        instrumentalSlider = UISlider(frame: CGRect(x: minInstrumentalLabel.frame.maxX + padding, y: danceSlider.frame.maxY + 30, width: view.frame.width - 4 * padding - 2 * minInstrumentalLabel.frame.width, height: 30))
        //        maxInstrumentalLabel = UILabel(frame: CGRect(x: instrumentalSlider.frame.maxX + padding, y: danceSlider.frame.maxY + 30, width: 80, height: 30))
        //
        //        minInstrumentalLabel.text = "Distracted"
        //        minInstrumentalLabel.textAlignment = .right
        //        view.addSubview(minInstrumentalLabel)
        //
        //        maxInstrumentalLabel.text = "Focused"
        //        maxInstrumentalLabel.textAlignment = .left
        //        view.addSubview(maxInstrumentalLabel)
        //
        //        instrumentalSlider.maximumValue = 1.0
        //        instrumentalSlider.minimumValue = 0.0
        //        instrumentalSlider.value = 0.5
        //        view.addSubview(instrumentalSlider)
        
        activityWheel = UIActivityIndicatorView(frame: CGRect(x: 0, y: danceSlider.frame.maxY + 50, width: 20, height: 20))
        activityWheel.activityIndicatorViewStyle = .gray
        activityWheel.hidesWhenStopped = true
        activityWheel.center.x = view.center.x
        view.addSubview(activityWheel)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        energySlider.value = 0.5
        moodSlider.value = 0.5
        danceSlider.value = 0.5
        
    }
    
    @objc func createPlaylist(){
        activityWheel.startAnimating()
        let playlist = Playlist()
        NetworkManager.getUser { (user) in
            NetworkManager.getRecommendations(energy: self.energySlider.value, valence: self.moodSlider.value, danceability: self.danceSlider.value, completion: { (tracks) in
                for track in tracks {
                    playlist.tracks.append(track)
                }
                let playlistViewController = PlaylistViewController(playlist: playlist)
                playlistViewController.isNew = true
                self.activityWheel.stopAnimating()
                self.navigationController?.pushViewController(playlistViewController, animated: true)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
