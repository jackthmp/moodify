//
//  TrackTableViewCell.swift
//  Final Project
//
//  Created by Jack Thompson on 12/6/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    var track:Track!
    
    var nameLabel: UILabel!
    var subtitleLabel: UILabel!
    
    static let height:CGFloat = 60
    let height:CGFloat = TrackCell.height
    let padding:CGFloat = 10
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "Track")
        frame.size.height = height
        
        self.backgroundColor = .black
        
        nameLabel = UILabel(frame: CGRect(x: 2*padding, y: padding, width: UIScreen.main.bounds.width - 2*padding, height: (height - 2*padding)/2))
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .white
        
        subtitleLabel = UILabel(frame: CGRect(x: 2*padding, y: nameLabel.frame.maxY + padding/2, width: UIScreen.main.bounds.width - 2*padding, height: (height - 2*padding)/2))
        subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        subtitleLabel.textColor = .white
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
    }
    
    func setUpWithTrack(track: Track){
        self.track = track
        nameLabel.text = track.name
        subtitleLabel.text = track.artist + " • " + track.album
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
