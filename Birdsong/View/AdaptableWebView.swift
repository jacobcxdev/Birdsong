//
//  AdaptableWebView.swift
//  Birdsong
//
//  Created by Jacob Clayden on 22/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

struct AdaptableWebView: View {
    @State var url: String
    
    fileprivate func webView(url: String) -> AnyView {
        if let url = URL(string: url) {
            return AnyView(
                SafariView(url: url)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        return AnyView(
            VStack {
                Image(systemName: "xmark.octagon.fill")
                    .font(.system(size: 100))
                    .shadow(color: Color(.systemBackground).opacity(0.5), radius: 10)
                    .padding(20)
                Text("Error 404: Invalid URL.")
                    .font(.title)
                    .padding()
                Text("Please swipe down from the top of this view. Sorry for the inconvenience.")
                    .padding()
            }
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    var body: some View {
        webView(url: url)
    }
}
