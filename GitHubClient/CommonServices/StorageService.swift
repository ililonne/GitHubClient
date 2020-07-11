//
//  StorageService.swift
//  GitHubClient
//
//  Created by Darya on 21.06.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class StorageService {
    
    enum StorageKey: String {
        case token = "token"
    }
    
    @discardableResult
    class func setKeychainParameter(_ parameter: String, key: StorageKey) -> Bool {
        return KeychainWrapper.standard.set(parameter, forKey:  key.rawValue)
    }

    class func getKeychainParameter(key: StorageKey) -> String? {
        return KeychainWrapper.standard.string(forKey: key.rawValue)
    }

    class func clearParameteres() -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: StorageKey.token.rawValue)
    }
}
