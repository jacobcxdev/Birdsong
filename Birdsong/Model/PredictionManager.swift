//
//  PredictionManager.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI
import Swifter

class PredictionManager: ObservableObject {
    @Published var prediction = Prediction(sentiment: .null)
    
    let classifier = TwitterSentimentClassifier()
    let swifter = Swifter(consumerKey: "wyLCTURyA94qgtY1xL0VXCLkV", consumerSecret: "gEiNlTueD36tpHi0OsQzqPCqcYPLdYhTSALplkeDne3UbYsK5l")
    
    func predict(_ searchTerm: String) {
        DispatchQueue.main.async {
            self.swifter.searchTweet(using: searchTerm, lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
                var tweets = [Tweet]()
                var tweetTextArray = [TwitterSentimentClassifierInput]()
                if let results = results.array {
                    for tweet in results {
                        let tweetObject = Tweet(from: tweet)
                        tweetTextArray.append(TwitterSentimentClassifierInput(text: tweetObject.text))
                        tweets.append(tweetObject)
                    }
                }
                do {
                    let predictions = try self.classifier.predictions(inputs: tweetTextArray)
                    var score = 50
                    for prediction in predictions {
                        switch prediction.label {
                        case "Pos":
                            score += 1
                        case "Neg":
                            score -= 1
                        default:
                            break
                        }
                    }
                    let prediction = Prediction(sentiment: {
                        if score >= 67 {
                            return .positive
                        } else if score < 33 {
                            return .negative
                        } else {
                            return .neutral
                        }
                    }(), score: score, tweets: tweets)
                    self.prediction = prediction
                } catch {
                    print(error)
                }
            }) { error in
                print(error)
            }
        }
    }
}
