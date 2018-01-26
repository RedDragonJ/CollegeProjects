//
//  TrackListTableViewController.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class TrackListTableViewController: UITableViewController {
    var currentArtist: Artist?
    var currentTrack: Track?
    var sortedTracksDictionary = [String : AnyObject]()
    var sortedAlbums = [String]()
    
    var trackDetailView: TrackDetailView?
    
    var imageOnOff: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anotherButton = UIBarButtonItem.init(image: UIImage.init(named: "settingsImage"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(displaySettings))
        self.navigationItem.rightBarButtonItem = anotherButton
        
        tableView.registerNib(UINib(nibName: TrackListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: TrackListTableViewCell.cellIdentifier())
        
        if let artist = currentArtist {
            self.title = "\(artist.name!) Tracks"
        } else {
            self.title = "Track"
        }
        
        getTrackData()
        setupTrackDetailView()
    }
}

extension TrackListTableViewController {
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedAlbums.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTracksDictionary[sortedAlbums[section]]!.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TrackListTableViewCell.sectionHeaderHeight()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedAlbums[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrackListTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TrackListTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! TrackListTableViewCell
        
        if self.imageOnOff == false
        {
            cell.imageWidthConstraint.constant = -cell.trackImageView.frame.width
            
        }
        else if self.imageOnOff == true
        {
            cell.imageWidthConstraint.constant = 3
        }
        
        let track = (sortedTracksDictionary[sortedAlbums[indexPath.section]] as! [Track])[indexPath.row] 
        cell.configureCellWithTrack(track)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentTrack = (sortedTracksDictionary[sortedAlbums[indexPath.section]] as! [Track])[indexPath.row]
        displayTrackDetailView()
    }
    
    // MARK: - Custom Methods
    func displaySettings() {
        let alertController = UIAlertController(title: "Settings", message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Show Images", style: UIAlertActionStyle.Default, handler: { (alertAction: UIAlertAction) in
            APIServiceManager.sharedManager.showImages = true
            self.imageOnOff = true
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Hide Images", style: UIAlertActionStyle.Default, handler: { (alertAction: UIAlertAction) in
            APIServiceManager.sharedManager.showImages = false
            self.imageOnOff = false
            self.tableView.reloadData()
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
}

private extension TrackListTableViewController {
    func displayTrackDetailView() {
        trackDetailView?.setupViewWithTrack(self.currentTrack!)
        self.navigationController?.view.addSubview(trackDetailView!)
        self.navigationController?.view.bringSubviewToFront(trackDetailView!)
    }
    
    func getTrackData() {
        if let artist = currentArtist {
            APIServiceManager.sharedManager.fetchTracksWithArtistID(artist.ID!, completion: { (tracks) in
                if artist.ID!.isEmpty
                {
                    let alert = UIAlertController(title: "ERROR", message: "Failed load tracks", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    let sortedTrackArray = tracks.sort({return $0.name!.compare($1.name!) == NSComparisonResult.OrderedAscending})
                    self.sortedTracksDictionary = Track.sortTracksWithArray(sortedTrackArray)["sortedTracks"] as! [String : [Track]]
                    self.sortedAlbums = Track.sortTracksWithArray(tracks)["sortedAlbums"] as! [String]
                    self.tableView.reloadData()
                }
            }, failure: { (error) in
                
            })
        }
    }
    
    func setupTrackDetailView() {
        trackDetailView = TrackDetailView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
    }
}
