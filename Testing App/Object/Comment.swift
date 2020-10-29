//
//  Comment.swift
//  Testing App
//
//  Created by Lee Yik Kong on 28/10/2020.
//

import UIKit

struct Comment {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var postId: Int
    var name: String
    var email: String
    
    init(userId: Int, id: Int, title: String, body: String){
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.postId = -1
        self.name = ""
        self.email = ""
    }
    
    init(postId: Int, id: Int, name: String, email: String, body: String){
        self.userId = -1
        self.id = id
        self.title = ""
        self.body = body
        self.postId = postId
        self.name = name
        self.email = email
    }
}
