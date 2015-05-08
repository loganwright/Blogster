//
//  CreateEditPostController.swift
//  Blogster
//
//  Created by Logan Wright on 5/7/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

class CreateEditPostController: UIViewController {

    private(set) var post: TPPost?
    
    // MARK: Initialization
    
    init(post: TPPost? = nil) {
        self.post = post
        super.init(nibName: "CreateEditPostController", bundle: nil)
        setup()
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
    
    // MARK: Setup
    
    func setup() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = post?.title ?? "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    }
    
    // MARK: Button Presses
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        println("Save")
    }
}
