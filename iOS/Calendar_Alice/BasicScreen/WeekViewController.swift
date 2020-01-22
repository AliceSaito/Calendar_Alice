//
//  WeekViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2019/12/18.
//  Copyright © 2019 斉藤 アリス. All rights reserved.
//

/// 下記はDateComponentsの練習用コード
// class WeekViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        // Dateオブジェクトを操作するクラス
//        let calendar = Calendar(identifier: .gregorian)
//        // 今月の１日
//        let thisMonthDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0))
//        //来月の１日
//        let nextMonthDate = calendar.date(byAdding: DateComponents(month:1), to: thisMonthDate!)
//
//        //今月の最後の日
//        let thisMonthLastDate = calendar.date(byAdding: DateComponents(day:-1), to: nextMonthDate!)
//
//        //曜日を出す。
//        let thisMonthFirstWeekDay = calendar.component(.weekday, from: thisMonthDate!)
//
//        //前月の最後の週を知りたいので、今月の１日を引くために−１。
//        let firstDate = calendar.date(byAdding: DateComponents(day: -1 * (thisMonthFirstWeekDay - 1)), to: thisMonthDate!)
//
//
//         let thisMonthLastWeekDay = calendar.component(.weekday, from: thisMonthLastDate!)
//
//        //今月のカレンダーの最後の日がわかる
//        let lastDate = calendar.date(byAdding: DateComponents(day:  (7-thisMonthLastWeekDay)), to: thisMonthDate!)
//
//        let formatter = DateFormatter()
//               formatter.locale = Locale(identifier: "ja")
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//
//        let dateString = formatter.string(from: firstDate!)
//        print(dateString)
//
//        let thisMonthDateString = formatter.string(from: thisMonthDate!)
//               print(thisMonthDateString)
//
//        let nextMonthDateString = formatter.string(from: nextMonthDate!)
//                      print(nextMonthDateString)
//
//    }

import UIKit

let monthArr: [(year: Int, month: Int)] = {
    // 200年間(年、Month)のカレンダー
    var temp = [(Int, Int)]()
    (1900 ..< 2100).forEach { year in
        // １年は12ヶ月
        (1 ..< 13).forEach { month in
            temp.append((year, month))
        }
    }
    return temp
}()

// $0はクロージャー。Arrayで使う時は全ての要素にアクセスするという意味。
func groupForYearArr() -> [Int] {
    return (1900 ..< 2100).map({ $0 })
}


struct MonthInfo {
    var year: Int
    var month: Int
    var day:Int?
}
func getMonthDays(monthInfo:(year: Int, month: Int)) -> [(year: Int, month: Int, day: Int)?] {



// getMonthDaysをタプルで書くと下記の通り。略式はfunc getMonthDays(monthInfo: (Int,Int))。
//func getMonthDays(monthInfo:(year: Int, month: Int)) -> [(year: Int, month: Int, day: Int)?] {

    // Calendarは、アップルが提供しているFramework。
    let calendar = Calendar.current

// タプルで書くと下記の通り。
    var dates: [(year: Int, month: Int, day: Int)?] = []


    let dateComponents = DateComponents(calendar: calendar, year: monthInfo.year, month: monthInfo.month, day: 1)
    let composedDate = calendar.date(from: dateComponents)

    guard let startDay = composedDate else { return [] }

    let component = calendar.component(.weekday, from: startDay)
    let weekday = component - 1

    (0 ..< weekday).forEach { _ in
        dates.append(nil)
    }

    let totalDays = calendar.range(of: .day, in: .month, for: startDay)?.count ?? 0
    (1 ..< totalDays + 1).forEach { day in
        dates.append((monthInfo.year, monthInfo.month, day))
    }

    return dates
}

class MonthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!

    private let calendar = Calendar.current
    private let rightNow = Date()
    private let today: (year: Int, month: Int, day: Int)? = {
        let today = Date()
        let yearInterval = Calendar.current.dateInterval(of: .year, for: today)!
        let monthInterval = Calendar.current.dateInterval(of: .month, for: today)!
        let dayInterval = Calendar.current.dateInterval(of: .day, for: today)!

        guard let year = Calendar.current.dateComponents([.year], from: yearInterval.start).year,
            let month = Calendar.current.dateComponents([.month], from: monthInterval.start).month,
            let day = Calendar.current.dateComponents([.day], from: dayInterval.start).day
        else {
            return nil
        }

        return (year, month, day)
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scrollToDate()
    }

    private func scrollToDate(date: Date = Date()) {
        let yearInterval = calendar.dateInterval(of: .year, for: date)!
        let monthInterval = calendar.dateInterval(of: .month, for: date)!
        guard let year = calendar.dateComponents([.year], from: yearInterval.start).year,
            let month = calendar.dateComponents([.month], from: monthInterval.start).month
        else { return }

        let yearMonth = (year, month)

        for (section, value) in monthArr.enumerated() {
            if yearMonth == value {
                let indexPath = IndexPath(row: 0, section: section)
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
                return
            }
        }
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
