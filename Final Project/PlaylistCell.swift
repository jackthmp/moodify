//
//  PlaylistCell.swift
//  Final Project
//
//  Created by Jack Thompson on 12/6/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit



class PlaylistCell: UICollectionViewCell {
    
    var playlist: Playlist!
    var user: User!
    
    var titleLabel: UILabel!
    var playlistImage: UIImageView!
    var statsGraph: StatsGraphView!
    
    let padding:CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        playlistImage = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        playlistImage.contentMode = .scaleAspectFill
        playlistImage.clipsToBounds = true
        playlistImage.image = #imageLiteral(resourceName: "Music-icon")
        playlistImage.alpha = 1.0
        self.addSubview(playlistImage)
        
        titleLabel = UILabel(frame: CGRect(x: padding, y: playlistImage.frame.maxY + padding, width: frame.width - 2*padding, height: frame.height - playlistImage.frame.height - 2 * padding))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.addSubview(titleLabel)
        
        statsGraph = StatsGraphView(vertical: true, frame: CGRect(x: padding/2, y: 0, width: frame.width - padding, height: playlistImage.frame.height))
        statsGraph.alpha = 0.0
        self.addSubview(statsGraph)
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.75
        self.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        self.playlistImage.image = #imageLiteral(resourceName: "Music-icon")
        self.statsGraph.alpha = 0.0
        self.statsGraph.stats = [:]
    }
    
    func setUp(){
        titleLabel.text = playlist.name
        self.user = NetworkManager.user
        
        if self.playlist.image == #imageLiteral(resourceName: "Music-icon") {
            NetworkManager.getImage(url: self.playlist.imageURL) { (image) in
                self.playlist.image = image
                self.displayCell(newLoad: true)
            }
        }
        if self.playlist.stats == [:] {
            self.getStats(completion: {
                self.statsGraph.setBars()
                self.displayCell(newLoad: true)
            })
        }
            
        else { displayCell(newLoad:false) }
        
    }
    
    func displayCell(newLoad: Bool) {
        self.statsGraph.stats = self.playlist.stats
        
        if (newLoad) {
            UIImageView.transition(with: self.playlistImage, duration: TimeInterval(0.5), options: .transitionCrossDissolve, animations: {
                self.playlistImage.image = self.playlist.image
            }, completion: { (finished) in
                self.statsGraph.fadeIn(alpha: 0.8)})
        }
        else {
            self.playlistImage.image = self.playlist.image
            self.statsGraph.alpha = 0.8
        }
    }
    
    func getStats(completion: @escaping () -> Void) {
        NetworkManager.getTracks(userID: self.playlist.user, playlistID: self.playlist.id) { (tracks) in
            self.playlist.tracks = tracks
            NetworkManager.analyzeTracks(tracks: self.playlist.tracks) { (stats) in
                self.playlist.stats = stats
                self.statsGraph.stats = stats
                completion()
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

