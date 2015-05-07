//
//  TPTransformers.swift
//  TextPoster
//
//  Created by Logan Wright on 4/11/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit
import Genome

@objc(ISO8601DateTransformer)
class ISO8601DateTransformer : GenomeTransformer {
    override class func transformFromJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let dateString = fromVal as? String {
            return NSDate.dateWithISO8601String(dateString)
        } else {
            return nil
        }
    }
    override class func transformToJsonValue(fromVal: AnyObject) -> AnyObject? {
        if let date = fromVal as? NSDate {
            return date.iso8601String
        } else {
            return nil
        }
    }
}

// MARK: NDate+ISO8601 Extension

extension NSDate {
    class func dateWithISO8601String(dateString: String) -> NSDate {
        return self.iso8601DateFormatter().dateFromString(dateString)!
    }
    
    var iso8601String: String {
        return NSDate.iso8601DateFormatter().stringFromDate(self)
    }
    
    private class func iso8601DateFormatter() -> NSDateFormatter {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return df
    }
}
