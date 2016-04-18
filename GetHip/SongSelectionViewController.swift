//
//  SongSelectionViewController.swift
//  GetHip
//
//  Created by Okechi on 1/24/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import UIKit
import MediaPlayer
import MultipeerConnectivity

class SongSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var party: PartyServiceManager!
    var usr: [UserParseData] = []
    var frnds: [FriendData] = []
    var requestData: [FriendData] = []
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segCtrl: UISegmentedControl!

    @IBAction func switchViews(segCtrl: UISegmentedControl){
        switch self.segCtrl.selectedSegmentIndex {
        
        case 0:
            self.filter = "Songs"
            break
        case 1:
            self.filter = "Albums"
            break
        default:
            self.filter = "Artists"
            break
        
        }
        
        switch self.filter {
        case "Albums":
            
            self.table.reloadData()
            break
        case "Artists":
            
            self.table.reloadData()
            break
        default:
            
            self.table.reloadData()
            break
            
        }
        
        if(segCtrl.selectedSegmentIndex == 0){
        
        
        }
        
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
            albumsQuery.groupingType = MPMediaGrouping.Album
            var albums = albumsQuery.collections
            return albums.count
        
        //return number of rows for artists
        case "Artists":
            var artistsQuery = MPMediaQuery.artistsQuery()
            artistsQuery.groupingType = MPMediaGrouping.Artist
            var artists = artistsQuery.collections
            return artists.count
            
        //return number of rows for song
        default:
            var songsQuery = MPMediaQuery.songsQuery()
            var songs = songsQuery.items
            return songs.count
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
            switch self.filter{
                
                //return albums cell
            case "Albums":
                let cell = self.table.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as? AlbumCell
                
                
                var albumsQuery = MPMediaQuery.albumsQuery()
                var albums = albumsQuery.items
                var rowItem: MPMediaItem = albums[indexPath.row ] as! MPMediaItem
                //segue to song selection from album selection
                
                
                //return artists cell
            case "Artists":
                let cell = self.table.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath) as? ArtistCell
                
                
                var artistsQuery = MPMediaQuery.artistsQuery()
                var artists = artistsQuery.items
                var rowItem: MPMediaItem = artists[indexPath.row ] as! MPMediaItem
                //segue to song selction from artist
                
                //return song cell
            default:
                let cell = self.table.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath) as? SongCell
                
                
                var songsQuery = MPMediaQuery.songsQuery()
                var songs = songsQuery.items
                var rowItem: MPMediaItem = songs[indexPath.row ] as! MPMediaItem
                self.party.setSong(rowItem)
                if(self.party.role == PeerType.Host_Creator){
                    self.performSegueWithIdentifier("LoadingPartySegue", sender: self)
                }else{
                    self.performSegueWithIdentifier("NextSongCurrentlyPlayingSegue", sender: self)
                }
                
                
            }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
            switch self.filter{
                
                //return albums cell
            case "Albums":
                let cell = self.table.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as? AlbumCell
                
                
                var albumsQuery = MPMediaQuery.albumsQuery()
                albumsQuery.groupingType = MPMediaGrouping.Album
                var albums = albumsQuery.collections
                var rowItem: MPMediaItemCollection = albums[indexPath.row] as! MPMediaItemCollection
                var representative = rowItem.representativeItem
                
                cell?.textLabel?.text = representative.albumTitle //rowItem.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!
                cell?.detailTextLabel?.text = representative.albumArtist //rowItem.valueForProperty(MPMediaItemPropertyArtist) as? String!
                
                if (representative.albumArtist == nil) {
                    cell?.detailTextLabel?.text = "Unknown Artist"
                }
                
                if (representative.albumTitle == nil) {
                    cell?.textLabel?.text = "Unknown Album"
                }
                
                var artwork: MPMediaItemArtwork = representative.artwork //rowItem.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                
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
                artistsQuery.groupingType = MPMediaGrouping.Artist
                var artists = artistsQuery.collections
                println(artists.count)
                println(indexPath.row)
                var rowItem: MPMediaItemCollection = artists[indexPath.row] as! MPMediaItemCollection
                var representative = rowItem.representativeItem
                cell?.textLabel?.text = representative.artist //rowItem.valueForProperty(MPMediaItemPropertyArtist) as? String!
                
                if (representative.artist == nil) {
                    cell?.detailTextLabel?.text = "Unknown Artist"
                }
                
                var artwork: MPMediaItemArtwork = representative.artwork//rowItem.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                
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
                var rowItem: MPMediaItem = songs[indexPath.row] as! MPMediaItem
                
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

    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "LoadingPartySegue"){
            let vc: LoadingPartyViewController = (segue.destinationViewController as? LoadingPartyViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
            
            for i_peer in self.party.invitedFriends{
                for peer in self.party.foundPeers {
                    if (peer.displayName == i_peer.displayName && self.party.myPeerID.hash > peer.hash){
                        self.party.serviceBrowser.invitePeer(peer, toSession: self.party.session, withContext: nil, timeout: 30.0)
                        
                        break
                    }
                }
                
                
            }
        }
        
        if(segue.identifier == "NextSongCurrentlyPlayingSegue"){
        
            let vc: CurrentlyPlayingViewController = (segue.destinationViewController as? CurrentlyPlayingViewController)!
            vc.setData(self.party, user: self.usr, friends: self.frnds, request: self.requestData)
            
            //sends music info incuding, title, artist, album, and image
            var dictionary: [String: AnyObject] = ["sender": self.party.myPeerID.displayName, "instruction": "set_up_song", "songTitle": (self.party.currentSong.valueForProperty(MPMediaItemPropertyTitle) as? String!)!, "songArtistAndAlbum": (self.party.currentSong.valueForProperty(MPMediaItemPropertyArtist) as? String!)! + " - " + (self.party.currentSong.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String!)!, "songImage": UIImagePNGRepresentation(self.party.currentSong.valueForProperty(MPMediaItemPropertyArtwork).imageWithSize(CGSize(width: 320, height: 320)) )]
            
            
            for peer in self.party.connectedPeers() as! [MCPeerID] {
                self.party.sendInstruction(dictionary, toPeer: peer)
                
                //open stream with peer
                let stream = self.party.outputStreamForPeer(peer)
                self.party.outputStreamers[peer.displayName] = TDAudioOutputStreamer(outputStream: stream)
                self.party.outputStreamers[peer.displayName]!.streamAudioFromURL((self.party.currentSong.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL))
            }
            
            dictionary = ["sender": self.party.myPeerID.displayName, "instruction": "start"]
            
            for peer in self.party.connectedPeers() as! [MCPeerID] {
                self.party.sendInstruction(dictionary, toPeer: peer)
            }
            
            
            
        
        }
    }
    

}
