//
//  VideoLauncher.swift
//  Stream
//
//  Created by Sheila Doherty on 8/26/19.
//  Copyright © 2019 Sheila Doherty. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerControls: UIView {
    
    var avPlayer: AVPlayer?
    
    var videoDetailController: VideoDetailController?
    
    var viewContainer: UIView?
    
    var videoDuration: CMTime?
    
    var isPlaying: Bool = false
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        return button
    }()
    
    lazy var tenSecondForwardButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "forward_ten")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handleForwardTen), for: .touchUpInside)
        return button
    }()
    
    lazy var tenSecondsBackwardButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "backward_ten")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handleBackwardTen), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "dismiss")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.isHidden = true
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    //MARK: - Controller button setup
    /**
     Sets up the controls for the AVPlayer.
     
     - Parameter container: The UIView to which the controls are being added.
     
     - Returns: Void
     */
    func setup(in container: UIView){
        
        // add observer to stop animating indicator
        avPlayer?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        // gesture recognizer for when the user taps the screen
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedScreen(_:)))
        container.addGestureRecognizer(gesture)
        
        // sets the label time & slider position to correlate witht the video time
        updateCurrentTime()
        
        // add activity indicator to view
        container.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        // add play/pause button to view
        container.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // add 10 second jump button to view
        container.addSubview(tenSecondForwardButton)
        tenSecondForwardButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        tenSecondForwardButton.leftAnchor.constraint(equalTo: pausePlayButton.rightAnchor).isActive = true
        tenSecondForwardButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        tenSecondForwardButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        tenSecondForwardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // add 10 second replay button to view
        container.addSubview(tenSecondsBackwardButton)
        tenSecondsBackwardButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        tenSecondsBackwardButton.rightAnchor.constraint(equalTo: pausePlayButton.leftAnchor).isActive = true
        tenSecondsBackwardButton.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        tenSecondsBackwardButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        tenSecondsBackwardButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // label for the length of the video
        container.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // label for the current time of the video
        container.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // scrubber slider
        container.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // dismiss view
        container.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewContainer = container
        
    }
    
    /**
     Shows or hides the control buttons when the user taps the screen.
     
     - Parameter gestureRecognizer: The tap gesture from the UITapGestureRecognizer.
     
     - Returns: Void
     */
    @objc func tappedScreen(_ gestureRecognizer : UITapGestureRecognizer){
        videoSlider.isHidden = !videoSlider.isHidden
        currentTimeLabel.isHidden = !currentTimeLabel.isHidden
        videoLengthLabel.isHidden = !videoLengthLabel.isHidden
        pausePlayButton.isHidden = !pausePlayButton.isHidden
        tenSecondForwardButton.isHidden = !tenSecondForwardButton.isHidden
        tenSecondsBackwardButton.isHidden = !tenSecondsBackwardButton.isHidden
        dismissButton.isHidden = !dismissButton.isHidden
        
        // fixes bug where play button doesn't play on the first tap
        if !pausePlayButton.isHidden && pausePlayButton.currentImage == (UIImage(named: "play")){
            isPlaying = false
        }
        
    }
    
    //MARK: -  Slider Handlers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()

            isPlaying = true
            
            if let duration = avPlayer?.currentItem?.duration {
                videoDuration = duration
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", ((Int(seconds) / 60) % 60) )
                let hoursText = Int(seconds) / 3600
                if hoursText == 0 {
                    videoLengthLabel.text = "\(minutesText):\(secondsText)"
                } else {
                    videoLengthLabel.text = "\(hoursText):\(minutesText):\(secondsText)"
                }
            }
        }
    }
    
    /**
     Updates the current time label & the slider position to go with the progress value of the video.

     - Returns: Void
     */
    private func updateCurrentTime(){
        // track player progress
        let interval = CMTime(value: 1, timescale: 2)
        avPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsText = String(format: "%02d", Int(seconds) % 60)
            let minutesText = String(format: "%02d", ((Int(seconds) / 60) % 60) )
            let hoursText = Int(seconds) / 3600
            if let duration = self.videoDuration {
                let durationSeconds = CMTimeGetSeconds(duration)
                let durationHours = Int(durationSeconds) / 3600
                if durationHours == 0 {
                    self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
                } else {
                    self.currentTimeLabel.text = "\(hoursText):\(minutesText):\(secondsText)"
                }
                
                self.videoSlider.value = Float(seconds / durationSeconds)
            }
            
        })
    }
    
    //MARK: - Button Handlers
    /**
     Toggles the Play & Pause button images when the user taps it
    
     - Returns: Void
     */
    @objc func handlePausePlay(){
        if isPlaying{
            avPlayer?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            avPlayer?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
            UIView.animate(withDuration: 0.5) {
                self.pausePlayButton.isHidden = true
                self.videoSlider.isHidden = true
                self.currentTimeLabel.isHidden = true
                self.videoLengthLabel.isHidden = true
                self.pausePlayButton.isHidden = true
                self.tenSecondForwardButton.isHidden = true
                self.tenSecondsBackwardButton.isHidden = true
                self.dismissButton.isHidden = true
            }
        }
        isPlaying = !isPlaying
        
    }
    
    /**
     Seeks the moment in the video that correlates to the place to which the user moved the slider thumb
     
     - Returns: Void
     */
    @objc func handleSliderChange(){
        if let duration = avPlayer?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            avPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //TODO
            })
        }
    }
    
    /**
     Seeks into the video 10 seconds forward
     
     - Returns: Void
     */
    @objc func handleForwardTen(){
        if let currentTime = avPlayer?.currentTime() {
            let currentPlusTen = CMTimeGetSeconds(currentTime).advanced(by: 10)
            let seekTime = CMTime(value: CMTimeValue(currentPlusTen), timescale: 1)
            avPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //TODO
            })
        }
    }
    
    /**
     Seeks into the video 10 seconds backward
     
     - Parameter None
     
     - Returns: Void
     */
    @objc func handleBackwardTen(){
        if let currentTime = avPlayer?.currentTime() {
            let currentPlusTen = CMTimeGetSeconds(currentTime).advanced(by: -10)
            let seekTime = CMTime(value: CMTimeValue(currentPlusTen), timescale: 1)
            avPlayer?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //TODO
            })
        }
    }
    
    /**
     Dismisses the AVPlayer & returns screen to the tableview list
     
     - Returns: Void
     */
    @objc func dismissView(){
        avPlayer?.pause()
        videoDetailController?.dismiss(animated: true, completion: nil)
    }
}
