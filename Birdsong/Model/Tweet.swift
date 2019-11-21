//
//  Tweet.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI
import Swifter

class Tweet: ObservableObject, Identifiable {
    @Published var createdAt: Date = Date()
    @Published var id: UInt = 0
    @Published var text: String = ""
    @Published var user: User = User()
    @Published var inReplyToScreenName: String?
    @Published var isQuoteStatus: Bool?
    @Published var quotedStatus: Tweet?
    @Published var retweetCount: UInt = 0
    @Published var favouriteCount: UInt = 0
    @Published var score: Int?
    
    init() {
        
    }
    
    init(createdAt: Date, id: UInt, text: String, user: User, inReplyToScreenName: String? = nil, isQuoteStatus: Bool? = nil, quotedStatus: Tweet? = nil, retweetCount: UInt, favouriteCount: UInt, score: Int? = nil) {
        self.createdAt = createdAt
        self.id = id
        self.text = text
        self.user = user
        self.inReplyToScreenName = inReplyToScreenName
        self.isQuoteStatus = isQuoteStatus
        self.quotedStatus = quotedStatus
        self.retweetCount = retweetCount
        self.favouriteCount = favouriteCount
    }
    
    convenience init(from json: JSON) {
        self.init()
        
        if let id = json["id"].integer {
            self.id = UInt(id)
        }
        if let createdAt = json["created_at"].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
            if let createdAt = dateFormatter.date(from: createdAt) {
                self.createdAt = createdAt
            }
        }
        if let text = json["text"].string {
            self.text = text
        }
        if let text = json["full_text"].string {
            self.text = text
        }
        self.user = User(from: json["user"])
        if let inReplyToScreenName = json["in_reply_to_screen_name"].string {
            self.inReplyToScreenName = inReplyToScreenName
        }
        if let isQuoteStatus = json["is_quote_status"].bool {
            self.isQuoteStatus = isQuoteStatus
        }
        if let _ = json["quoted_status"].object {
            self.quotedStatus = Tweet(from: json["quoted_status"])
        }
        if let retweetCount = json["retweet_count"].integer {
            self.retweetCount = UInt(retweetCount)
        }
        if let favouriteCount = json["favorite_count"].integer {
            self.favouriteCount = UInt(favouriteCount)
        }
    }
}

