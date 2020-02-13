//
//  MonthMiniDayCell.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/13.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class MonthMiniDayCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = ""

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
}
