//
//  ItemCommentTableViewCell.swift
//  Testing App
//
//  Created by Lee Yik Kong on 29/10/2020.
//

import UIKit

class ItemCommentTableViewCell: UITableViewCell {

    
    @IBOutlet private weak var postIdLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        bgView.clipsToBounds = true
    }

    // MARK: - Init
    func initCell(item: Comment) {
        postIdLabel.text = "\(item.postId)"
        idLabel.text = "\(item.id)"
        nameLabel.text = item.name
        emailLabel.text = item.email
        bodyLabel.text = item.body
    }
}
