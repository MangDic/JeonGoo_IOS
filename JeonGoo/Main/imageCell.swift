//
//  imageCell.swift
//  JeonGoo
//
//  Created by 이명직 on 2021/03/05.
//

import UIKit

class imageCell: UICollectionViewCell {
    var isPicked = false
    var refuse : (() -> ()) = {}
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBAction func removeCell(_ sender: Any) {
        refuse()
    }
}
