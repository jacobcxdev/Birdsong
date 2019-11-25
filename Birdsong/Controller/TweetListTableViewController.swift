//
//  TweetListTableViewController.swift
//  Birdsong
//
//  Created by Jacob Clayden on 19/11/2019.
//  Copyright © 2019 JacobCXDev. All rights reserved.
//

import UIKit
import SwiftUI
import TinyConstraints

class TweetListTableViewController: UITableViewController {
    var tweets: [Tweet]?
    
    convenience init(tweets: [Tweet]) {
        self.init(style: .plain)
        self.tweets = tweets
    }
    
    convenience init() {
        self.init(style: .plain)
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tweets = tweets {
            let cell = UITableViewCell()
            let tweet = TweetView()
                .environmentObject(tweets[indexPath.row])
            let hostingController = UIHostingController(rootView: tweet)
            
            cell.contentView.addSubview(hostingController.view)
            addChild(hostingController)
            hostingController.didMove(toParent: self)
            
            hostingController.view.edgesToSuperview()
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets?.count ?? 0
    }
    
}
