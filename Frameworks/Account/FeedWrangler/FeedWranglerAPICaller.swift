//
//  FeedWranglerAPICaller.swift
//  Account
//
//  Created by Richard Allen on 6/9/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import RSWeb

enum CreateFeedWranglerSubscriptionResult {
	case created(FeedWranglerSubscription)
	case multipleChoice([FeedWranglerSubscriptionChoice])
	case alreadySubscribed
	case notFound
}

enum FeedWranglerAPICallerError: Error {
	case invalidData
	case noAccessToken
}

final class FeedWranglerAPICaller: NSObject {
	
	private let baseURL = URL(string: "https://feedwrangler.net/api/v2/")!
	private let clientKey = URLQueryItem(name: "client_key",
										 value: "228018774a2dd85c0af37b266646ac47")
	var accessToken: String? = nil
	
	private var transport: Transport
	
	var credentials: Credentials?
	weak var accountMetadata: AccountMetadata?
	
	init(transport: Transport) {
		self.transport = transport
		super.init()
	}
	
	func validateCredentials(completion: @escaping (Result<Bool, Error>) -> Void) {
		guard let credentials = credentials,
		      case let Credentials.basic(username, password) = credentials else {
			completion(.failure(CredentialsError.incompleteCredentials))
			return
		}
		
		let callURL = baseURL.appendingPathComponent("users")
							 .appendingPathComponent("authorize")
							 .appendingQueryItem(name: "email", value: username)
							 .appendingQueryItem(name: "password", value: password)
							 .appendingQueryItem(clientKey)
		
		let request = URLRequest(url: callURL)
		
		transport.send(request: request) { result in
			switch result {
			case .success(let response):
				guard let responseData = response.1 else {
					completion(.failure(FeedWranglerAPICallerError.invalidData))
					return
				}
				do {
					let parsedResponse = try JSONDecoder().decode(FeedWranglerAuthorizationResponse.self, from: responseData)
					if let accessToken = parsedResponse.accessToken {
						self.accessToken = accessToken
					} else {
						completion(.failure(FeedWranglerAPICallerError.noAccessToken))
					}
					
				} catch let error {
					completion(.failure(error))
				}
				
			case .failure(let error):
				switch error {
				case TransportError.httpError(status: let status):
					if status == 401 {
						completion(.success(false))
					} else {
						completion(.failure(error))
					}
				default:
					completion(.failure(error))
				}
			}
		}
	}
}

private extension URL {
	func appendingQueryItem(name: String, value: String?) -> URL {
		return appendingQueryItem(URLQueryItem(name: name, value: value))
	}
	
	func appendingQueryItem(_ queryItem: URLQueryItem) -> URL {
		var components = URLComponents(string: absoluteString)
		if components?.queryItems?.count ?? 0 > 0 {
			components?.queryItems?.append(queryItem)
		} else {
			components?.queryItems = [queryItem]
		}
		
		return components!.url!
	}
}
