//
//  StatsGraphView.swift
//  Final Project
//
//  Created by Jack Thompson on 12/10/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit

class StatsGraphView: UIView {
    
    var stats:[String: Float]!
    
    var energyBar:UIView!
    var moodBar:UIView!
    var danceBar:UIView!
    var acousticBar:UIView!
    var instrumentalBar:UIView!
    
    var isVertical:Bool!
    
    var padding:CGFloat = 20.0
    
    init(vertical: Bool, frame: CGRect) {
        super.init(frame: frame)
        self.isVertical = vertical
        
        energyBar = UIView()
        energyBar.backgroundColor = Constants.energyColor
        self.addSubview(energyBar)
        
        moodBar = UIView()
        moodBar.backgroundColor = Constants.moodColor
        self.addSubview(moodBar)
        
        danceBar = UIView()
        danceBar.backgroundColor = Constants.danceColor
        self.addSubview(danceBar)
        
        acousticBar = UIView()
        acousticBar.backgroundColor = Constants.acousticColor
        self.addSubview(acousticBar)
        
        instrumentalBar = UIView()
        instrumentalBar.backgroundColor = Constants.instrumentalColor
        self.addSubview(instrumentalBar)
        
        
        
    }
    
    func setBars(){
        if (isVertical == true) {
            energyBar.frame = CGRect(x: padding, y: frame.height - frame.height*(CGFloat)(stats["energy"]!), width: (frame.width - 2 * padding) / 5, height: frame.height*(CGFloat)(stats["energy"]!))
        
            moodBar.frame = CGRect(x: energyBar.frame.maxX, y: frame.height - (frame.height*(CGFloat)(stats["valence"]!)), width: (frame.width - 2 * padding) / 5, height: (frame.height*(CGFloat)(stats["valence"]!)))
        
            danceBar.frame = CGRect(x: moodBar.frame.maxX, y: frame.height - (frame.height*(CGFloat)(stats["danceability"]!)), width: (frame.width - 2 * padding) / 5, height: (frame.height*(CGFloat)(stats["danceability"]!)))
        
            acousticBar.frame = CGRect(x: danceBar.frame.maxX, y: frame.height - (frame.height*(CGFloat)(stats["acousticness"]!)), width: (frame.width - 2 * padding) / 5, height: (frame.height*(CGFloat)(stats["acousticness"]!)))
        
            instrumentalBar.frame = CGRect(x: acousticBar.frame.maxX, y: frame.height - (frame.height*(CGFloat)(stats["instrumentalness"]!)), width: (frame.width - 2 * padding) / 5, height: (frame.height*(CGFloat)(stats["instrumentalness"]!)))
        }
        else {
            
            let energyLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: frame.height / 5))
            energyLabel.text = "Energy:"
            energyLabel.textAlignment = .right
            energyLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            addSubview(energyLabel)
            
            let energyFullBar = UIView(frame: CGRect(x: energyLabel.frame.maxX + padding/2, y: padding, width: (frame.width - energyLabel.frame.maxX - padding), height: (frame.height - 4*padding) / 5))
            energyFullBar.center.y = energyLabel.center.y
            energyFullBar.backgroundColor = Constants.energyLight
            self.insertSubview(energyFullBar, belowSubview: energyBar)
            
            energyBar.frame = CGRect(x: energyLabel.frame.maxX + padding/2, y: padding, width: 0, height: (frame.height - 4*padding) / 5)
            energyBar.center.y = energyLabel.center.y
            energyBar.growHorizontal(size: (frame.width - energyLabel.frame.maxX - padding) * (CGFloat)(stats["energy"]!))
            
            let moodLabel:UILabel = UILabel(frame: CGRect(x: 0, y: energyLabel.frame.maxY, width: 110, height: frame.height / 5))
            moodLabel.text = "Mood:"
            moodLabel.textAlignment = .right
            moodLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            addSubview(moodLabel)
            
            let moodFullBar = UIView(frame: CGRect(x: moodLabel.frame.maxX + padding/2, y: padding, width: (frame.width - energyLabel.frame.maxX - padding), height: (frame.height - 4*padding) / 5))
            moodFullBar.center.y = moodLabel.center.y
            moodFullBar.backgroundColor = Constants.moodLight
            self.insertSubview(moodFullBar, belowSubview: moodBar)

            moodBar.frame = CGRect(x: moodLabel.frame.maxX + padding/2, y: energyBar.frame.maxY + padding , width: 0, height: (frame.height - 4*padding) / 5)
            moodBar.center.y = moodLabel.center.y
            moodBar.growHorizontal(size: (frame.width - energyLabel.frame.maxX - padding) * (CGFloat)(stats["valence"]!))
            
            let danceLabel:UILabel = UILabel(frame: CGRect(x: 0, y: moodLabel.frame.maxY, width: 110, height: frame.height / 5))
            danceLabel.text = "Danceability:"
            danceLabel.textAlignment = .right
            danceLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            addSubview(danceLabel)
            
            let danceFullBar = UIView(frame: CGRect(x: danceLabel.frame.maxX + padding/2, y: padding, width: (frame.width - danceLabel.frame.maxX - padding), height: (frame.height - 4*padding) / 5))
            danceFullBar.center.y = danceLabel.center.y
            danceFullBar.backgroundColor = Constants.danceLight
            self.insertSubview(danceFullBar, belowSubview: danceBar)
            
            danceBar.frame = CGRect(x: danceLabel.frame.maxX + padding/2, y: moodBar.frame.maxY , width: 0, height: (frame.height - 4*padding) / 5)
            danceBar.center.y = danceLabel.center.y
            danceBar.growHorizontal(size: (frame.width - danceLabel.frame.maxX - padding) * (CGFloat)(stats["danceability"]!))
            
            let acousticLabel:UILabel = UILabel(frame: CGRect(x: 0, y: danceLabel.frame.maxY, width: 110, height: frame.height / 5))
            acousticLabel.text = "Acousticness:"
            acousticLabel.textAlignment = .right
            acousticLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            addSubview(acousticLabel)
            
            let acousticFullBar = UIView(frame: CGRect(x: acousticLabel.frame.maxX + padding/2, y: padding, width: (frame.width - acousticLabel.frame.maxX - padding), height: (frame.height - 4*padding) / 5))
            acousticFullBar.center.y = acousticLabel.center.y
            acousticFullBar.backgroundColor = Constants.acousticLight
            self.insertSubview(acousticFullBar, belowSubview: acousticBar)
            
            acousticBar.frame = CGRect(x: acousticLabel.frame.maxX + padding/2, y: danceBar.frame.maxY , width: 0, height: (frame.height - 4*padding) / 5)
            acousticBar.center.y = acousticLabel.center.y
            acousticBar.growHorizontal(size: (frame.width - acousticLabel.frame.maxX - padding) * (CGFloat)(stats["acousticness"]!))
            
            let instrumentalLabel:UILabel = UILabel(frame: CGRect(x: 0, y: acousticLabel.frame.maxY, width: 110, height: frame.height / 5))
            instrumentalLabel.text = "Instrumental:"
            instrumentalLabel.textAlignment = .right
            instrumentalLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            addSubview(instrumentalLabel)
            
            let instrumentalFullBar = UIView(frame: CGRect(x: instrumentalLabel.frame.maxX + padding/2, y: padding, width: (frame.width - instrumentalLabel.frame.maxX - padding), height: (frame.height - 4*padding) / 5))
            instrumentalFullBar.center.y = instrumentalLabel.center.y
            instrumentalFullBar.backgroundColor = Constants.instrumentalLight
            self.insertSubview(instrumentalFullBar, belowSubview: instrumentalBar)
            
            instrumentalBar.frame = CGRect(x: danceLabel.frame.maxX + padding/2, y: acousticBar.frame.maxY , width: 0, height: (frame.height - 4*padding) / 5)
            instrumentalBar.center.y = instrumentalLabel.center.y
            instrumentalBar.growHorizontal(size: (frame.width - instrumentalLabel.frame.maxX - padding) * (CGFloat)(stats["instrumentalness"]!))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public extension UIView {
    
    func growHorizontal(withDuration duration: TimeInterval = 1.0, size: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.frame.size.width = size
            
        })
    }
    
    func growVertical(withDuration duration: TimeInterval = 1.0, size: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.frame.size.height = size
            self.frame.origin.y = self.frame.origin.y - size
        })
    }
}
