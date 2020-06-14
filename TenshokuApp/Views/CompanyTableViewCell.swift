//
//  CompanyTableViewCell.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/14.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
