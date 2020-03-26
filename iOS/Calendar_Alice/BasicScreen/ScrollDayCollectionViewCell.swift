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
        //下記のようなコードでデバックエリアにprintして、nilを見つける。
        print("😃",dayOfWeek.day!)
        
        let userCalendar = Calendar.current
        let someDateTime: Date? = userCalendar.date(from: scrollWeekdayDateComponents)
        guard let date = someDateTime else {
            //Bが入ったらnil。Bと書いておくと不具合を見つけやすい。
            self.dayOfWeekLabel.text = "B"
            return
        }
        
        let comps = Calendar.current.dateComponents([.weekday], from: date)
        
        let weekIndx = comps.weekday
        
        let weeks = ["S","M","T","W","T","F","S"]
        
        // =は代入。==はイコールの意。
        if weekIndx == 1 {
            dayOfWeekLabel.textColor = UIColor.red
        }
        else if weekIndx == 7 {
            dayOfWeekLabel.textColor = UIColor.blue
        } else {
            dayOfWeekLabel.textColor = UIColor.black
        }
        
        if let weekIndex = weekIndx {
            self.dayOfWeekLabel.text =  weeks[weekIndex - 1]
        } else {
            self.dayOfWeekLabel.text = "A"
        }
        
    }
    
}
