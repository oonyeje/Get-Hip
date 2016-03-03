//
//  SongSelectionViewController.swift
//  GetHip
//
//  Created by Okechi on 1/24/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MediaPlayer

class SongSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    @IBOutlet weak var table: UITableView!

    
    @IBAction func selectFilter(sender: AnyObject) {
        let filterMenu = UIAlertController(title: nil, message:nil, preferredStyle: .ActionSheet)
        let cell: FilterCell = self.table.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! FilterCell
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        let songFilterAction = UIAlertAction(title: "Songs", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.filter = "Songs"
            self.table.reloadData()
            cell.filterBtn.titleLabel?.text = self.filter

        })
        
        let albumFilterAction = UIAlertAction(title: "Albums", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.filter = "Albums"
            self.table.reloadData()
            cell.filterBtn.titleLabel?.text = self.filter
        })
        
        let artistFilterAction = UIAlertAction(title: "Artists", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.filter = "Artists"
            self.table.reloadData()
            cell.filterBtn.titleLabel?.text = self.filter

        })
        
        switch self.filter {
        
        case "Artists":
            filterMenu.addAction(songFilterAction)
            filterMenu.addAction(albumFilterAction)
        case "Albums":
            filterMenu.addAction(songFilterAction)
            filterMenu.addAction(artistFilterAction)
            break
        default:
            filterMenu.addAction(artistFilterAction)
            filterMenu.addAction(albumFilterAction)
            break
        }
        filterMenu.addAction(cancelAction)
        self.presentViewController(filterMenu, animated: true, completion: nil)
    }
    
    var filter: String! = "Songs"
    
    @IBAction func cancelInvites(sender: UIBarButtonItem) {
        
        self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.title = "Select a Song"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(prty:PartyServiceManager, user: [UserParseData], friends: [FriendData], request: [FriendData]){
        self.party = prty
        self.usr = user
        self.frnds = friends
        self.requestData = request
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        switch self.filter{
            
        //return number of rows for albums
        case "Albums":
            var albumsQuery = MPMediaQuery.albumsQuery()
            var albums = albumsQuery.collections
            return albums.count + 1
        
        //return number of rows for artists
        case "Artists":
            var artistsQuery = MPMediaQuery.artistsQuery()
            //artistsQuery
            var artists = artistsQuery.items
            return artists.count + 1
            
        //return number of rows for song
        default:
            var songsQuery = MPMediaQuery.songsQuery()
            var songs = songsQuery.items
            return songs.count + 1
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if( indexPath.row == 0){
            
            
        }
        else{
            switch self.filter{
                
                //return albums cell
            case "Albums":
                let cell = self.table.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as? AlbumCell
                
                
                var albumsQuery = MPMediaQuery.albumsQuery()
                var albums = albumsQuery.items
                var rowItem: MPMediaItem = albums[indexPath.row - 1] as! MPMediaItem
                //segue to song selection from album selection
                
                
                //return artists cell
            case "Artists":
                let cell = self.table.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath) as? ArtistCell
                
                
                var artistsQuery = MPMediaQuery.artistsQuery()
                var artists = artistsQuery.items
                var rowItem: MPMediaItem = artists[indexPath.row - 1] as! MPMediaItem
                //segue to song selction from artist
                
                //return song cell
            default:
                let cell = self.table.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as? SongCell
                
                
                var songsQuery = MPMediaQuery.songsQuery()
                var songs = songsQuery.items
                var rowItem: MPMediaItem = songs[indexPath.row - 1] as! MPMediaItem
                self.party.setSong(rowItem)
                self.performSegueWithIdentifier("LoadingPartySegue", sender: nil)
                
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if( indexPath.row == 0){
            let cell = self.table.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as? FilterCell
            
            return cell!
            
        }
        else{
            switch self.filter{
                
                //return albums cell
            case "Albums":
                let cell = self.table.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as? AlbumCell
                
                
                var albumsQuery = MPMediaQuery.albumsQuery()
                var albums = albumsQuery.items
                var rowItem: MPMediaItem = albums[indexPath.row - 1] as! MPMediaItem
                
                cell?.textLabel?.text = rowItem.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!
                cell?.detailTextLabel?.text = rowItem.valueForProperty(MPMediaItemPropertyAlbumArtist) as? String!
                
                var artwork: MPMediaItemArtwork = rowItem.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                
                var artworkImage = artwork.imageWithSize(CGSize(width: 44,height: 44))
                
                if(artworkImage != nil){
                    cell?.imageView?.image = artworkImage
                }
                else{
                    cell?.imageView?.backgroundColor = UIColor.grayColor()
                    
                }
                
                return cell!
                
                //return artists cell
            case "Artists":
                let cell = self.table.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath) as? ArtistCell
                
                
                var artistsQuery = MPMediaQuery.artistsQuery()
                var artists = artistsQuery.items
                var rowItem: MPMediaItem = artists[indexPath.row - 1] as! MPMediaItem
                
                cell?.textLabel?.text = rowItem.valueForProperty(MPMediaItemPropertyArtist) as? String!
                
                var artwork: MPMediaItemArtwork = rowItem.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                
                var artworkImage = artwork.imageWithSize(CGSize(width: 44,height: 44))
                
                if(artworkImage != nil){
                    cell?.imageView?.image = artworkImage
                }
                else{
                    cell?.imageView?.backgroundColor = UIColor.grayColor()
                    
                }
                
                return cell!
                
                //return song cell
            default:
                let cell = self.table.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as? SongCell
                
                
                var songsQuery = MPMediaQuery.songsQuery()
                var songs = songsQuery.items
                var rowItem: MPMediaItem = songs[indexPath.row - 1] as! MPMediaItem
                
                cell?.textLabel?.text = rowItem.valueForProperty(MPMediaItemPropertyTitle) as? String!
                cell?.detailTextLabel?.text = rowItem.valueForProperty(MPMediaItemPropertyArtist) as? String!
                
                var artwork: MPMediaItemArtwork = rowItem.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                
                var artworkImage = artwork.imageWithSize(CGSize(width: 44,height: 44))
                
                if(artworkImage != nil){
                    cell?.imageView?.image = artworkImage
                }
                else{
                    cell?.imageView?.backgroundColor = UIColor.grayColor()
                    
                }
                
                return cell!
            }
        }
        
        
    }

    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "LoadingPartySegue"){
            let vc: LoadingPartyViewController = (segue.destinationViewController as? LoadingPartyViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
            
            for i_peer in self.party.invitedFriends{
                for peer in self.party.foundPeers {
                    if (peer.displayName == i_peer.displayName){
                        self.party.serviceBrowser.invitePeer(peer, toSession: self.party.session, withContext: nil, timeout: 1000.0)
                        
                        break
                    }
                }
                
                
            }
        }
    }
    

}
