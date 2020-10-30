//
//  InfoViewController.swift
//  Testing App
//
//  Created by Lee Yik Kong on 29/10/2020.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recordsLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var filterSearchBar: UISearchBar!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTableViewHeight: NSLayoutConstraint!
    
    internal var selectedId: Int = 0
    private var originalCommentDtlList = [Comment]()
    private var filteredCommentDtlList = [Comment]()

    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        callPostUrlMethod()
        callCommentUrlMethod()
    }
    
    deinit {
        commentTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableView = object as? UITableView, tableView == commentTableView, keyPath == "contentSize" {
            tableView.layoutIfNeeded()
            commentTableViewHeight.constant = tableView.contentSize.height
        }
    }
    
    // MARK: - Setup View
    private func setupView(){
        myAddKeyboardDisplayNotifications(scrollView: scrollView)
        myEnableToHideKeyboardByTappingBackgroundView()
        
        bgView.layer.cornerRadius = 5
        filterSearchBar.delegate = self
        
        commentTableView.dataSource = self
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.separatorStyle = .none
        commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // MARK: - Call API
    private func callPostUrlMethod() {
        let url = "https://jsonplaceholder.typicode.com/posts/{post_id}".replacingOccurrences(of: "{post_id}", with: "\(selectedId)")
        MyUtility.loadAllPostUrl(url: url) { (callbackObject: Any?) in
            self.handleJsonObject(json: callbackObject)
        }
    }
    
    private func callCommentUrlMethod() {
        let url = "https://jsonplaceholder.typicode.com/comments?postId=\(selectedId)"
        MyUtility.loadAllPostUrl(url: url) { (callbackObject: Any?) in
            self.handleJsonArray(jsonArray: callbackObject)
        }
    }
    
    private func handleJsonObject(json: Any?) {
        if let object = json as? [String: Any] {
            let userId = MyUtility.checkIntJson(object, "userId")
            let id = MyUtility.checkIntJson(object, "userId")
            let title = MyUtility.checkStringJson(object, "title")
            let body = MyUtility.checkStringJson(object, "body")
            
            userIdLabel.text = "\(userId)"
            idLabel.text = "\(id)"
            titleLabel.text = title
            bodyLabel.text = body
        }
    }
    
    private func handleJsonArray(jsonArray: Any?) {
        if let object = jsonArray as? [Any] {
            for item in object as! [[String:Any]] {
                let postId = MyUtility.checkIntJson(item, "postId")
                let id = MyUtility.checkIntJson(item, "id")
                let name = MyUtility.checkStringJson(item, "name")
                let email = MyUtility.checkStringJson(item, "email")
                let body = MyUtility.checkStringJson(item, "body")
                
                originalCommentDtlList.append(Comment.init(postId: postId, id: id, name: name, email: email, body: body))
            }
        }
        filteredCommentDtlList = originalCommentDtlList
        commentTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recordsLabel.text = "(\(filteredCommentDtlList.count))"
        return filteredCommentDtlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCommentTableViewCell", for: indexPath) as? ItemCommentTableViewCell {
            cell.selectionStyle = .none
            cell.initCell(item: filteredCommentDtlList[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UISearchBarDelegate
extension InfoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            filteredCommentDtlList.removeAll()
            for item in originalCommentDtlList {
                if item.matches(query: searchText) {
                    filteredCommentDtlList.append(item)
                }
            }
            
            commentTableView.reloadData()
        } else {
            filteredCommentDtlList = originalCommentDtlList
            commentTableView.reloadData()
        }
    }
}
