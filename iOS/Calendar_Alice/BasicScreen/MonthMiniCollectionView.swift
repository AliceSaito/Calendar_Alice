//
//  MonthMiniCollectionView.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/13.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class MonthMiniCollectionView: UICollectionView {


//    @IBOutlet weak var titleLabel: UILabel! {
//        didSet {
//            self.titleLabel.text = year
//        }
//    }
    var year: String = ""
    var monthData: [(year: Int, month: Int, day: Int)?] = []

}

