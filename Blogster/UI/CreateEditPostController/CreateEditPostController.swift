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
        titleTextField.text = createEditModel.textFieldText
    }
    
    func setupTextView() {
        bodyTextView.shouldResize = false
    }
    
    func setupNavigationBar() {
        title = createEditModel.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonPressed:")
    }
    
    private func setupKeyboardListeners() {
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        defaultCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Button Presses
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        println("Save")
        bodyTextView.resignFirstResponder()
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
