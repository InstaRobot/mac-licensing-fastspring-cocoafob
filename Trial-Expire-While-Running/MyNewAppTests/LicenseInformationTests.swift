// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicenseInformationTests: XCTestCase {

    // MARK: Trial Up user info
    
    func testToUserInfo_TrialUp_SetsRegisteredToFalse() {
        
        let licenseInfo = LicenseInformation.trialUp
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered == false)
        }
    }
    
    func testToUserInfo_TrialUp_SetsOnTrialToFalse() {
        
        let licenseInfo = LicenseInformation.trialUp
        
        let registered = licenseInfo.userInfo()["on_trial"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered == false)
        }
    }
    
    func testToUserInfo_TrialUp_HasNoNameKey() {

        let licenseInfo = LicenseInformation.trialUp
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["name"]))
    }
    
    func testToUserInfo_TrialUp_HasNoLicenseCodeKey() {
        
        let licenseInfo = LicenseInformation.trialUp
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["licenseCode"]))
    }
    
    func testToUserInfo_TrialUp_HasNoStartDateKey() {
        
        let licenseInfo = LicenseInformation.trialUp
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["trial_start_date"]))
    }
    
    func testToUserInfo_TrialUp_HasNoEndDateKey() {
        
        let licenseInfo = LicenseInformation.trialUp
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["trial_end_date"]))
    }
    
    
    // MARK: On Trial user info
    
    let trialPeriod = TrialPeriod(startDate: Date(timeIntervalSince1970: 1234), endDate: Date(timeIntervalSince1970: 98765))
    
    func testToUserInfo_OnTrial_SetsRegisteredToFalse() {
        
        let licenseInfo = LicenseInformation.onTrial(trialPeriod)
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered == false)
        }
    }
    
    func testToUserInfo_OnTrial_SetsOnTrialToTrue() {
        
        let licenseInfo = LicenseInformation.onTrial(trialPeriod)
        
        let registered = licenseInfo.userInfo()["on_trial"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered == true)
        }
    }
    
    func testToUserInfo_OnTrial_HasNoNameKey() {
        
        let licenseInfo = LicenseInformation.onTrial(trialPeriod)
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["name"]))
    }
    
    func testToUserInfo_OnTrial_HasNoLicenseCodeKey() {
        
        let licenseInfo = LicenseInformation.onTrial(trialPeriod)
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["licenseCode"]))
    }
    
    func testToUserInfo_OnTrial_SetsStartDate() {
        
        let licenseInfo = LicenseInformation.onTrial(trialPeriod)
        
        let startDate = licenseInfo.userInfo()["trial_start_date"] as? Date
        XCTAssert(hasValue(startDate))
        if let startDate = startDate {
            XCTAssertEqual(startDate, trialPeriod.startDate)
        }
    }
    
    func testToUserInfo_OnTrial_SetsEndDate() {
        
        let licenseInfo = LicenseInformation.onTrial(trialPeriod)
        
        let endDate = licenseInfo.userInfo()["trial_end_date"] as? Date
        XCTAssert(hasValue(endDate))
        if let startDate = endDate {
            XCTAssertEqual(startDate, trialPeriod.endDate)
        }
    }
    
    
    // MARK: Registered user info
    
    let license = License(name: "a name", licenseCode: "a license code")
    
    func testToUserInfo_Registered_SetsRegisteredToTrue() {
        
        let licenseInfo = LicenseInformation.registered(license)
        
        let registered = licenseInfo.userInfo()["registered"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered)
        }
    }
    
    func testToUserInfo_Registered_SetsOnTrialToFalse() {
        
        let licenseInfo = LicenseInformation.registered(license)
        
        let registered = licenseInfo.userInfo()["on_trial"] as? Bool
        XCTAssert(hasValue(registered))
        if let registered = registered {
            XCTAssert(registered == false)
        }
    }
    
    func testToUserInfo_Registered_SetsNameKeyToLicense() {
        
        let licenseInfo = LicenseInformation.registered(license)
        
        let name = licenseInfo.userInfo()["name"] as? String
        XCTAssert(hasValue(name))
        if let name = name {
            XCTAssertEqual(name, license.name)
        }
    }
    
    func testToUserInfo_Registered_SetsLicenseCodeKeyToLicense() {
        
        let licenseInfo = LicenseInformation.registered(license)
        
        let licenseCode = licenseInfo.userInfo()["licenseCode"] as? String
        XCTAssert(hasValue(licenseCode))
        if let licenseCode = licenseCode {
            XCTAssertEqual(licenseCode, license.licenseCode)
        }
    }
    
    func testToUserInfo_Registered_HasNoStartDateKey() {
        
        let licenseInfo = LicenseInformation.registered(license)
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["trial_start_date"]))
    }
    
    func testToUserInfo_Registered_HasNoEndDateKey() {
        
        let licenseInfo = LicenseInformation.registered(license)
        
        XCTAssertFalse(hasValue(licenseInfo.userInfo()["trial_end_date"]))
    }
    
    
    // MARK: -
    
    func testFromUserInfo_EmptyUserInfo_ReturnsNil() {
        
        let userInfo = UserInfo()
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UserInfoWithoutRegistered_ReturnsNil() {
        
        let userInfo: UserInfo = ["name" : "foo", "licenseCode" : "bar"]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    
    // MARK: From user info to TrialUp
    
    func testFromUserInfo_UnregisteredUserInfo_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : false]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UnregisteredUserInfo_NotOnTrial_ReturnsTrialUp() {
        
        let userInfo: UserInfo = ["registered" : false, "on_trial" : false]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssert(hasValue(result))
        if let result = result {
            
            let valid: Bool
            switch result {
            case .trialUp: valid = true
            default: valid = false
            }
            
            XCTAssert(valid)
        }
    }
    
    func testFromUserInfo_UnregisteredUserInfo_NotOnTrial_WithAdditionalInfo_ReturnsTrialUp() {
        
        let userInfo: UserInfo = ["registered" : false, "on_trial" : false, "bogus" : 123]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssert(hasValue(result))
        if let result = result {
            
            let valid: Bool
            switch result {
            case .trialUp: valid = true
            default: valid = false
            }
            
            XCTAssert(valid)
        }
    }
    
    
    // MARK: From user info to On Trial
    
    func testFromUserInfo_Unregistered_OnTrialOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : false, "on_trial" : true]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UnregisteredOnTrial_WithStartDateOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : false, "on_trial" : true, "trial_start_date" : NSDate()]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UnregisteredOnTrial_WithEndDateOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : false, "on_trial" : true, "trial_end_date" : NSDate()]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_UnregisteredOnTrial_WithStartAndEndDate_ReturnsOnTrial() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: 1000)
        let endDate = Date(timeIntervalSinceReferenceDate: 9000)
        let userInfo: UserInfo = ["registered" : false, "on_trial" : true, "trial_start_date" : startDate, "trial_end_date" : endDate]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        switch result {
        case let .some(.onTrial(trialPeriod)):
            XCTAssertEqual(trialPeriod.startDate, startDate)
            XCTAssertEqual(trialPeriod.endDate, endDate)
        default:
            XCTFail("expected OnTrial")
        }
    }
    
    
    func testFromUserInfo_UnregisteredOnTrial_WithStartAndEndDateAndAdditionalData_ReturnsOnTrial() {
        
        let startDate = Date(timeIntervalSinceReferenceDate: 1000)
        let endDate = Date(timeIntervalSinceReferenceDate: 9000)
        let userInfo: UserInfo = ["registered" : false, "on_trial" : true, "trial_start_date" : startDate, "trial_end_date" : endDate, "to be ignored" : "stuff"]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        switch result {
        case let .some(.onTrial(trialPeriod)):
            XCTAssertEqual(trialPeriod.startDate, startDate)
            XCTAssertEqual(trialPeriod.endDate, endDate)
        default:
            XCTFail("expected OnTrial")
        }
    }
    
    
    // MARK: From user info to Registered
    
    func testFromUserInfo_RegisteredUserInfo_WithoutDetails_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true, "name" : "a name"]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithLicenseCodeOnly_ReturnsNil() {
        
        let userInfo: UserInfo = ["registered" : true, "licenseCode" : "a license code"]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        XCTAssertFalse(hasValue(result))
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameAndLicenseCode_ReturnsRegistered() {
        
        let name = "the name"
        let licenseCode = "the license code"
        let userInfo: UserInfo = ["registered" : true, "name" : name, "licenseCode" : licenseCode]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        switch result {
        case let .some(.registered(license)):
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, licenseCode)
        default:
            XCTFail("expected Registered")
        }
    }
    
    func testFromUserInfo_RegisteredUserInfo_WithNameAndLicenseCodeAndAdditionalData_ReturnsRegistered() {
        
        let name = "the name"
        let licenseCode = "the license code"
        let userInfo: UserInfo = ["registered" : true, "name" : name, "licenseCode" : licenseCode, "irrelevant" : 999]
        
        let result = LicenseInformation.fromUserInfo(userInfo: userInfo)
        
        switch result {
        case let .some(.registered(license)):
            XCTAssertEqual(license.name, name)
            XCTAssertEqual(license.licenseCode, licenseCode)
        default:
            XCTFail("expected Registered")
        }
    }
}
