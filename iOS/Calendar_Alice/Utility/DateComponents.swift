//
//  CalendarCountBase.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2020/01/10.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class CalendarCountBase: NSObject {
    static func youbi(year:Int, month:Int, day:Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date) - 1 // 0 - 6
    }
    
    static func dayNumOfMonth(year:Int, month:Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
 
}
