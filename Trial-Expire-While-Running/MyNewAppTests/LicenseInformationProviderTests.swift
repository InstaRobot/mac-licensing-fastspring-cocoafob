// Copyright (c) 2015-2016 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
@testable import MyNewApp

class LicenseInformationProviderTests: XCTestCase {

    var licenseInfoProvider: LicenseInformationProvider!
    
    let trialProviderDouble = TestTrialProvider()
    let licenseProviderDouble = TestLicenseProvider()
    let clockDouble = TestClock()
    let verifierDouble = TestVerifier()
    
    override func setUp() {
        
        super.setUp()
        
        licenseInfoProvider = LicenseInformationProvider(trialProvider: trialProviderDouble, licenseProvider: licenseProviderDouble, clock: clockDouble)
        licenseInfoProvider.licenseVerifier = verifierDouble
    }
    
    let irrelevantLicense = License(name: "", licenseCode: "")

    func testLicenceInvalidity_NoLicense_ReturnsFalse() {
        
        XCTAssertFalse(licenseInfoProvider.licenseIsInvalid)
    }
    
    func testLicenceInvalidity_ValidLicense_ReturnsFalse() {
        
        verifierDouble.testValidity = true
        licenseProviderDouble.testLicense = irrelevantLicense
        
        XCTAssertFalse(licenseInfoProvider.licenseIsInvalid)
    }
    
    func testLicenceInvalidity_InvalidLicense_ReturnsFalse() {
        
        verifierDouble.testValidity = false
        licenseProviderDouble.testLicense = irrelevantLicense
        
        XCTAssert(licenseInfoProvider.licenseIsInvalid)
    }
    
    func testCurrentInfo_NoLicense_NoTrialPeriod_ReturnsTrialUp() {
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let trialIsUp: Bool
        
        switch licenseInfo {
        case .trialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
    }
    
    func testCurrentInfo_NoLicense_ActiveTrialPeriod_ReturnsOnTrial() {
        
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: Date())
        clockDouble.testDate = endDate.addingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        switch licenseInfo {
        case let .onTrial(trialPeriod): XCTAssertEqual(trialPeriod, expectedPeriod)
        default: XCTFail("expected to be OnTrial")
        }
    }
    
    func testCurrentInfo_NoLicense_PassedTrialPeriod_ReturnsTrialUp() {
        
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: Date())
        clockDouble.testDate = endDate.addingTimeInterval(100)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let trialIsUp: Bool
        switch licenseInfo {
        case .trialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
    }

    func testCurrentInfo_WithInvalidLicense_NoTrial_ReturnsTrialUp() {
        
        verifierDouble.testValidity = false
        licenseProviderDouble.testLicense = irrelevantLicense
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        let trialIsUp: Bool
        switch licenseInfo {
        case .trialUp: trialIsUp = true
        default: trialIsUp = false
        }
        
        XCTAssert(trialIsUp)
    }
    
    func testCurrentInfo_WithInvalidLicense_OnTrial_ReturnsTrial() {
        
        // Given
        verifierDouble.testValidity = false
        licenseProviderDouble.testLicense = irrelevantLicense
        
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: endDate)
        clockDouble.testDate = endDate.addingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        // When
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        // Then
        switch licenseInfo {
        case let .onTrial(trialPeriod): XCTAssertEqual(trialPeriod, expectedPeriod)
        default: XCTFail("expected to be OnTrial")
        }
    }
    
    func testCurrentInfo_WithValidLicense_NoTrial_ReturnsRegisteredWithInfo() {
        
        verifierDouble.testValidity = true
        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        switch licenseInfo {
        case let .registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .registered(_)")
        }
    }
    
    func testCurrentInfo_WithValidLicense_OnTrial_ReturnsRegistered() {
        
        // Given
        verifierDouble.testValidity = true
        
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: endDate)
        clockDouble.testDate = endDate.addingTimeInterval(-1000)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        // When
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        // Then
        switch licenseInfo {
        case let .registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .registered(_)")
        }
    }
    
    func testCurrentInfo_WithValidLicense_PassedTrial_ReturnsRegistered() {
        
        // Given
        verifierDouble.testValidity = true
        let endDate = Date()
        let expectedPeriod = TrialPeriod(startDate: Date(), endDate: endDate)
        clockDouble.testDate = endDate.addingTimeInterval(+9999)
        trialProviderDouble.testTrialPeriod = expectedPeriod
        
        let name = "a name"
        let licenseCode = "a license code"
        let license = License(name: name, licenseCode: licenseCode)
        licenseProviderDouble.testLicense = license
        
        // When
        let licenseInfo = licenseInfoProvider.currentLicenseInformation
        
        // Then
        switch licenseInfo {
        case let .registered(foundLicense): XCTAssertEqual(foundLicense, license)
        default: XCTFail("expected .registered(_)")
        }
    }
    
    
    // MARK: -
    
    class TestTrialProvider: TrialProvider {
        
        var testTrialPeriod: TrialPeriod?
        override var currentTrialPeriod: TrialPeriod? {
            
            return testTrialPeriod
        }
    }
    
    class TestLicenseProvider: LicenseProvider {
    
        var testLicense: License?
        override var currentLicense: License? {
            
            return testLicense
        }
    }
    
    class TestClock: KnowsTimeAndDate {
        
        var testDate: Date!
        func now() -> Date {
            
            return testDate
        }
    }
    
    class TestVerifier: LicenseVerifier {
        
        init() {
            super.init(appName: "irrelevant app name")
        }
        
        var testValidity = false
        var didCallIsValidWith: (licenseCode: String, name: String)?
        override func isValid(licenseCode: String, forName name: String) -> Bool {
            
            didCallIsValidWith = (licenseCode, name)
            
            return testValidity
        }
    }
}
