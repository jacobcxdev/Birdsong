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
    
    private var showingPrediction: Bool {
        get {
            predictionManager.prediction.sentiment != .null
        }
    }
    private var sentiment: Sentiment {
        get {
            predictionManager.prediction.sentiment
        }
    }
    private var score: Int {
        get {
            predictionManager.prediction.score
        }
    }
    
    var body: some View {
        NavigationView {
        ScrollView(showsIndicators: false) {
            VStack {
                Spacer()
                if showingPrediction {
                    VStack(spacing: 20) {
                        sentiment.image
                            .font(.system(size: 100))
                            .padding()
                        if showingPrediction {
                            Text("\(score)% +ve ⇒ \(sentiment.state)")
                                .font(.headline)
                        }
                    }
                    .foregroundColor(.white)
                    .shadow(color: Color(.systemBackground).opacity(0.5), radius: 10)
                } else {
                    Arrow(size: 100, direction: .down)
                }
                Spacer()
                TextField("[Input search term]", text: $searchTerm, onEditingChanged: { changed in
                    if changed && self.showingPrediction {
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
                    .zIndex(.infinity)
                    .padding()
                    .background(GeometryGetter(rect: $kGuardian.rects[0]))
                    .offset(y: kGuardian.slide)
                    .shadow(color: Color(.systemBackground).opacity(0.5), radius: 10)
                    .animation(.spring())
                    .onAppear {
                        self.kGuardian.addObserver()
                    }
                    .onDisappear {
                        self.kGuardian.removeObserver()
                    }
                Spacer()
                if showingPrediction {
                    Arrow(size: 20, direction: .up)
                    TweetListView()
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .strokeBorder(Color(.secondarySystemGroupedBackground), style: .init(lineWidth: 2))
                        )
                        .shadow(color: Color(.systemBackground).opacity(0.5), radius: 10)
                        .padding()
                        .frame(height: UIScreen.main.bounds.height * 0.618)
                } else {
                    Arrow(size: 100, direction: .up)
                    Spacer()
                    Text("Submit a search term first.")
                    Spacer()
                }
            }
            .frame(height: showingPrediction ? UIScreen.main.bounds.height * 1.5 : UIScreen.main.bounds.height * 1.25)
        }
        .background(sentiment.colour)
        .animation(.easeInOut(duration: 1))
        .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 0, name: "Jacob Clayden", screenName: "jcxdev", verified: true, profileImageURL: URL(string: "https://pbs.twimg.com/profile_images/1180201672188010496/oO2juOp4_normal.jpg")!, profileBackgroundColour: UIColor.systemBlue)
        let tweet = Tweet(createdAt: Date(), identifier: 0, text: "This is a Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: "jcxdev", isQuoteStatus: true, quotedStatus: Tweet(createdAt: Date(), identifier: 0, text: "This is a quoted Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: user.screenName, isQuoteStatus: false, quotedStatus: nil, retweetCount: 999999999, favouriteCount: 999999999), retweetCount: 999999999, favouriteCount: 999999999)
        let predictionManager = PredictionManager()
        predictionManager.prediction.tweets = [tweet]
        return ContentView()
            .environmentObject(predictionManager)
        //            .colorScheme(.dark)
    }
}
