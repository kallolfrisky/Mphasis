//
//  ISSPCell.swift
//  Mphasis_ISSP_Najmul
//
//  Created by Najmul Hasan on 11/30/17.
//  Copyright © 2017 Najmul Hasan. All rights reserved.
//

import UIKit

class ISSPCell: UITableViewCell {
    
    //Custom cell for further scalability
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var risetimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
