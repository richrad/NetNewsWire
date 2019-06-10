//
//  FeedWranglerSubscription.swift
//  Account
//
//  Created by Richard Allen on 6/10/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

import Foundation

struct FeedWranglerSubscription: Codable {
	
	let feedID: Int
	let name: String?
	let url: String
	let homePageURL: String?
	
	enum CodingKeys: String, CodingKey {
		case feedID = "feed_id"
		case name = "title"
		case url = "feed_url"
		case homePageURL = "site_url"
	}
	
}

struct FeedWranglerCreateSubscription {
	
}

struct FeedWranglerUpdateSubscription {
	
}

struct FeedWranglerSubscriptionChoice {
	
}


