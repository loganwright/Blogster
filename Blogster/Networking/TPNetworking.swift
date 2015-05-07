//
//  TPNetworking.swift
//  TextPoster
//
//  Created by Logan Wright on 4/11/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

class TPNetworking: NSObject {
    
    class func getPosts(completion: (posts: [TPPost]?, error: NSError?) -> ()) {
        let ep = TPContentEndpoint()
        ep.getWithCompletion { (posts, error) -> Void in
            // Returned as [AnyObject]
            completion(posts: posts as? [TPPost], error: error)
        }
    }
    
    class func getPostWithId(id: Int, completion: (post: TPPost?, error: NSError?) -> ()) {
        let ep = TPContentEndpoint(slug: ["id" : id])
        ep.getWithCompletion { (post, error) -> Void in
            // Returned as AnyObject
            completion(post: post as? TPPost, error: error)
        }
    }
    
    class func createPostWithTitle(title: String, body: String, completion: (post: TPPost?, error: NSError?) -> ()) {
        let postParams = [
            "post" : [
                "title" : title,
                "body" : body
            ]
        ]
        let ep = TPContentEndpoint(parameters: postParams)
        ep.postWithCompletion { (post, error) -> Void in
            // Returned as AnyObject
            completion(post: post as? TPPost, error: error)
        }
    }
    
    class func patchPostWIthId(id: Int, newTitle: String? = nil, newBody: String? = nil, completion: (post: TPPost?, error: NSError?) -> ()) {
        var post: [String : String] = [:]
        if let title = newTitle {
            post["title"] = title
        }
        if let body = newBody {
            post["body"] = body
        }
        
        let postParams = [
            "post" : post
        ]
        
        let ep = TPContentEndpoint(slug: ["id" : id], andParameters: postParams)
        ep.patchWithCompletion { (post, error) -> Void in
            // Returned as AnyObject
            completion(post: post as? TPPost, error: error)
        }
    }
    
    
    class func deletePostWIthId(id: Int, completion: (post: TPPost?, error: NSError?) -> ()) {
        let ep = TPContentEndpoint(slug: ["id" : id])
        ep.deleteWithCompletion { (post, error) -> Void in
            // Returned as AnyObject
            completion(post: post as? TPPost, error: error)
        }
    }
}
