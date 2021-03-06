// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

open class URLQueryLicenseParser {
    
    public init() { }
    
    open func parseQuery(_ query: String) -> License? {
        
        let queryDictionary = dictionaryFromQuery(query)
        
        if let name = decode(queryDictionary["\(URLComponents.licensee)"]),
            let licenseCode = queryDictionary["\(URLComponents.licenseCode)"] {
                
            return License(name: name, licenseCode: licenseCode)
        }
        
        return .none
    }
    
    func dictionaryFromQuery(_ query: String) -> [String : String] {
        
        let parameters = query.components(separatedBy: "&")
        
        return parameters.mapDictionary() { param -> (String, String)? in
            
            if let queryKey = self.queryKeyFromParameter(param),
                let queryValue = self.queryValueFromParameter(param)
            {
                
                return (queryKey, queryValue)
            }
            
            return .none
        }
    }
    
    func queryKeyFromParameter(_ parameter: String) -> String? {
        
        return parameter.components(separatedBy: "=")[safe:0]
    }
    
    func queryValueFromParameter(_ parameter: String) -> String? {
        
        return escapedQueryValueFromParameter(parameter)
            >>- unescapeQueryValue
    }
    
    func unescapeQueryValue(_ queryValue: String) -> String? {
        
        return queryValue
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }
    
    func escapedQueryValueFromParameter(_ parameter: String) -> String? {
        
        // Assume only one `=` is the separator and concatenate 
        // the rest back into the value.
        // (base64-encoded Strings often end with `=`.)
        return parameter.components(separatedBy: "=").dropFirst().joined(separator: "=")
    }
    
    func decode(_ string: String?) -> String? {
        
        if let string = string, let decodedData = Data(base64Encoded: string, options: []) {
            
            return NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) as? String
        }
        
        return .none
    }
    
}
