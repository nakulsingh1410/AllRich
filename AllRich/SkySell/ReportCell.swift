//
//  ReportCell.swift
//  SkySell
//
//  Created by DW02 on 6/27/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {

    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var viLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
