//
//  SelectCell.swift
//  I2SN
//
//  Created by 권준원 on 2021/02/04.
//

import UIKit

class SelectCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
        selectionStyle = .none
    }
    
}
