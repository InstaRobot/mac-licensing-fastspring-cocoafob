// Copyright (c) 2015-2016 Christian Tietze
//
// See the file LICENSE for copying permission.

import Foundation

public class URLQueryLicenseParser {
    
    public init() { }
    
    public func parse(query: String) -> License? {
        
        let queryDictionary = dictionary(fromQuery: query)
        
        if let name = decode(string: queryDictionary["\(URLComponents.licensee)"]),
            let licenseCode = queryDictionary["\(URLComponents.licenseCode)"] {
                
            return License(name: name, licenseCode: licenseCode)
        }
        
        return .none
    }
    
    func dictionary(fromQuery query: String) -> [String : String] {
        
        let parameters = query.components(separatedBy: "&")
        
        return parameters.mapDictionary() { param -> (String, String)? in
            
            if let queryKey = self.queryKey(fromParameter: param),
                let queryValue = self.queryValue(fromParameter: param)
            {
                
                return (queryKey, queryValue)
            }
            
            return .none
        }
    }
    
    fileprivate func queryKey(fromParameter parameter: String) -> String? {
        
        return parameter.components(separatedBy: "=")[safe:0]
    }
    
    fileprivate func queryValue(fromParameter parameter: String) -> String? {
        
        return escapedQueryValue(parameter: parameter)
            >>- unescapeQueryValue
    }
    
    fileprivate func unescapeQueryValue(queryValue: String) -> String? {
        
        return queryValue
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
    }
    
    fileprivate func escapedQueryValue(parameter: String) -> String? {
        
        // Assume only one `=` is the separator and concatenate 
        // the rest back into the value.
        // (base64-encoded Strings often end with `=`.)
        return parameter.components(separatedBy: "=")
            .dropFirst()
            .joined(separator: "=")
    }
    
    fileprivate func decode(string: String?) -> String? {
        
        if let string = string, let decodedData = NSData(base64Encoded: string, options: []) {
            
            return NSString(data: decodedData as Data, encoding: String.Encoding.utf8.rawValue) as? String
        }
        
        return .none
    }
    
}
