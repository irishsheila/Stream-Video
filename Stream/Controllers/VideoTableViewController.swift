//
//  VideoTableViewController.swift
//  Stream
//
//  Created by Sheila Doherty on 8/22/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import UIKit
import AVKit

class VideoTableViewController: UITableViewController {
    
    var videoViewModels = [VideoViewModel]()
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        fetchData()
    }
    
    // MARK: - View Setup
    fileprivate func setupTableView() {
        tableView.register(VideoCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = .mainTextBlue
        tableView.backgroundColor = UIColor.rgb(r: 12, g: 47, b: 57)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 50, g: 199, b: 242)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    fileprivate func fetchData(){
        let videos = Service.shared.makeVideoArray()
        self.videoViewModels = videos.map({return VideoViewModel(video: $0)})
        self.tableView.reloadData()
    }
    
    //MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! VideoCell
        let videoViewModel = videoViewModels[indexPath.row]
        cell.videoViewModel = videoViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videoViewModels[indexPath.row]
        showVideoDetail(video: video)
    }
    
    //MARK: - Segue to video detail
    
    func showVideoDetail(video: VideoViewModel){
        let videoDetailController = VideoDetailController()
//        videoDetailController.video = video
//        navigationController?.pushViewController(videoDetailController, animated: true)
        guard let videoURL = URL(string: video.urlString) else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        videoDetailController.player = player
        present(videoDetailController, animated: true) {
            player.play()
        }
        
    }
    
}

class CustomNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    static let mainTextBlue = UIColor.rgb(r: 7, g: 71, b: 89)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
