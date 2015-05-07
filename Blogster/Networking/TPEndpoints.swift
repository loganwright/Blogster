//
//  TPEndpoints.swift
//  TextPoster
//
//  Created by Logan Wright on 4/10/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit
import Polymer

class TPBaseEndpoint : PLYEndpoint {
    
    override var baseUrl: String {
        return "http://localhost:3000"
    }
    
    override var acceptableContentTypes: Set<NSObject> {
        return Set(["application/json", "text/html"])
    }
    
    override var headerFields: [NSObject : AnyObject] {
        var header: [NSObject : AnyObject] = [:]
        header["Accept"] = "application/vnd.intrepid.io+json; version=1"
        return header
    }
    
}

// Named content endpoint because post endpoint gets confusing w/ http request jargon
class TPContentEndpoint : TPBaseEndpoint {
    override var returnClass: AnyClass {
        return TPPost.self
    }
    
    override var endpointUrl: String {
        return "posts/:id"
    }
}