//
//  Chat.swift
//  Instagram
//
//  Created by Antony Paul on 20/09/2019.
//  Copyright © 2019 Instagram. All rights reserved.
//

import UIKit
import Firebase

class Chat {
    var uid: String
    var ref: DatabaseReference
    var users: [User]
    var lastMessage: String
    var lastUpdate: Double
    var messageIds: [String]
    var title: String
    var featuredImageUID: String
    
    //What do we need Parameters
    init(users: [User], title: String, featuredImageUID: String)
    {
            self.users = users
            self.title = title
            lastUpdate = Date().timeIntervalSince1970
            messageIds = []
            lastMessage = ""
            self.featuredImageUID = featuredImageUID
        
        ref = WADatabaseReference.chats.reference().childByAutoId()
        uid = ref.key
    }
    
    //Challenge
    init(dictionary : [String : Any])
    {
        uid = dictionary["uid"] as! String
        ref = WADatabaseReference.chats.reference().child(uid)
        title = dictionary["title"] as! String
        lastUpdate = dictionary["lastUpdate"] as! Double
        lastMessage = dictionary["lastMessage"] as! String
        featuredImageUID = dictionary["featureImageUID"] as! String
        
        // Access the users
        users = []
        if let userDict = dictionary["users"] as? [String : Any] {
            for (_, userDict) in userDict {
                if let userDict = userDict as? [String : Any] {
                    self.users.append(User(dictionary: userDict))
                }
                
            }
        }
        //messagesIds
        messageIds = []
        if let messagesIdsDict = dictionary["messageIds"] as? [String : Any] {
            for (_, messageId) in messagesIdsDict {     //Don't care about the key only messageId
                if let messageId = messageId as? String {
                    self.messageIds.append(messageId)
                }
            }
        }
    }
    
    func save() //chat
    {
        ref.setValue(toDictionary())
        
        let userRef = ref.child("users")
        for user in users {
            userRef.child(user.uid).setValue(user.toDictionary())
        }
        
        let messageIdsRef = ref.child("messageIds")
        for messageId in messageIds {
            messageIdsRef.childByAutoId().setValue(messageId)
        }
    }
    
    func toDictionary() -> [String: Any]
    {
        return [
            "uid" : uid,
            "lastMessage" : lastMessage,
            "lastUpdate" : lastUpdate,
            "title" : title,
            "featuredImageUID" : featuredImageUID,
            
        ]
    }
}

extension Chat {
    func downloadFeaturedImage(completion: @escaping (UIImage?, Error?) -> ())
    {
        FIRImage.downLoadProfileImage(self.featuredImageUID, completion: {
            (image, error) in
            completion(image, error)
        })
    }
    
    func send(message: Message)
    {
        self.messageIds.append(message.uid)
    }
}

//Compare the chat
extension Chat : Equatable { }

func ==(lhs: Chat, rhs: Chat) -> Bool {
    return lhs.uid == rhs.uid
}














