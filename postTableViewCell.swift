//
//  postTableViewCell.swift
//  UniTrade
//
//  Created by John Cui on 12/5/15.
//  Copyright © 2015 Sheng Zhang. All rights reserved.
//
import UIKit
import Parse
import ParseUI
import Bolts

class postTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagedis: PFImageView!
    @IBOutlet weak var titlename: UILabel!
    @IBOutlet weak var des: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
