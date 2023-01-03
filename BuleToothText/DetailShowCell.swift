//
//  DetailShowCell.swift
//  BuleToothText
//
//  Created by cw on 2022/12/7.
//  Copyright © 2022 TRY. All rights reserved.
//

import UIKit

class DetailShowCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var iconImageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ type: PeripheralType) {
        titleLbl.text = type.title
        contentLbl.text = type.content
        iconImageV.image = type.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
