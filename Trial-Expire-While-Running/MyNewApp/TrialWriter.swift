import Foundation

public class TrialWriter {
    
    public init() { }
    
    lazy var userDefaults: NSUserDefaults = UserDefaults.standardUserDefaults()
    
    public func storeTrial(trialPeriod: TrialPeriod) {
        
        userDefaults.setObject(trialPeriod.startDate, forKey: TrialPeriod.UserDefaultsKeys.StartDate.rawValue)
        userDefaults.setObject(trialPeriod.endDate, forKey: TrialPeriod.UserDefaultsKeys.EndDate.rawValue)
    }
}
