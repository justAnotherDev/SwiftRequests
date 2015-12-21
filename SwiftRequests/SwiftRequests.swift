//
//  SwiftRequests.swift
//
//  Created by Casey Evanoff on 12/4/15.
//  Copyright © 2015 Casey Evanoff. All rights reserved.
//
import Foundation
import UIKit

enum SwiftRequestsResponse<SomeType> {
    case success(SomeType)
    case error(String, code:Int)
    
    init(error:NSError) {
        let message = "\(error.domain) [\(error.code)]: \(error.localizedDescription)"
        self = SwiftRequestsResponse.error(message, code: error.code)
    }
}

class SwiftRequests {
    
    static func send<ResponseType>(URL:String, headers:[String:String]?=nil, thru handler:NSData -> SwiftRequestsResponse<ResponseType>, to completionBlock:SwiftRequestsResponse<ResponseType> -> Void) {
        // make sure the url is valid
        guard let nsURL = NSURL(string: URL) else { return completionBlock(SwiftRequestsResponse.error("Invalid URL:\(URL)", code:Error.InvalidURL.rawValue)) }
        
        // create the request and add the headers
        let request = NSMutableURLRequest(URL: nsURL)
        if let headers = headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        // when the request finishes pass the data thru the handler and pass the results to the completion block
        let completionHandler:(NSData?, NSURLResponse?, NSError?) -> Void = { data, response, error in
            if let error = error { return completionBlock(SwiftRequestsResponse(error: error)) }
            guard let data = data else { return completionBlock(SwiftRequestsResponse.error("No Data", code:Error.NoData.rawValue)) }
            completionBlock(handler(data))
        }
        
        // fire the request
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:completionHandler).resume()
    }
    
    // define error codes
    enum Error: Int {
        case InvalidURL = 900
        case NoData
    }
}

// a collection of basic parsers
extension SwiftRequests {
    static let JSONParser: NSData -> SwiftRequestsResponse<AnyObject> = { data in
        if let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []) {
            return SwiftRequestsResponse.success(jsonObject)
        }
        return SwiftRequestsResponse.error("JSON Inflation Failed", code:ParserError.JSONInflationFailed.rawValue)
    }
    
    static let StringParser: NSData -> SwiftRequestsResponse<String> = { data in
        guard let stringValue = NSString.init(data: data, encoding: NSUTF8StringEncoding) else { return SwiftRequestsResponse.error("Not UTF8 Compliant", code:ParserError.NotUTF8Compliant.rawValue) }
        return SwiftRequestsResponse.success(String(stringValue))
    }
    
    static let ImageParser: NSData -> SwiftRequestsResponse<UIImage> = { data in
        guard let image = UIImage.init(data: data) else { return SwiftRequestsResponse.error("Not Image Data", code:ParserError.NotImageData.rawValue) }
        return SwiftRequestsResponse.success(image)
    }
    
    // define error codes
    enum ParserError: Int {
        case JSONInflationFailed = 800
        case NotUTF8Compliant
        case NotImageData
    }
}
