//
//  TweetListView.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

struct TweetListView: View {
    @EnvironmentObject private var predictionManager: PredictionManager
    
    var body: some View {
        if predictionManager.prediction.tweets != nil {
            return AnyView(
//                TweetListTableViewControllerView()
                List(predictionManager.prediction.tweets!) { tweet in
                    TweetView()
                        .environmentObject(tweet)
                }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.easeInOut(duration: 1))
//                ScrollView {
//                    ForEach(predictionManager.prediction.tweets!) { tweet in
//                        TweetView()
//                            .environmentObject(tweet)
//                        Divider()
//                    }
//                }
            )
        } else {
            return AnyView(
                VStack {
                    Spacer()
                    Image(systemName: "arrow.up")
                        .font(.system(size: 100))
                    Spacer()
                    Text("Submit a search term first.")
                    Spacer()
                }
            )
        }
    }
}

struct TweetListView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 0, name: "Jacob Clayden", screenName: "jcxdev", verified: true, profileImageURL: URL(string: "https://pbs.twimg.com/profile_images/1180201672188010496/oO2juOp4_normal.jpg")!, profileBackgroundColour: UIColor.systemBlue)
        let tweet = Tweet(createdAt: Date(), id: 0, text: "This is a Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: "jcxdev", isQuoteStatus: true, quotedStatus: Tweet(createdAt: Date(), id: 0, text: "This is a quoted Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: user.screenName, isQuoteStatus: false, quotedStatus: nil, retweetCount: 999999999, favouriteCount: 999999999), retweetCount: 999999999, favouriteCount: 999999999)
        let predictionManager = PredictionManager()
        predictionManager.prediction.tweets = [tweet, tweet, tweet]
        return TweetListView()
            .environmentObject(predictionManager)
    }
}
