//
//  ShareTodoRemoteConfig.swift
//  ShareTodo
//
//  Created by jun on 2020/12/10.
//  Copyright © 2020 jun. All rights reserved.
//

import Foundation
import Firebase

final class ShareTodoRemoteConfig {
    private static let config = RemoteConfig.remoteConfig()
    
    private struct Key {
        static let iosLatestVersionKey = "ios_latest_version_key"
        
        static let finishTodoAnimationValueKey = "finishTodo_animation_value"
        static let loadingAnimationEnableKey = "loading_animation_enable"
    }
    
    #if DEBUG
    private static func debugFetchAndActivate() {
        self.config.fetch(withExpirationDuration: 0, completionHandler: { [unowned config] (status, error) in
            guard status == .success else {
                print("Error: \(error as Any)")
                return
            }
            
            config.activate(completion: { (_, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
            })
            
        })
    }
    #endif
    
    static func fetchLeatest() {
        #if DEBUG
        self.debugFetchAndActivate()
        #else
        self.config.fetchAndActivate()
        #endif
    }
    
    static var finishTodoAnimationValue: String? {
        guard let keyString = config.configValue(forKey: Key.finishTodoAnimationValueKey).stringValue else { return nil }
        return keyString
        
    }
    
    static var loadingAnimationEnable: Bool? {
        return config.configValue(forKey: Key.loadingAnimationEnableKey).boolValue
    }
    
    static var iosLatestVersion: String? {
        guard let versionString = config.configValue(forKey: Key.iosLatestVersionKey).nonEmptyStringValue else { return nil }
        return versionString
    }
}

private extension RemoteConfigValue {
    var nonEmptyStringValue: String? {
        if let value = stringValue, !value.isEmpty { return value }
        return nil
    }
}
