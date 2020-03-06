//
//  ScrollDayCollectionViewCell.swift
//  
//
//  Created by 斉藤アリス on 2020/02/28.
//

import UIKit

class ScrollDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    
    
    func setData(dayOfWeek:MonthInfo){
        
        if let dayOptinal = dayOfWeek.day {
          
            let str: String = String(dayOptinal)
            self.number.text = str
        }
    }
}
