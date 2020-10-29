//
//  InfoViewController.swift
//  Testing App
//
//  Created by Lee Yik Kong on 29/10/2020.
//

import UIKit

class InfoViewController: UIViewController {
    
    internal var selectedId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://jsonplaceholder.typicode.com/posts/{post_id}".replacingOccurrences(of: "{post_id}", with: "\(selectedId)")
        MyUtility.loadAllPostUrl(url: url) { (callbackObject: Any?) in
            self.handleJsonObject(json: callbackObject)
        }
    }
    

    private func handleJsonObject(json: Any?) {
        if let object = json as? [String: Any] {
            print(object)
        }
    }

}
