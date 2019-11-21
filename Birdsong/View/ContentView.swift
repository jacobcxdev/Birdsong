//
//  ContentView.swift
//  Twittermenti
//
//  Created by Jacob Clayden on 15/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject private var predictionManager: PredictionManager
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    @State private var searchTerm = ""
    
    var body: some View {
//        NavigationView {
        ScrollView {
            VStack {
                VStack {
                    Spacer()
                    predictionManager.prediction.sentiment.currentSentiment.0
                        .font(.system(size: 100))
                        .padding()
                    Spacer()
                    TextField("[Input search term]", text: $searchTerm, onEditingChanged: { changed in
                        if changed && self.predictionManager.prediction.sentiment != .null {
                            self.predictionManager.prediction = Prediction(sentiment: .null)
                        }
                    }, onCommit: {
                        if !self.searchTerm.isEmpty {
                            self.predictionManager.predict(self.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines))
                            self.searchTerm = ""
                        }
                        self.kGuardian.slide = 0
                    })
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.webSearch)
                        .padding()
                        .background(GeometryGetter(rect: $kGuardian.rects[0]))
                        .offset(y: kGuardian.slide)
                        .animation(.spring())
                        .onAppear {
                            self.kGuardian.addObserver()
                        }
                        .onDisappear {
                            self.kGuardian.removeObserver()
                        }
//                    NavigationLink(destination: TweetListView()) {
//                        Text("View Tweets")
//                    }
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.accentColor)
//                        .cornerRadius(25)
                    Spacer()
                }
                    .frame(height: UIScreen.main.bounds.height)
                TweetListView()
                    .frame(height: predictionManager.prediction.tweets == nil ? UIScreen.main.bounds.height * 0.382 : UIScreen.main.bounds.height * 0.618)
            }
        }
            .background(predictionManager.prediction.sentiment.currentSentiment.1)
            .animation(.easeInOut(duration: 1))
            .edgesIgnoringSafeArea(.all)
            // TODO: Find a new way of displaying the score
//            .navigationBarTitle(predictionManager.prediction.score == nil ? "Birdsong" : "\(predictionManager.prediction.score!)%")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 0, name: "Jacob Clayden", screenName: "jcxdev", verified: true, profileImageURL: URL(string: "https://pbs.twimg.com/profile_images/1180201672188010496/oO2juOp4_normal.jpg")!, profileBackgroundColour: UIColor.systemBlue)
        let tweet = Tweet(createdAt: Date(), id: 0, text: "This is a Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: "jcxdev", isQuoteStatus: true, quotedStatus: Tweet(createdAt: Date(), id: 0, text: "This is a quoted Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: user.screenName, isQuoteStatus: false, quotedStatus: nil, retweetCount: 999999999, favouriteCount: 999999999), retweetCount: 999999999, favouriteCount: 999999999)
        let predictionManager = PredictionManager()
        predictionManager.prediction.tweets = [tweet]
        return ContentView()
            .environmentObject(predictionManager)
//            .colorScheme(.dark)
    }
}
