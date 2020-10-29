//
//  ViewController.swift
//  Testing App
//
//  Created by Lee Yik Kong on 28/10/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var itemTV: UITableView!
    
    private var commentList = [Comment]()
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        callLoadAllPostUrl()
    }
    
    // MARK: - Setup View
    private func setupView(){
        itemTV.delegate = self
        itemTV.dataSource = self
        itemTV.rowHeight = UITableView.automaticDimension
        itemTV.separatorStyle = .none
    }
    
    // MARK: - Call API
    private func callLoadAllPostUrl() {
        MyUtility.loadAllPostUrl(url: "https://jsonplaceholder.typicode.com/posts") { (callbackObject: Any?) in
            self.handleJsonObject(jsonList: callbackObject)
        }
    }
    
    private func handleJsonObject(jsonList: Any?){
        if let object = jsonList as? [Any] {
            for item in object as! [[String:Any]] {
                let userId = MyUtility.checkIntJson(item, "userId")
                let id = MyUtility.checkIntJson(item, "userId")
                let title = MyUtility.checkStringJson(item, "title")
                let body = MyUtility.checkStringJson(item, "body")
                
                commentList.append(Comment.init(userId: userId, id: id, title: title, body: body))
            }
        }
        itemTV.reloadData()
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "page1ToPage2":
            if let viewController = segue.destination as? InfoViewController, let selectedId = sender as? Int {
                viewController.selectedId = selectedId + 1
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt -> \(indexPath.row)")
        self.performSegue(withIdentifier: "page1ToPage2", sender: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell {
            cell.selectionStyle = .none
            cell.initCell(item: commentList[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
}

