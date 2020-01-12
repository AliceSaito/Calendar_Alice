//
//  WeekViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2019/12/18.
//  Copyright © 2019 斉藤 アリス. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Dateオブジェクトを操作するクラス
        let calendar = Calendar(identifier: .gregorian)
        // 今月の１日
        let thisMonthDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0))
        //来月の１日
        let nextMonthDate = calendar.date(byAdding: DateComponents(month:1), to: thisMonthDate!)
        
        //今月の最後の日
        let thisMonthLastDate = calendar.date(byAdding: DateComponents(day:-1), to: nextMonthDate!)
        
        //曜日を出す。
        let thisMonthFirstWeekDay = calendar.component(.weekday, from: thisMonthDate!)
        
        //前月の最後の週を知りたいので、今月の１日を引くために−１。
        let firstDate = calendar.date(byAdding: DateComponents(day: -1 * (thisMonthFirstWeekDay - 1)), to: thisMonthDate!)
        
        
         let thisMonthLastWeekDay = calendar.component(.weekday, from: thisMonthLastDate!)
        
        //今月のカレンダーの最後の日がわかる
        let lastDate = calendar.date(byAdding: DateComponents(day:  (7-thisMonthLastWeekDay)), to: thisMonthDate!)
        
        let formatter = DateFormatter()
               formatter.locale = Locale(identifier: "ja")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let dateString = formatter.string(from: firstDate!)
        print(dateString)
        
        let thisMonthDateString = formatter.string(from: thisMonthDate!)
               print(thisMonthDateString)
        
        let nextMonthDateString = formatter.string(from: nextMonthDate!)
                      print(nextMonthDateString)
        
       
    }


    // 月表示のカレンダーを２回繰り返し表示する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        ↓　items.countにしたら、itemsで書いたstringが表示される。文字でも数字でもOK。
//        return items.count
//        ↓ 0〜30までの数字を、順番に31個表示する。
        return 31
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCollectionViewCell", for: indexPath) as! WeekCollectionViewCell

//        cell.myLabel.text = items[indexPath.item]
        print(indexPath)
        // indexPathは、itemとsectionと一緒に使う。itemは月表示のカレンダー、sectionはその繰り返しの回数。
        cell.myLabel.text = "\(indexPath.section + 1)-\(indexPath.item + 1)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}
