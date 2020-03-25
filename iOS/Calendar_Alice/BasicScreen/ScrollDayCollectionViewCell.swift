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
    
    //MonthInfoをパラメータとして受け取って、それを利用してnumberラベルとdayOfWeekLabelに日付と曜日を反映させるためのfunc
    func setData(dayOfWeek:MonthInfo){
        
        //dayOfWeek.dayをStringで変換したいがdayはOptionalなのでOptinal bindingで値をチェック
        if let value = dayOfWeek.day {
          
        //valueはIntのため、Stringで変換。ラベルの中にはStringしか入れられない。
            let dayStr = String(value)
            //valueラベルに変換した日付を代入する
            self.number.text = dayStr
        } else {
            self.number.text = ""
        }
  

        var scrollWeekdayDateComponents = DateComponents()
        scrollWeekdayDateComponents.year = dayOfWeek.year
        scrollWeekdayDateComponents.month = dayOfWeek.month
        scrollWeekdayDateComponents.day = dayOfWeek.day!
        
        scrollWeekdayDateComponents.weekday = Calendar.current.weekday
      
        let scrollWeekday = Calendar.current.weekday(from: scrollWeekdayDateComponents)
       
        
    }
    
    
    
}
