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
    
    @IBOutlet weak var noteListTableView: UITableView!
    @IBOutlet weak var yearMonthLabel: UILabel!
    //渡された日付情報
    var selectedItem: MonthInfo!
    var selectedDate: Date!
    var noteList: [Note] = []
    var days: [[MonthInfo?]] = []
 
    //日表示のtableViewにスケジュールのタイトルを表示する
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noteList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let note = noteList[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "todayScheduleCell")
        cell.textLabel?.text = note.title
        //note.titleはAddSheduleViewController.swiftに定義したtitleTextField.textのこと。
        
        return cell
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //日表示ではnilが入っている日付を表示させないように、filteringした。
        //        days = getMonthDays(monthInfo: self.selectedItem).filter({ (monthinfo) -> Bool in
        //            return monthinfo != nil
        //        })
        //        print("✋", selectedItem.day)
        
        //日表示画面のカレンダーを表示するためのデータを作る
        for i in (1900...2100){
            for j in (1...12) {
                let m : MonthInfo = MonthInfo(year: i, month: j, day: nil)
                days.append(getMonthDays(monthInfo: m))
            }
        }

        
        //年/月を表示
        self.yearMonthLabel.text = "\(selectedItem.year)/\(selectedItem.month)"
        //スケジュールを読み込む
        noteList = fetchNote()
        //スケジュールをリロードして表示
        noteListTableView.reloadData()
    }
    
   //fetchは読み込むってこと。
    func fetchNote() ->  [Note]  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        //DataController.swiftに書いたものを呼び出している。fetchNotesAllDate
        //        let fetched = appDelegate.dataController.fetchNotesAllDate()
        //        fetched.forEach {
        //            let note = $0
        //            print("🥶",note.date)
        //        }
        
        //        日付を指定して[Note]から該当のデータを取得
        let fetchedDay: [Note] = appDelegate.dataController.fetchNotesWithDate(date: selectedDate)
        
        //それを表示
        //        fetchedDay.forEach {
        //            let note = $0
        //            print("⏰",note.date)
        //        }
        
        //$0の説明。forEachとセットで使う。順番に取得する。
        //        var hoge: [String] = ["a", "b", "c"]
        //        hoge.forEach { (ho) in
        //            print(ho)
        //        }
        //        hoge.forEach {
        //            print($0)
        //        }
        //        for ho in hoge {
        //            print(ho)
        //        }
        
        return fetchedDay
    }
    

    
    private func scrollToDate() {
        //        var selectedIndex: Int = 0
        //        for (index, day) in self.days.enumerated() {
        //            if let day = day {
        //                if self.selectedItem.year == day.year,
        //                    self.selectedItem.month == day.month,
        //                    self.selectedItem.day == day.day {
        //                    selectedIndex = index
        //                    break
        //                }
        //            }
        //        }
                

        //選んだ日付を表示させる処理
        let indexPath = IndexPath(item: selectedItem.day!, section: (selectedItem.year - 1900) * 12 + selectedItem.month - 1)
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //200年分の月の数
        print("🐜", days.count)
        return days.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        print("🌼", days[section].count)
        return days[section].count
    }
    //checkはcollection viewのidentifier
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = checkcollectionview.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath) as! ScrollDayCollectionViewCell
        
        cell.contentView.backgroundColor = .clear
        
        //あるcellにあるデータを詰める
        if let monthInfoCellData = days[indexPath.item][indexPath.item] {
            cell.setData(dayOfWeek: monthInfoCellData)
            //選んだ日(selectedItem)と一致する日付をyellowにする処理
            if monthInfoCellData.year == selectedItem.year && monthInfoCellData.month == selectedItem.month && monthInfoCellData.day == selectedItem.day{
                cell.contentView.backgroundColor = .yellow
            }
            
        }
        
        return cell
    }
    
    //新たに日付をタップしたら、黄色をそっちに移動させる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = days[indexPath.item][indexPath.item]
        collectionView.reloadData()
        
        //selectedItemからselectedDateに型を変換
        let dateComponents = DateComponents(calendar:Calendar.current, year: selectedItem.year, month: selectedItem.month, day: selectedItem.day)
        self.selectedDate = dateComponents.date
        //再読み込みしてスケジュールを更新
        noteList = fetchNote()
        noteListTableView.reloadData()
        
    }
    
    //DayViewControllerからsegueを使ってAddScheduleViewControllerにselectedDateのデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addScheduleViewController" {
            let vc = segue.destination as! AddScheduleViewController
            vc.selectedDate = self.selectedDate
            vc.delegate = self
            vc.savedClosure = {
                //この中にAddSheduleでやりたいことを書く。必ずselfをつける。
                //スケジュールを読み込む
                self.noteList = self.fetchNote()
                //スケジュールをリロードして表示
                self.noteListTableView.reloadData()
            }
        }
    }
    
}
//上のvc.delegate = selfを書くためには下のコードが必要。新しいスケジュールを追加する処理。
extension DayViewController: AddScheduleViewControllerDelegate {
    func didSaveNewSchedule() {
        print("didSaveNewSchedule")
    }
}
