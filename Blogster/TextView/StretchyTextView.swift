//
//  StretchyTextView.swift
//  TextPoster
//
//  Created by Logan Wright on 5/7/15.
//  Copyright (c) 2015 lowriDevs. All rights reserved.
//

import UIKit

@objc protocol StretchyTextViewDelegate {
    func stretchyTextViewDidChangeSize(chatInput: StretchyTextView)
    optional func stretchyTextView(textView: StretchyTextView, validityDidChange isValid: Bool)
}

class StretchyTextView : UITextView, UITextViewDelegate {
    
    // MARK: Delegate
    
    weak var stretchyTextViewDelegate: StretchyTextViewDelegate?
    
    // MARK: Public Properties
    
    var maxHeightPortrait: CGFloat = 160
    var maxHeightLandScape: CGFloat = 60
    var maxHeight: CGFloat {
        get {
            return UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ? maxHeightPortrait : maxHeightLandScape
        }
    }
    
    var minHeightPortrait: CGFloat = 20
    var minHeightLandScape: CGFloat = 20
    var minHeight: CGFloat {
        get {
            return UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ? minHeightPortrait : minHeightLandScape
        }
    }
    
    var shouldResize = true
    var shouldAlign = true
    
    // MARK: Private Properties
    
    private var maxSize: CGSize {
        get {
            return CGSize(width: CGRectGetWidth(self.bounds), height: self.maxHeightPortrait)
        }
    }
    
    private var _isValid = false
    private var isValid: Bool {
        get {
            return _isValid
        }
        set {
            if _isValid != newValue {
                _isValid = newValue
                self.stretchyTextViewDelegate?.stretchyTextView?(self, validityDidChange: _isValid)
            }
        }
    }
    
    private let sizingTextView = UITextView()
    
    // MARK: Property Overrides
    
    override var contentSize: CGSize {
        didSet {
            self.resizeAndAlign()
        }
    }
    
    override var font: UIFont! {
        didSet {
            sizingTextView.font = font
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            sizingTextView.textContainerInset = textContainerInset
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect = CGRectZero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer);
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Setup
    
    func setup() {
        self.font = UIFont.systemFontOfSize(17.0)
        self.textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.delegate = self
    }
    
    // MARK: Resize & Align
    
    func resizeAndAlign() {
        if shouldResize {
            self.resize()
        }
        if shouldAlign {
            self.align()
        }
    }
    
    // MARK: Sizing
    
    func resize() {
        self.bounds.size.height = self.targetHeight()
        self.stretchyTextViewDelegate?.stretchyTextViewDidChangeSize(self)
    }
    
    func targetHeight() -> CGFloat {
        
        /*
        There is an issue when calling `sizeThatFits` on self that results in really weird drawing issues with aligning line breaks ("\n").  For that reason, we have a textView whose job it is to size the textView. It's excess, but apparently necessary.  If there's been an update to the system and this is no longer necessary, or if you find a better solution. Please remove it and submit a pull request as I'd rather not have it.
        */
        
        sizingTextView.text = self.text
        let targetSize = sizingTextView.sizeThatFits(maxSize)
        var targetHeight = targetSize.height
        let maxHeight = self.maxHeight
        let minHeight = self.minHeight
        if targetHeight > maxHeight {
            targetHeight = maxHeight
        } else if targetHeight < minHeight {
            targetHeight = minHeight
        }
        return targetHeight
    }
    
    // MARK: Alignment
    
    func align() {
        
        let caretRect: CGRect = self.caretRectForPosition(self.selectedTextRange?.end)
        
        let topOfLine = CGRectGetMinY(caretRect)
        let bottomOfLine = CGRectGetMaxY(caretRect)
        
        let contentOffsetTop = self.contentOffset.y
        let bottomOfVisibleTextArea = contentOffsetTop + CGRectGetHeight(self.bounds)
        
        /*
        If the caretHeight and the inset padding is greater than the total bounds then we are on the first line and aligning will cause bouncing.
        */
        
        let caretHeightPlusInsets = CGRectGetHeight(caretRect) + self.textContainerInset.top + self.textContainerInset.bottom
        if caretHeightPlusInsets < CGRectGetHeight(self.bounds) {
            var overflow: CGFloat = 0.0
            if topOfLine < contentOffsetTop + self.textContainerInset.top {
                overflow = topOfLine - contentOffsetTop - self.textContainerInset.top
            } else if bottomOfLine > bottomOfVisibleTextArea - self.textContainerInset.bottom {
                overflow = (bottomOfLine - bottomOfVisibleTextArea) + self.textContainerInset.bottom
            }
            self.contentOffset.y += overflow
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChangeSelection(textView: UITextView) {
        self.align()
    }
    
    func textViewDidChange(textView: UITextView) {
        
        // TODO: Possibly filter spaces and newlines
        
        self.isValid = count(textView.text) > 0
    }
}