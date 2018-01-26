//
//  ArtistSearchTableViewController.swift
//  SDTestMusic
//
//  Created by Adrian C. Johnson on 9/15/16.
//  Copyright © 2016 SD. All rights reserved.
//

import Foundation
import UIKit

class ArtistSearchTableViewController: UITableViewController {
    let kArtistListToTrackListSegue = "artistListToTrackListSegue"
    
    var searchController: UISearchController?
    var searchResultsArray = [Artist]()
    
    var currentArtist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: ArtistListTableViewCell.cellName(), bundle: nil), forCellReuseIdentifier: ArtistListTableViewCell.cellIdentifier())
        
        self.title = "Artists"
        setupSearchBar()
    }
}

extension ArtistSearchTableViewController {
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let trackListTableViewController = segue.destinationViewController as? TrackListTableViewController {
            trackListTableViewController.currentArtist = currentArtist
        }
    }
    
    // MARK: - Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultsArray.count

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ArtistListTableViewCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ArtistListTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! ArtistListTableViewCell
        if !searchResultsArray.isEmpty {
            let artist = searchResultsArray[indexPath.row]
            cell.configureCellWithArtist(artist)
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentArtist = searchResultsArray[indexPath.row]
        self.performSegueWithIdentifier(kArtistListToTrackListSegue, sender: self)
    }
}

// MARK: - Search Bar Delegate
extension ArtistSearchTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResultsArray.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchResultsArray.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchQuery(searchBar.text!)
    }
}

// MARK: - Private Methods
private extension ArtistSearchTableViewController {
    func searchQuery(searchString: String) {
        
        if searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
        {
            let alert = UIAlertController(title: "ERROR", message: "Sorry Please Search for an Artist Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.searchResultsArray.removeAll()
            self.tableView.reloadData()
            APIServiceManager.sharedManager.fetchArtist(searchString, completion: { (artists) in
                self.searchResultsArray = artists
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func setupSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.searchBar.delegate = self
        self.tableView.tableHeaderView = self.searchController?.searchBar
        self.definesPresentationContext = true
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.searchBar.placeholder = "Search Artists"
    }
}
