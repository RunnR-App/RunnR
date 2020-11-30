//
//  RunCell.swift
//  RunnR
//
//  Created by MaKayla Day on 11/30/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit

class RunCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
