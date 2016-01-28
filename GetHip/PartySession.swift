//
//  PartySessionManager.swift
//  GetHip
//
//  Created by Okechi on 1/24/16.
//  Copyright (c) 2016 Kroleo. All rights reserved.
//

import Foundation
import MediaPlayer

class PartySession {
    private var partyName: String! = ""
    private var guests: [FriendData] = []
    private var host: FriendData! = nil
    private var currentSong: MPMediaItem! = nil
    
    func setPartyName(name: String){
        
    }
    
    func addGuests(guest: FriendData){
        self.guests.append(guest)
    }
    
    func setHost(newHost: FriendData){
        self.host = newHost
    }
    
    func getPartyName() -> String {
        return self.partyName
    }
    
    func getGuests() -> [FriendData] {
        return self.guests
    }
    
    func getHost() -> FriendData {
        return self.host
    }
}
