//
//  AccountsFeedWranglerWindowController.swift
//  NetNewsWire
//
//  Created by Richard Allen on 6/10/19.
//  Copyright © 2019 Ranchero Software. All rights reserved.
//

import AppKit
import Account
import RSWeb

class AccountsFeedWranglerWindowController: NSWindowController {
	
	@IBOutlet weak var progressIndicator: NSProgressIndicator!
	@IBOutlet weak var usernameTextField: NSTextField!
	@IBOutlet weak var passwordTextField: NSSecureTextField!
	@IBOutlet weak var errorMessageLabel: NSTextField!
	@IBOutlet weak var actionButton: NSButton!
	
	var account: Account?
	
	private weak var hostWindow: NSWindow?
	
	convenience init() {
		self.init(windowNibName: NSNib.Name("AccountsFeedWrangler"))
	}
	
	override func windowDidLoad() {
		if let account = account, let credentials = try? account.retrieveBasicCredentials() {
			if case .basic(let username, let password) = credentials {
				usernameTextField.stringValue = username
				passwordTextField.stringValue = password
			}
			actionButton.title = NSLocalizedString("Update", comment: "Update")
		} else {
			actionButton.title = NSLocalizedString("Create", comment: "Create")
		}
	}
	
	// MARK: API
	
	func runSheetOnWindow(_ hostWindow: NSWindow, completionHandler handler: ((NSApplication.ModalResponse) -> Void)? = nil) {
		self.hostWindow = hostWindow
		hostWindow.beginSheet(window!, completionHandler: handler)
	}
	
	// MARK: Actions
	
	@IBAction func cancel(_ sender: Any) {
		hostWindow!.endSheet(window!, returnCode: NSApplication.ModalResponse.cancel)
	}
	
	@IBAction func action(_ sender: Any) {
		self.errorMessageLabel.stringValue = ""
		
		guard !usernameTextField.stringValue.isEmpty && !passwordTextField.stringValue.isEmpty else {
			self.errorMessageLabel.stringValue = NSLocalizedString("Username & password required.", comment: "Credentials Error")
			return
		}
		
		actionButton.isEnabled = false
		progressIndicator.isHidden = false
		progressIndicator.startAnimation(self)
		
		let credentials = Credentials.basic(username: usernameTextField.stringValue, password: passwordTextField.stringValue)
		Account.validateCredentials(type: .feedWrangler, credentials: credentials) { [weak self] result in
			
			guard let self = self else { return }
			
			self.actionButton.isEnabled = true
			self.progressIndicator.isHidden = true
			self.progressIndicator.stopAnimation(self)
			
			switch result {
			case .success(let authenticated):
				if authenticated {
					
					var newAccount = false
					if self.account == nil {
						self.account = AccountManager.shared.createAccount(type: .feedWrangler)
						newAccount = true
					}
					
					do {
						try self.account?.removeBasicCredentials()
						try self.account?.storeCredentials(credentials)
						if newAccount {
							self.account?.refreshAll() { result in
								switch result {
								case .success:
									break
								case .failure(let error):
									NSApplication.shared.presentError(error)
								}
							}
						}
						self.hostWindow?.endSheet(self.window!, returnCode: NSApplication.ModalResponse.OK)
					} catch {
						self.errorMessageLabel.stringValue = NSLocalizedString("Keychain error while storing credentials.", comment: "Credentials Error")
					}
					
				} else {
					self.errorMessageLabel.stringValue = NSLocalizedString("Invalid email/password combination.", comment: "Credentials Error")
				}
				
			case .failure:
				self.errorMessageLabel.stringValue = NSLocalizedString("Network error.  Try again later.", comment: "Credentials Error")
			}
		}
	}
	
}
