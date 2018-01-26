//
//  TrackDetailView.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/16/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class TrackDetailView: UIView {
    @IBOutlet var shadowView: UIView!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var trackNumberLabel: UILabel!
    @IBOutlet var trackDurationLabel: UILabel!
    @IBOutlet var trackPopularityLabel: UILabel!
    @IBOutlet var audioToolbar: UIToolbar!
    @IBOutlet var progressBar: UIProgressView!
    
    var audioPlayer: AVAudioPlayer?
    var currentTrack: Track!
    var timer: NSTimer!
    
    var firstTimeZero: Bool = false
    
    let parentViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xibView: UIView = NSBundle.mainBundle().loadNibNamed("TrackDetailView", owner: self, options: nil)![0] as! UIView
        xibView.frame = frame
        self.addSubview(xibView)
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TrackDetailView.dismissView))
        self.shadowView.addGestureRecognizer(gestureRecognizer)
        
        self.progressBar.progress = 0.0
        
        audioToolbar.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackDetailView: AVAudioPlayerDelegate {
    // Custom Methods
    func dismissView() {
        self.trackImageView.image = nil
        self.audioPlayer?.stop()
        self.removeFromSuperview()
    }
    
    func downloadTrack(track: Track, completion: () -> Void, failure failureBlock: (error: NSError) -> Void) {
        dispatch_async(dispatch_queue_create("getTrack", nil)) {
            if let url = track.previewUrl {
                if let data = NSData(contentsOfURL: url) {
                    do {
                        self.audioPlayer = try AVAudioPlayer(data: data)
                        dispatch_async(dispatch_get_main_queue(), {
                            completion()
                        })
                    }
                    catch let error as NSError {
                        failureBlock(error: error)
                    }
                }
            }
        }
    }
    
    func setupViewWithTrack(track: Track) {
        downloadTrack(track, completion: {
            if track.name!.isEmpty
            {
                let alert = UIAlertController(title: "ERROR", message: "Failed download track", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.parentViewController.presentViewController(alert, animated: true, completion: nil)
            }
            else
            {
                self.audioToolbar.hidden = false
                self.audioPlayer?.delegate = self
                self.audioPlayer?.numberOfLoops = 0
                self.audioPlayer?.volume = 0.5
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        track.thumbnailImage { (image) in
            self.trackImageView.image = image
        }
        
        artistNameLabel.text = track.artistName!.uppercaseString
        trackNameLabel.text = "Track Name: \(track.name!)"
        trackNumberLabel.text = "Track #: \(track.trackNumber!)"
        trackDurationLabel.text = "Duration: \(track.formattedDuration())"
        trackPopularityLabel.text = "Popularity: \(track.popularity!)"
    }
    
    func updateProgressBar() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let currentProgress = self.audioPlayer!.currentTime / self.audioPlayer!.duration
            
            self.progressBar.progress = Float(currentProgress)
            
            if currentProgress == 0.0
            {
                if self.firstTimeZero == false
                {
                    self.firstTimeZero = true
                }
                else
                {
                    self.audioPlayer?.stop()
                    self.timer.invalidate()
                }
            }
        }
    }
    
    // Actions
    @IBAction func playTrackButtonClicked(sender: UIBarButtonItem) {
        self.audioPlayer?.play()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(TrackDetailView.updateProgressBar), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    @IBAction func pauseTrackButtonClicked(sender: UIBarButtonItem) {
        self.audioPlayer?.pause()
        self.timer.invalidate()
    }
    
}

