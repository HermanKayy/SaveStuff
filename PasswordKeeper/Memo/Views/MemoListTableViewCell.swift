//
//  MemoListTableViewCell.swift
//  PasswordKeeper
//
//  Created by Herman Kwan on 6/29/18.
//  Copyright © 2018 Herman Kwan. All rights reserved.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    
    var memo: Memo?
    
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var colorLabel: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellContainerView.layer.masksToBounds = false
        cellContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellContainerView.layer.shadowRadius = 2
        cellContainerView.layer.shadowColor = UIColor.black.cgColor
        cellContainerView.layer.shadowOpacity = 0.6
        
        setupViews()
    }
    
    func setupViews() {
        guard let memo = memo, let color = memo.color else { return }
        titleLabel.text = memo.title
        colorLabel.backgroundColor = UIColor(named: color)
    }
}
