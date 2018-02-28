//
//  PlaylistsViewController.swift
//  
//
//  Created by Jack Thompson on 12/6/17.
//

import UIKit

class PlaylistsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    var playlists:[Playlist]! = []

    var playlistCollectionView: UICollectionView!
    var activityWheel: UIActivityIndicatorView!
    var refreshControl:UIRefreshControl!
    
    let padding:CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Playlists"
        view.backgroundColor = Constants.bgColor
        
        
        playlistCollectionView = UICollectionView(frame: CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height - (self.tabBarController?.tabBar.frame.height)! -  UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.height)!), collectionViewLayout: UICollectionViewFlowLayout())
        playlistCollectionView.dataSource = self
        playlistCollectionView.delegate = self
        playlistCollectionView.backgroundColor = view.backgroundColor
        playlistCollectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: "Playlist")
        view.addSubview(playlistCollectionView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getPlaylists), for: .valueChanged)
        
        playlistCollectionView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshControl.beginRefreshing()
        getPlaylists()
    }
    
    @objc func getPlaylists() {
        NetworkManager.getPlaylists { (playlists) in
            self.playlists = playlists
            self.playlistCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = playlistCollectionView.dequeueReusableCell(withReuseIdentifier: "Playlist", for: indexPath)  as? PlaylistCell else { return PlaylistCell() }
        cell.playlist = playlists[indexPath.row]
        cell.setUp()
        
        //cell.layoutIfNeeded()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlistViewController = PlaylistViewController(playlist: playlists[indexPath.row])
        self.navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = (collectionView.frame.width - 3*padding)/2
        return CGSize(width: cellSize, height: cellSize + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

public extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 0.5, alpha: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
            
        })
    }
}


