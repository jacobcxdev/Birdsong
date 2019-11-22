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
    @State private var showingTweet = false
    
    private var sentiment: Sentiment {
        get {
            tweet.sentiment
        }
    }
    
    fileprivate func placeholderImage() -> some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 48, height: 48)
    }
    
    fileprivate func namesTextView() -> some View {
        VStack(alignment: .leading) {
            Text(tweet.user.name)
            Text("@\(tweet.user.screenName)")
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
        HStack(alignment: VerticalAlignment.top) {
            Button(action: {

            }) {
                if tweet.user.profileImageURL != nil {
                    URLImage(tweet.user.profileImageURL!, placeholder: { _ in
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
            Divider()
                .overlay(sentiment.colour)
                .padding(10)
            VStack(alignment: .leading) {
                HStack {
                    namesTextView()
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
                }
                    .font(.caption)
                TweetTextView()
                if tweet.quotedStatus != nil {
                    TweetTextView(isQuoted: true)
                }
                HStack {
                    Button(action: {

                    }) {
                        Image(systemName: "bubble.right")
                    }
                    Spacer()
                    Button(action: {

                    }) {
                        HStack {
                            Image(systemName: "arrow.2.squarepath")
                            Text(tweet.favouriteCount.formatPoints())
                        }
                    }
                        .foregroundColor(Color("retweet"))
                    Spacer()
                    Button(action: {

                    }) {
                        HStack {
                            Image(systemName: "heart")
                            Text(tweet.favouriteCount.formatPoints())
                        }
                    }
                        .foregroundColor(Color("favourite"))
                    Spacer()
                    Button(action: {
                        self.showingTweet.toggle()
                    }) {
                        Image(systemName: "link.circle")
                    }
                        .popover(isPresented: $showingTweet) {
                            WebView(url: "https://twitter.com/\(self.tweet.user.screenName)/status/\(self.tweet.id)")
                        }
                }
            }
        }
            .padding()
    }
}

struct TweetView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 0, name: "Jacob Clayden", screenName: "jcxdev", verified: true, profileImageURL: URL(string: "https://pbs.twimg.com/profile_images/1180201672188010496/oO2juOp4_normal.jpg")!, profileBackgroundColour: UIColor.systemBlue)
        let tweet = Tweet(createdAt: Date(), id: 1196006297562492933, text: "This is a Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: "jcxdev", isQuoteStatus: true, quotedStatus: Tweet(createdAt: Date(), id: 1196006297562492933, text: "This is a quoted Tweet. This is a mention @jcxdev. This is a #hashtag.", user: user, inReplyToScreenName: user.screenName, isQuoteStatus: false, quotedStatus: nil, retweetCount: 999999999, favouriteCount: 999999999), retweetCount: 999999999, favouriteCount: 999999999)
        return TweetView()
            .environmentObject(tweet)
    }
}

struct TweetTextView: View {
    @EnvironmentObject private var tweet: Tweet
    @State var isQuoted = false
    
    var body: some View {
        ActiveLabelView(text: isQuoted ? tweet.quotedStatus!.text : tweet.text, font: .preferredFont(forTextStyle: isQuoted ? .footnote : .body), mentionColor: UIColor.systemBlue, hashtagColor: UIColor.systemBlue, URLColor: UIColor.systemBlue, handleMentionTap: { mention in
            print(mention)
        }, handleHashtagTap: { hashtag in
            print(hashtag)
        }, handleURLTap: { url in
            print(url)
        })
            .padding(isQuoted ? 10 : 0)
            .overlay( isQuoted ?
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
                : nil
            )
            .padding(.vertical)
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
