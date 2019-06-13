//
//  FeedWranglerAccountDelegate.swift
//  Account
//
//  Created by Richard Allen on 6/9/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
import RSCore
#endif
import Articles
import RSCore
import RSParser
import RSWeb
import SyncDatabase
import os.log

public enum FeedWranglerAccountDelegateError: String, Error {
	case invalidParameter = "An invalid parameter was used."
}

final class FeedWranglerAccountDelegate: AccountDelegate {
	
	private let database: SyncDatabase
	
	private let caller: FeedWranglerAPICaller
	private var log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "FeedWrangler")
	
	var supportsSubFolders: Bool = false
	var usesTags: Bool = false
	var opmlImportInProgress: Bool = false
	var server: String? = "feedwrangler.net"
	
	var credentials: Credentials? {
		didSet {
			caller.credentials = credentials
		}
	}
	
	var accountMetadata: AccountMetadata? {
		didSet {
			caller.accountMetadata = accountMetadata
		}
	}
	
	var accessToken: String? {
		didSet {
			caller.accessToken = accessToken
		}
	}
	
	var refreshProgress: DownloadProgress = DownloadProgress(numberOfTasks: 0)
	
	init(dataFolder: String, transport: Transport?) {
		let databaseFilePath = (dataFolder as NSString).appendingPathComponent("Sync.sqlite3")
		database = SyncDatabase(databaseFilePath: databaseFilePath)
		
		if let transport = transport {
			caller = FeedWranglerAPICaller(transport: transport)
		} else {
			let sessionConfiguration = URLSessionConfiguration.default
			sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
			sessionConfiguration.timeoutIntervalForRequest = 60.0
			sessionConfiguration.httpShouldSetCookies = false
			sessionConfiguration.httpCookieAcceptPolicy = .never
			sessionConfiguration.httpMaximumConnectionsPerHost = 1
			sessionConfiguration.httpCookieStorage = nil
			sessionConfiguration.urlCache = nil
			
			if let userAgentHeaders = UserAgent.headers() {
				sessionConfiguration.httpAdditionalHeaders = userAgentHeaders
			}
			
			caller = FeedWranglerAPICaller(transport: URLSession(configuration: sessionConfiguration))
		}
	}
	
	func refreshAll(for account: Account, completion: @escaping (Result<Void, Error>) -> Void) {
		let taskCount = 5 //TODO: Change this to the real number
		refreshProgress.addToNumberOfTasksAndRemaining(taskCount)
		
		
		
		
	}
	
	func sendArticleStatus(for account: Account, completion: @escaping (() -> Void)) {
		fatalError()
	}
	
	func refreshArticleStatus(for account: Account, completion: @escaping (() -> Void)) {
		fatalError()
	}
	
	func importOPML(for account: Account, opmlFile: URL, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func addFolder(for account: Account, name: String, completion: @escaping (Result<Folder, Error>) -> Void) {
		fatalError()
	}
	
	func renameFolder(for account: Account, with folder: Folder, to name: String, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func removeFolder(for account: Account, with folder: Folder, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func createFeed(for account: Account, url: String, name: String?, container: Container, completion: @escaping (Result<Feed, Error>) -> Void) {
		fatalError()
	}
	
	func renameFeed(for account: Account, with feed: Feed, to name: String, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func addFeed(for account: Account, with: Feed, to container: Container, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func removeFeed(for account: Account, with feed: Feed, from container: Container?, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func moveFeed(for account: Account, with feed: Feed, from: Container, to: Container, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func restoreFeed(for account: Account, feed: Feed, container: Container, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func restoreFolder(for account: Account, folder: Folder, completion: @escaping (Result<Void, Error>) -> Void) {
		fatalError()
	}
	
	func markArticles(for account: Account, articles: Set<Article>, statusKey: ArticleStatus.Key, flag: Bool) -> Set<Article>? {
		fatalError()
	}
	
	func accountDidInitialize(_ account: Account) {
		fatalError()
	}
	
	static func validateCredentials(transport: Transport, credentials: Credentials, completion: @escaping (Result<Bool, Error>) -> Void) {
		let caller = FeedWranglerAPICaller(transport: transport)
		caller.credentials = credentials
		caller.validateCredentials() { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
	}
	
	
}

private extension FeedWranglerAccountDelegate {
	
}
