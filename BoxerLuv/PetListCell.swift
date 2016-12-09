//
//  PetListCell.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/8/16.
//  Copyright © 2016 NEA. All rights reserved.
//

import Foundation
import UIKit

class PetListCell: UITableViewCell {
    
    @IBOutlet var animalImage: UIImageView!
    @IBOutlet var animalName: UILabel!
    @IBOutlet var animalAge: UILabel!
    @IBOutlet var animalBreed: UILabel!
    @IBOutlet var animalSex: UILabel!
    @IBOutlet var animalColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
