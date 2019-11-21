//
//  TweetListTableViewControllerView.swift
//  Birdsong
//
//  Created by Jacob Clayden on 19/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import SwiftUI

struct TweetListTableViewControllerView: UIViewControllerRepresentable {
    @EnvironmentObject private var predictionManager: PredictionManager
    
    func makeUIViewController(context: Context) -> TweetListTableViewController {
        TweetListTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: TweetListTableViewController, context: UIViewControllerRepresentableContext<TweetListTableViewControllerView>) {
        uiViewController.tweets = predictionManager.prediction.tweets
    }
    
}
