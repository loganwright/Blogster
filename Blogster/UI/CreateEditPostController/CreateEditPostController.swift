//
//  CreateEditPostController.swift
//  Blogster
//
//  Created by Logan Wright on 5/7/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

class CreateEditPostController: UIViewController {

    // MARK: Initialization
    
    init() {
        super.init(nibName: "CreateEditPostController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brownColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
