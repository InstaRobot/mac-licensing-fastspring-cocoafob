// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

open class UserDefaults {

    public static var sharedInstance: UserDefaults = UserDefaults()
    
    static func resetSharedInstance() {
        UserDefaults.sharedInstance = UserDefaults()
    }

    let userDefaults: Foundation.UserDefaults
    
    public convenience init() {
        self.init(userDefaults: Foundation.UserDefaults.standard)
    }
    
    public init(userDefaults aUserDefaults: Foundation.UserDefaults) {
        userDefaults = aUserDefaults
    }
    
    open static func standardUserDefaults() -> Foundation.UserDefaults {
        return sharedInstance.userDefaults
    }
}
