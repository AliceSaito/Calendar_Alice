//
//  DayViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2020/01/10.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var checkcollectionview: UICollectionView!
    
    var selectedItem: MonthInfo!
    
    let list = ["Milk", "Water", "Soda", "Coffee"]
    
    var days: [MonthInfo?] = []
    //scrolltodateのために追加
    var thisDay: Int {
        
        let calendar = Calendar.current
        let monthInterval = calendar.dateInterval(of: .day, for: Date())!
        return calendar.dateComponents([.day], from: monthInterval.start).day!

    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(list.count)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "todayScheduleCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //日表示ではnilが入っている日付を表示させないように、filteringした。
        days = getMonthDays(monthInfo: self.selectedItem).filter({ (monthinfo) -> Bool in
            return monthinfo != nil
      
        })
        print("✋", selectedItem.day)

    }

    
    private func scrollToDate() {
        var selectedIndex: Int = 0
        for (index, day) in self.days.enumerated() {
            if let day = day {
                if self.selectedItem.year == day.year,
                    self.selectedItem.month == day.month,
                    self.selectedItem.day == day.day {
                    selectedIndex = index
                    break
                }
            }
        }

        let indexPath = IndexPath(item: selectedIndex, section: 0)
        self.checkcollectionview.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        self.checkcollectionview.alpha = 1.0
    }
    

//    private func scrollToDate(date: Date = Date()) {
//        let calendar = Calendar(identifier: .gregorian)
//
//        //dateの情報をdateIntervalで秒単位に変換する。→ それをdateComponentsでIntに変換して、今を表示する。
//        let yearInterval = calendar.dateInterval(of: .year, for: date)!
//        let monthInterval = calendar.dateInterval(of: .month, for: date)!
//        //Int?なのでguardでオプショナルバインディングをしている。
//        guard let year = calendar.dateComponents([.year], from: yearInterval.start).year,
//            let month = calendar.dateComponents([.month], from: monthInterval.start).month
//            else { return }
//
//        //for文で全ての月のデータが入っているArrayを回して、一致するデータを探す。
//        for (section, value) in WeekViewController.monthArr.enumerated() {
//            if year == value.year && month == value.month{
//
//                let indexPath = IndexPath.init(row: 0, section: section)
//
//                //該当の月のカレンダーが、常に画面の真ん中に現れるように設定。animatedは日付を検索した時に、falseだと直移動、trueだと高速スクロールで移動する。
//                checkcollectionview.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
//                return
//            }
//
//        }
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scrollToDate()
    }
    
  
}


extension DayViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return days.count
    }
    //checkはcollection viewのidentifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = checkcollectionview.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as! ScrollDayCollectionViewCell


        if let monthInfo = days[indexPath.item] {
            cell.setData(dayOfWeek: monthInfo)
        }
        return cell
        
    }

}

