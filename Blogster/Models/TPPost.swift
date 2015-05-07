//
//  TPPost.swift
//  TextPoster
//
//  Created by Logan Wright on 4/10/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit
import Genome

class TPPost: NSObject {
    var title: String = ""
    var body: String = ""
    var id: Int = 0
    var updatedAt: NSDate?
    var createdAt: NSDate?
}

extension TPPost: GenomeObject {
    class func mapping() -> [NSObject : AnyObject] {
        var mapping: [NSObject : AnyObject] = [:]
        mapping["title"] = "title"
        mapping["body"] = "body"
        mapping["id"] = "id"
        mapping["updatedAt@ISO8601DateTransformer"] = "updated_at"
        mapping["createdAt@ISO8601DateTransformer"] = "created_at"
        return mapping
    }
}
