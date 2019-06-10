//
//  FeedWranglerAuthorizationResponse.swift
//  Account
//
//  Created by Richard Allen on 6/10/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

import Foundation

struct FeedWranglerAuthorizationResponse: Codable {
	
	let accessToken: String
	let feeds: [FeedWranglerSubscription]
	var error: String? = nil
	
	enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case feeds = "feeds"
		case error = "error"
	}
	
}
