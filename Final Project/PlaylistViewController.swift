//
//  PlaylistViewController.swift
//  Final Project
//
//  Created by Jack Thompson on 12/3/17.
//  Copyright © 2017 Jack Thompson. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var playlist:Playlist!
    var stats:[String: Float]!
    var isNew:Bool = false
    
    var tracksTableView: UITableView!
    var statsGraph: StatsGraphView!
    
    var saveButton:UIBarButtonItem!
    var deleteButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.932642487, green: 0.932642487, blue: 0.932642487, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        title = playlist.name
        
        let viewArea = view.frame.height - (self.tabBarController?.tabBar.frame.height)! -  UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.height)!
        
        tracksTableView = UITableView(frame: CGRect(x: 0, y: viewArea / 3, width: view.frame.width, height: 2 * viewArea / 3))
        tracksTableView.dataSource = self
        tracksTableView.delegate = self
        tracksTableView.register(TrackCell.self, forCellReuseIdentifier: "Track")
        tracksTableView.backgroundColor = .black
        view.addSubview(tracksTableView)
        
        statsGraph = StatsGraphView(vertical: false, frame: CGRect(x: 20, y: 20, width: view.frame.width - 40, height: viewArea / 3 - 40))
        statsGraph.alpha = 1.0
        view.addSubview(statsGraph)
        
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deletePlaylist))
        deleteButton.tintColor = .white
        
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePlaylist))
        saveButton.tintColor = .white
        
        if isNew {
            self.navigationItem.rightBarButtonItem = saveButton
        }
        else {
            self.navigationItem.rightBarButtonItem = deleteButton
        }
        
        setUpGraph()
    }
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
        
    }
    
    func setUpGraph(){
        NetworkManager.analyzeTracks(tracks: playlist.tracks) { (stats) in
            self.stats = stats
            self.statsGraph.stats = stats
            self.statsGraph.setBars()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpGraph()
        tracksTableView.reloadData()
    }
    
    @objc func savePlaylist() {
        NetworkManager.createPlaylist(name: playlist.name, completion: { (newPlaylist) in
            self.playlist.id = newPlaylist.id
            NetworkManager.addTracksToPlaylist(playlistid: newPlaylist.id, tracks: self.playlist.tracks, completion: { (track) in
                
                let doneMessage = UIAlertController(title: nil, message: "Playlist saved to Spotify", preferredStyle: UIAlertControllerStyle.alert)
                doneMessage.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(doneMessage, animated: true, completion: {
                    self.navigationItem.rightBarButtonItem = self.deleteButton
                })
            })
        })
    }
    
    @objc func deletePlaylist() {
        let deleteMessage = UIAlertController(title: nil, message: "Are you sure you want to delete your playlist, ''\(self.playlist.name!)''?", preferredStyle: UIAlertControllerStyle.alert)
        deleteMessage.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            NetworkManager.deletePlaylist(playlistid: self.playlist.id, completion: {
                print("deleted")
                let doneMessage = UIAlertController(title: nil, message: "Playlist deleted", preferredStyle: UIAlertControllerStyle.alert)
                doneMessage.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(doneMessage, animated: true, completion: nil)
                
            })
        }))
        deleteMessage.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(deleteMessage, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return playlist.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTableView.dequeueReusableCell(withIdentifier: "Track", for: indexPath) as? TrackCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setUpWithTrack(track: playlist.tracks[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TrackCell.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
