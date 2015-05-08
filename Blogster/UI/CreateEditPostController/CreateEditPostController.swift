//
//  CreateEditPostController.swift
//  Blogster
//
//  Created by Logan Wright on 5/7/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

private let CreateEditPostControllerBottomConstraintOffset: CGFloat = 8

class CreateEditPostController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: StretchyTextView!
    @IBOutlet weak var bodyTextViewBottomConstraint: NSLayoutConstraint!
    
    var createEditModel: CreateEditPostControllerModel
    
    // MARK: Initialization
    
    init(post: TPPost? = nil) {
        self.createEditModel = CreateEditPostControllerModel(post: post)
        super.init(nibName: "CreateEditPostController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Init w/ coder not implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        setupKeyboardListeners()
    }
    
    func setupTitleField() {
        if createEditModel.isEditing {
            titleTextField.text = createEditModel.textFieldText
        } else {
            titleTextField.placeholder = createEditModel.textFieldText
        }
    }
    
    func setupTextView() {
        bodyTextView.shouldResize = false
        bodyTextView.text = createEditModel.textViewText
    }
    
    func setupNavigationBar() {
        title = createEditModel.navigationTitle
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
        if createEditModel.isEditing {
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteButtonPressed:")
            navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        } else {
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    private func setupKeyboardListeners() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        defaultCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Button Presses
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        if count(titleTextField.text) == 0 || count(bodyTextView.text) == 0 {
            return
        }
        createEditModel.savePostWithTitle(titleTextField.text, body: bodyTextView.text) { [weak self] (success) -> () in
            if success {
                self?.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    func deleteButtonPressed(sender: UIBarButtonItem) {
        createEditModel.deletePost() { [weak self] (success) -> () in
            if success {
                self?.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    // MARK: Keyboard Listeners
    
    func keyboardWillShow(note: NSNotification) {
        let animationDetail = note.keyboardAnimationDetail
        bodyTextViewBottomConstraint.constant = animationDetail.height + CreateEditPostControllerBottomConstraintOffset
        UIView.animateWithDuration(
            animationDetail.duration,
            delay: 0.0,
            options: animationDetail.animationOptions,
            animations: { [weak self] () -> Void in
                self?.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func keyboardWillHide(note: NSNotification) {
        let animationDetail = note.keyboardAnimationDetail
        self.bodyTextViewBottomConstraint.constant = CreateEditPostControllerBottomConstraintOffset
        UIView.animateWithDuration(
            animationDetail.duration,
            delay: 0.0,
            options: animationDetail.animationOptions,
            animations: { [weak self] () -> Void in
                self?.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
}

class CreateEditPostControllerModel {
    private(set) var post: TPPost?
    
    var isEditing: Bool {
        return post != nil
    }
    
    var navigationTitle: String {
        return isEditing ? "Edit Post" : "New Post"
    }
    
    var textFieldText: String {
        return post?.title ?? "Enter Title Here"
    }
    
    var textViewText: String? {
        return post?.body
    }
    
    // MARK: Initialization
    
    init(post: TPPost?) {
        self.post = post
    }
    
    // MARK: Networking
    
    func savePostWithTitle(title: String, body: String, completion: (success: Bool) -> ()) {
        let responseHandler = { (post: TPPost?, error: NSError?) -> () in
            completion(success: error == nil)
        }
        if let _post = post {
            TPNetworking.patchPostWIthId(_post.id, newTitle: title, newBody: body, completion: responseHandler)
        } else {
            TPNetworking.createPostWithTitle(title, body: body, completion: responseHandler)
        }
    }
    
    func deletePost(completion: (success: Bool) -> ()) {
        if let _post = post {
            TPNetworking.deletePostWIthId(_post.id) { (post, error) -> () in
                completion(success: error == nil)
            }
        } else {
            completion(success: false)
        }
    }
}

struct KeyboardAnimationDetail {
    var duration: NSTimeInterval
    var curve: UInt
    var height: CGFloat
    
    var animationOptions: UIViewAnimationOptions {
        return UIViewAnimationOptions(curve)
    }
}

extension NSNotification {
    var keyboardAnimationDetail: KeyboardAnimationDetail {
        let keyboardAnimationDetail = userInfo!
        let duration = keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let keyboardFrame = (keyboardAnimationDetail[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let animationCurve = keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let keyboardHeight = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ? CGRectGetHeight(keyboardFrame) : CGRectGetWidth(keyboardFrame)
        return KeyboardAnimationDetail(duration: duration, curve: animationCurve, height: keyboardHeight)
    }
}
