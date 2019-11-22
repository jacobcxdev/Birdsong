//
//  TweetView.swift
//  Birdsong
//
//  Created by Jacob Clayden on 18/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI
import URLImage
import ActiveLabel
import WebKit

struct TweetView: View {
    @EnvironmentObject var tweet: Tweet
    @State private var userPageDisplayed = false
    @State private var retweetPageDisplayed = false
    @State private var favouritePageDisplayed = false
    @State private var tweetPageDisplayed = false {
        didSet {
            print("URL: https://twitter.com/\(self.user.screenName)/status/\(self.tweet.id)")
            print("id: \(tweet.id)")
        }
    }
    @State private var headerRect = CGRect()
    
    private var sentiment: Sentiment {
        get {
            tweet.sentiment
        }
    }
    private var user: User {
        get {
            tweet.user
        }
    }
    
    fileprivate func placeholderImage() -> some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 48, height: 48)
    }
    
    fileprivate func namesTextView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.name)
                if user.verified {
                    Image(systemName: "checkmark.seal.fill")
                }
            }
            Button("@\(user.screenName)") {
                self.userPageDisplayed.toggle()
            }
        }
    }
    
    fileprivate func createdAtTextView() -> some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: tweet.createdAt)
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.string(from: tweet.createdAt)
        return VStack(alignment: .trailing) {
            Text(date)
            Text(time)
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                self.userPageDisplayed.toggle()
            }) {
                if user.profileImageURL != nil {
                    URLImage(user.profileImageURL!, placeholder: { _ in
                        self.placeholderImage()
                    }) { proxy in
                        proxy.image
                            .renderingMode(.original)
                    }
                } else {
                    placeholderImage()
                }
            }
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(sentiment.colour)
                )
                .shadow(color: sentiment.colour, radius: 2)
                .sheet(isPresented: $userPageDisplayed) {
                    AdaptableWebView(url: "https://twitter.com/\(self.user.screenName)")
                }
            Divider()
                .overlay(sentiment.colour)
                .padding(10)
            VStack(alignment: .leading) {
                HStack {
                    namesTextView()
                        .frame(maxWidth: headerRect.width * 0.5)
                        .fixedSize()
                        .padding(5)
                    Spacer()
                    VStack {
                        Divider()
                            .overlay(sentiment.colour)
                    }
                        .padding(.horizontal, 5)
                    Spacer()
                    createdAtTextView()
                        .frame(maxWidth: headerRect.width * 0.4)
                        .fixedSize()
                }
                    .font(.caption)
                    .background(GeometryGetter(rect: $headerRect))
                TweetTextView()
                if tweet.quotedStatus != nil {
                    TweetTextView(isQuoted: true)
                }
                HStack {
                    Button(action: {
                        self.tweetPageDisplayed.toggle()
                    }) {
                        Image(systemName: "bubble.right")
                    }
                    Spacer()
                    Button(action: {
                        self.retweetPageDisplayed.toggle()
                    }) {
                        HStack {
                            Image(systemName: "arrow.2.squarepath")
                            Text(tweet.retweetCount.formatPoints())
                        }
                    }
                        .foregroundColor(Color("retweet"))
                        .sheet(isPresented: $retweetPageDisplayed) {
                            AdaptableWebView(url: "https://twitter.com/intent/retweet?tweet_id=\(self.tweet.id)")
                        }
                    Spacer()
                    Button(action: {
                        self.favouritePageDisplayed.toggle()
                    }) {
                        HStack {
                            Image(systemName: "heart")
                            Text(tweet.favouriteCount.formatPoints())
                        }
                    }
                        .foregroundColor(Color("favourite"))
                        .sheet(isPresented: $favouritePageDisplayed) {
                            AdaptableWebView(url: "https://twitter.com/intent/like?tweet_id=\(self.tweet.id)")
                        }
                    Spacer()
                    Button(action: {
                        self.tweetPageDisplayed.toggle()
                    }) {
                        Image(systemName: "link.circle")
                    }
                    .sheet(isPresented: $tweetPageDisplayed) {
                        AdaptableWebView(url: "https://twitter.com/\(self.user.screenName)/status/\(self.tweet.id)")
                    }
                }
            }
        }
            .padding()
    }
}

struct TweetView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 0, name: "Jacob Claydennnnnnnnnnnnnnnnnnnnnnn", screenName: "jcxdev", verified: true, profileImageURL: URL(string: "https://pbs.twimg.com/profile_images/1180201672188010496/oO2juOp4_normal.jpg")!, profileBackgroundColour: UIColor.systemBlue)
        let tweet = Tweet(createdAt: Date(), id: 1196006297562492928, text: "This is a Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: "jcxdev", isQuoteStatus: true, quotedStatus: Tweet(createdAt: Date(), id: 1196006297562492928, text: "This is a quoted Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: user.screenName, isQuoteStatus: false, quotedStatus: nil, retweetCount: 999999999, favouriteCount: 999999999), retweetCount: 999999999, favouriteCount: 999999999)
        return TweetView()
            .environmentObject(tweet)
    }
}

struct TweetTextView: View {
    @EnvironmentObject private var tweet: Tweet
    @State var isQuoted = false
    @State private var modalPageDisplayed = false
    @State private var modalPageSelection: ActiveType = .mention
    @State private var mention = "" {
        didSet {
            modalPageDisplayed.toggle()
        }
    }
    @State private var hashtag = "" {
        didSet {
            modalPageDisplayed.toggle()
        }
    }
    @State private var url = "" {
        didSet {
            modalPageDisplayed.toggle()
        }
    }
    
    var body: some View {
        ActiveLabelView(text: isQuoted ? tweet.quotedStatus!.text : tweet.text, font: .preferredFont(forTextStyle: isQuoted ? .footnote : .body), mentionColor: UIColor.systemBlue, hashtagColor: UIColor.systemBlue, URLColor: UIColor.systemBlue, handleMentionTap: { mention in
            self.modalPageSelection = .mention
            self.mention = mention
        }, handleHashtagTap: { hashtag in
            self.modalPageSelection = .hashtag
            self.hashtag = hashtag
        }, handleURLTap: { url in
            self.modalPageSelection = .url
            self.url = url.absoluteString
        })
            .padding(isQuoted ? 10 : 0)
            .overlay( isQuoted ?
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
                : nil
            )
            .padding(.vertical)
            .sheet(isPresented: self.$modalPageDisplayed) {
                AdaptableWebView(url: self.modalPageSelection == .url ? self.url : "https://twitter.com/\(self.modalPageSelection == .mention ? self.mention : self.modalPageSelection == .hashtag ? "hashtag/\(self.hashtag)" : "")")
            }
    }

//    func interactiveText(text: String) -> Text {
//        var output = Text("")
//        let components = text.tokenize("@#. ")
//        for component in components {
//            if component.rangeOfCharacter(from: CharacterSet(charactersIn: "@#")) != nil {
//                output = output + Text(component)
//                    .foregroundColor(.accentColor)
//            } else {
//                 output = output + Text(component)
//            }
//        }
//        return output
//    }
}
