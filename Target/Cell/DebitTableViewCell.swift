//
//  DebitTableViewCell.swift
//  Target
//
//  Created by Sávio Dutra on 03/10/22.
//

import UIKit

class DebitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataDebit: UILabel!
    @IBOutlet weak var valueDebit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
