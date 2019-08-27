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
    /**
     Setups up the attibutes of the tableview
     
     - Returns: Void
     */
    fileprivate func setupTableView() {
        tableView.register(VideoCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = .darkBlueColor
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    /**
     Sets up the attibutes of the navigation controller

     - Returns: Void
     */
    fileprivate func setupNavBar() {
        navigationItem.title = "Videos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .redColor
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    /**
     Fetches the data set that will be displayed in the tableview controller

     - Returns: Void
     */
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
    /**
     Presents the Video the user has selected to view
     
     - Parameter Video: The VideoViewModel object for the selected video
     
     - Returns: Void
     */
    func showVideoDetail(video: VideoViewModel){
        let videoDetailController = VideoDetailController()
        videoDetailController.video = video
        present(videoDetailController, animated: true)
    }
    
}

class CustomNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    static let darkBlueColor = UIColor.rgb(r: 7, g: 71, b: 89)
    static let redColor = UIColor.rgb(r: 225, g: 38, b: 0)
    static let highlightColor = UIColor.rgb(r: 225, g: 38, b: 0).withAlphaComponent(0.5)
    
    /**
     Shows or hides the control buttons when the user taps the screen.
     
     - Parameter r: The values for red
     - Parameter g: the value for green
     - Parameter b: the value for blue
     
     - Returns: The UIColor for the give rgb valuse
     */
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
