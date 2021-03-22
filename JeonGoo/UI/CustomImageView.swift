//
//  CustomImageView.swift
//  JeonGoo
//
//  Created by 이명직 on 2021/03/22.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 10
        
    }
}
