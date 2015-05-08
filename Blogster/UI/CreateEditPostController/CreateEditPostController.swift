//
//  CreateEditPostController.swift
//  Blogster
//
//  Created by Logan Wright on 5/7/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

class CreateEditPostController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: StretchyTextView!
    
    var createEditModel: CreateEditPostControllerModel
    
    // MARK: Initialization
    
    init(post: TPPost? = nil) {
        self.createEditModel = CreateEditPostControllerModel(post: post)
        super.init(nibName: "CreateEditPostController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Init w/ coder not implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = UIColor.brownColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    
    func setup() {
        setupTextView()
        setupTitleField()
        setupNavigationBar()
    }
    
    func setupTitleField() {
        titleTextField.text = createEditModel.textFieldText
    }
    
    func setupTextView() {
        bodyTextView.shouldResize = false
    }
    
    func setupNavigationBar() {
        title = createEditModel.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    }
    
    // MARK: Button Presses
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        println("Save")
    }
}

class CreateEditPostControllerModel {
    private(set) var post: TPPost?
    
    var navigationTitle: String {
        return post?.title ?? "New Post"
    }
    
    var textFieldText: String {
        return post?.title ?? "Enter Title Here"
    }
    
    // MARK: Initialization
    
    init(post: TPPost?) {
        self.post = post
    }
}
