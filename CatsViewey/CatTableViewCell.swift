//
//  CatTableViewCell.swift
//  CatsViewey
//
//  Created by Andrii on 05.10.2021.
//

import UIKit

class CatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    
    var reuseForCancel: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseForCancel?()
        imageCell.image = nil
    }
    
}
