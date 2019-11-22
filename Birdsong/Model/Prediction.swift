//
//  Prediction.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import Foundation

class Prediction: ObservableObject {
    @Published var sentiment: Sentiment
    @Published var score: Int
    @Published var tweets: [Tweet]
    
    init(sentiment: Sentiment, score: Int = 50, tweets: [Tweet] = [Tweet]()) {
        self.sentiment = sentiment
        self.score = score
        self.tweets = tweets
    }
}
