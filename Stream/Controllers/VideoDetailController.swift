//
//  VideoDetailController.swift
//  Stream
//
//  Created by Sheila Doherty on 8/23/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoDetailController: UIViewController {
    
    var video: VideoViewModel?
    var videoPlayerControls: VideoPlayerControls!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    func setupPlayer(){
        guard let videoURL = video?.url else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        playerViewController.showsPlaybackControls = false
        addChild(playerViewController)
        view.addSubview(playerViewController.view)
        playerViewController.didMove(toParent: self)
        
        playerViewController.player?.play()
        
        videoPlayerControls = VideoPlayerControls()
        videoPlayerControls.avPlayer = player
        videoPlayerControls.videoDetailController = self
        view.addSubview(videoPlayerControls)
        videoPlayerControls.setup(in: view)
        
    }
}
