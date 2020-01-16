//
//  Message.swift
//  Instagram
//
//  Created by Antony Paul on 21/09/2019.
//  Copyright © 2019 Instagram. All rights reserved.
//

import Foundation
import Firebase

public struct MessageType {
    static let text = "text"
    static let image = "image"
    static let video = "video"
}

class Message
{
    var ref: DatabaseReference
    var uid: String
    var senderDisplayName: String
    var senderUID: String
    var lastUpdate: Date
    var type: String
    var text: String
    
    init(senderUID: String, senderDisplayName: String, type: String, text: String)
    {
        ref = WADatabaseReference.messages.reference().childByAutoId()
        uid = ref.key
        self.senderDisplayName = senderDisplayName
        self.senderUID = senderUID
        self.type = type
        self.text = text
        self.lastUpdate = Date()
    }
    
    //
    init(dicitonary: [String : Any])
    {
        uid = dicitonary["uid"] as! String
        ref = WADatabaseReference.messages.reference().child(uid)
        senderUID = dicitonary["senderUID"] as! String
        senderDisplayName = dicitonary["senderDisplayName"] as! String
        lastUpdate = Date(timeIntervalSince1970 : dicitonary["lastUpdate"] as! Double)
        type = dicitonary["type"] as! String
        text = dicitonary["text"] as! String
        
    }
    
    //Challenge 2
    func save()
    {
        ref.setValue(toDictionary())
    }
    
    //Challenge 1
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : uid,
            "denderDisplayName" : senderDisplayName,
            "lastUpdate" : lastUpdate.timeIntervalSince1970,
            "type" : type,
            "text" : text,
            "senderUID" : senderUID
            ]
    }
}

extension Message: Equatable { }

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.uid == rhs.uid
}
















