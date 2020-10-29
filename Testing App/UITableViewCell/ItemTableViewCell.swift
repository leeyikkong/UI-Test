//
//  itemTableViewCell.swift
//  Testing App
//
//  Created by Lee Yik Kong on 28/10/2020.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 5
        // Initialization code
    }
    
    // MARK: - Init
    func initCell(item: Comment) {
        userIdLabel.text = String(item.userId)
        idLabel.text = String(item.id)
        titleLabel.text = item.title
        bodyLabel.text = item.body
    }

}
