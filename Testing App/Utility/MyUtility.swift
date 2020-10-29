//
//  MyUtility.swift
//  Testing App
//
//  Created by Lee Yik Kong on 28/10/2020.
//

import UIKit

class MyUtility: NSObject {
    public static func checkStringJson(_ object: [String:Any],_ key: String) -> String{
        if let value = object[key] as? String{
            return value
        }
        
        return ""
    }
    
    public static func checkIntJson(_ object: [String:Any],_ key: String) -> Int{
        if let value = object[key] as? Int{
            return value
        }
        
        return 0
    }
    
    public static func checkJsonArray(_ object: [String:Any],_ key: String) -> Array<Dictionary<String, Any>>{
        if let objectList: Array<Dictionary<String, Any>> = object[key] as? Array<Dictionary<String, Any>> {
            return objectList
        }
        return Array<Dictionary<String, Any>>()
    }
    
    public static func loadAllPostUrl(url: String, completion: @escaping ((_ callBackObject: Any?) -> ())) {
        do {
            if let dataFile = URL(string: url) {
                let data = try Data(contentsOf: dataFile)
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                    completion(jsonArray)
                } else {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(jsonObject)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

public extension UIViewController {
    // MARK: Keyboard
    
    @objc func myAddKeyboardDisplayNotifications(scrollView: UIScrollView, delegate: MyKeyboardDelegate? = nil) {
        keyboardRelatedScrollView = scrollView
        myKeyboardDelegate = delegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Remove Notification.Name.UIKeyboardWillShow & Notification.Name.UIKeyboardWillHide
    @objc func myRemoveKeyboardDisplayNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        keyboardRelatedScrollView = nil
        keyboardRelatedScrollViewContentInset = nil
        keyboardRelatedScrollViewScrollIndicatorInsets = nil
        myKeyboardDelegate = nil
    }
    
    @objc func myHideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func myEnableToHideKeyboardByTappingBackgroundView(cancelsTouchesInView: Bool = true) {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(UIViewController.myHideKeyboard))
        tapGR.cancelsTouchesInView = cancelsTouchesInView
        self.view.addGestureRecognizer(tapGR)
    }
    
    private static var keyboardRelatedScrollViewList = [String : UIScrollView]()
    private static var keyboardRelatedScrollViewContentInsetList = [String : UIEdgeInsets]()
    private static var keyboardRelatedScrollViewScrollIndicatorInsetsList = [String : UIEdgeInsets]()
    private static var keyboardDelegateList = [String : MyKeyboardDelegate]()
    
    private var keyboardRelatedScrollView: UIScrollView? {
        get {
            return UIViewController.keyboardRelatedScrollViewList[self.description]
        }
        set {
            if let newScrollView = newValue {
                UIViewController.keyboardRelatedScrollViewList.updateValue(newScrollView, forKey: self.description)
            }
            else {
                UIViewController.keyboardRelatedScrollViewList.removeValue(forKey: self.description)
            }
        }
    }
    
    private var keyboardRelatedScrollViewContentInset: UIEdgeInsets? {
        get {
            return UIViewController.keyboardRelatedScrollViewContentInsetList["\(self.description)_contentinset"]
        }
        set {
            if let newContentInset = newValue {
                UIViewController.keyboardRelatedScrollViewContentInsetList.updateValue(newContentInset, forKey: "\(self.description)_contentinset")
            }
            else {
                UIViewController.keyboardRelatedScrollViewContentInsetList.removeValue(forKey: "\(self.description)_contentinset")
            }
        }
    }
    
    private var keyboardRelatedScrollViewScrollIndicatorInsets: UIEdgeInsets? {
        get {
            return UIViewController.keyboardRelatedScrollViewScrollIndicatorInsetsList["\(self.description)_scrollindicatorinsets"]
        }
        set {
            if let newScrollIndicatorInsets = newValue {
                UIViewController.keyboardRelatedScrollViewScrollIndicatorInsetsList.updateValue(newScrollIndicatorInsets, forKey: "\(self.description)_scrollindicatorinsets")
            }
            else {
                UIViewController.keyboardRelatedScrollViewScrollIndicatorInsetsList.removeValue(forKey: "\(self.description)_scrollindicatorinsets")
            }
        }
    }
    
    private var myKeyboardDelegate: MyKeyboardDelegate? {
        get {
            return UIViewController.keyboardDelegateList["\(self.description)_flkeyboarddelegate"]
        }
        set {
            if let newScrollIndicatorInsets = newValue {
                UIViewController.keyboardDelegateList.updateValue(newScrollIndicatorInsets, forKey: "\(self.description)_flkeyboarddelegate")
            }
            else {
                UIViewController.keyboardDelegateList.removeValue(forKey: "\(self.description)_flkeyboarddelegate")
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardInfo = notification.userInfo,
            let keyboardFrameCGRect = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if #available(iOS 11.0, *) {
                if let krScrollView = keyboardRelatedScrollView,
                    krScrollView.contentInsetAdjustmentBehavior == .never {
                    
                    if (keyboardRelatedScrollViewContentInset == nil) {
                        keyboardRelatedScrollViewContentInset = krScrollView.contentInset
                    }
                    
                    if (keyboardRelatedScrollViewScrollIndicatorInsets == nil) {
                        keyboardRelatedScrollViewScrollIndicatorInsets = krScrollView.scrollIndicatorInsets
                    }
                    
                    krScrollView.contentInset.bottom = keyboardRelatedScrollViewContentInset!.bottom + keyboardFrameCGRect.height
                    krScrollView.scrollIndicatorInsets.bottom = keyboardRelatedScrollViewScrollIndicatorInsets!.bottom + keyboardFrameCGRect.height
                }
                else {
                    let safeAreaInsetsBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
                    
                    if (keyboardRelatedScrollViewContentInset == nil) {
                        keyboardRelatedScrollViewContentInset = additionalSafeAreaInsets
                    }
                    
                    additionalSafeAreaInsets.bottom = keyboardRelatedScrollViewContentInset!.bottom + keyboardFrameCGRect.height - safeAreaInsetsBottom
                }
            } else { // below iOS 11.0
                if let krScrollView = keyboardRelatedScrollView {
                    if (keyboardRelatedScrollViewContentInset == nil) {
                        keyboardRelatedScrollViewContentInset = krScrollView.contentInset
                    }
                    
                    if (keyboardRelatedScrollViewScrollIndicatorInsets == nil) {
                        keyboardRelatedScrollViewScrollIndicatorInsets = krScrollView.scrollIndicatorInsets
                    }
                    
                    krScrollView.contentInset.bottom = keyboardRelatedScrollViewContentInset!.bottom + keyboardFrameCGRect.height
                    krScrollView.scrollIndicatorInsets.bottom = keyboardRelatedScrollViewScrollIndicatorInsets!.bottom + keyboardFrameCGRect.height
                }
            }
            
            if let krScrollView = keyboardRelatedScrollView {
                myKeyboardDelegate?.flKeyboardWillShow(keyboardEndFrame: keyboardFrameCGRect, scrollView: krScrollView)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let previousContentInset = keyboardRelatedScrollViewContentInset {
            if #available(iOS 11.0, *) {
                if let krScrollView = keyboardRelatedScrollView,
                    krScrollView.contentInsetAdjustmentBehavior == .never {
                    krScrollView.contentInset = previousContentInset
                    
                    if let previousScrollIndicatorInsets = keyboardRelatedScrollViewScrollIndicatorInsets {
                        krScrollView.scrollIndicatorInsets = previousScrollIndicatorInsets
                    }
                }
                else {
                    additionalSafeAreaInsets = previousContentInset
                }
            } else { // below iOS 11.0
                if let krScrollView = keyboardRelatedScrollView {
                    krScrollView.contentInset = previousContentInset
                    
                    if let previousScrollIndicatorInsets = keyboardRelatedScrollViewScrollIndicatorInsets {
                        krScrollView.scrollIndicatorInsets = previousScrollIndicatorInsets
                    }
                }
            }
            
            keyboardRelatedScrollViewContentInset = nil
        }
        
        if let krScrollView = keyboardRelatedScrollView,
            let keyboardInfo: [AnyHashable : Any] = notification.userInfo,
            let keyboardFrameCGRect = (keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            myKeyboardDelegate?.flKeyboardWillHide(keyboardEndFrame: keyboardFrameCGRect, scrollView: krScrollView)
        }
    }
}

@objc public protocol MyKeyboardDelegate {
    func flKeyboardWillShow(keyboardEndFrame: CGRect, scrollView: UIScrollView)
    func flKeyboardWillHide(keyboardEndFrame: CGRect, scrollView: UIScrollView)
}
