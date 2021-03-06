//
//  swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2019/12/18.
//  Copyright © 2019 斉藤 アリス. All rights reserved.
//


import UIKit

//    プラスしたコード2月13日
func groupForYearArr() -> [Int] {
    return (1900..<2100).map({ $0 })
}

struct MonthInfo {
       var year: Int
       var month: Int
       var day:Int?
   }
   


//年と月のパラメータを入れると、その月の全ての日付がMonthInfo型で返される
   func getMonthDays(monthInfo:MonthInfo) -> [MonthInfo?] {
       
       // func getMonthDaysをタプルで書くと下記の通り。
       //略式はfunc getMonthDays(monthInfo: (Int,Int))。
       //func getMonthDays(monthInfo:(year: Int, month: Int)) -> [(year: Int, month: Int, day: Int)?] {
       
       // Calendarは、アップルが提供しているFramework。
       let calendar = Calendar.current
       
    //ある月の日付データ(MonthInfo型)を格納するための空のArrayを用意
       var dates: [MonthInfo?] = []
       //    上記を略さずに書くと下記の通り
       //    var dates: Array<MonthInfo?> = []
       // 上記をタプルで書くと下記の通り。
       //    var dates: [(year: Int, month: Int, day: Int)?] = []
       
       //パラメータMonthInfoはDate型ではないので、DateComponentsを利用してDate型に変換する準備をする
       let dateComponents = DateComponents(calendar: calendar, year: monthInfo.year, month: monthInfo.month, day: 1)
       
       //カレンダー形式に変換
       let startDay = calendar.date(from: dateComponents)!
       
       // !でunwrapをしない時はguardかifでOptional Binding
       // guard let startDay = composedDate else { return [] }
       //if let startDay = composedDate {}
       
       // 月の１日目の曜日を特定する。for文で回して１日より前のマスにnilを入れる。
       let component = calendar.component(Calendar.Component.weekday, from: startDay)
       let weekday = component - 1
       (0 ..< weekday).forEach { _ in
           dates.append(nil)
       }
       
       //CollectionViewのCell(7×5)に順番に数字を入れていく
       let totalDays = calendar.range(of: .day, in: .month, for: startDay)?.count ?? 0
       (1 ..< totalDays + 1).forEach { day in
           let data = MonthInfo.init(year: monthInfo.year, month: monthInfo.month, day: day)
           // data.year
           // print(data.year)
           dates.append(data)
       }
       return dates
       // nil, nil, nil, (2020, 1, 1), (2020, 1, 2), (2020, 1, 3), ...
   }


//UICollectionViewDelegateFlowLayoutは月カレンダー表示を一列７セルにするための設定。
class WeekViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {    //storyboardのCollectionViewとコードを繋げた。
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate: Date!
    var selectedItem: MonthInfo?
    
    // 200年間の(年、Month)データ。200 x 12 = 2400件の月データがこのmonthArr配列に入っている。
    //staticが付いていると、別のクラスでも、クラス名.monthArrで直接呼び出せる
    static let monthArr: [MonthInfo] = {
        
        // 200年間
        var temp = [MonthInfo]()
        (1900 ..< 2100).forEach { year in
            // １年は12ヶ月
            (1 ..< 13).forEach { month in
                let monthInfo = MonthInfo.init(year: year, month: month, day: nil)
                temp.append(monthInfo)
            }
        }
        return temp
    }()
    
    
    //★下記は年間カレンダーで使用する部分。あとで書く。
    // $0はクロージャー。Arrayで使う時は全ての要素にアクセスするという意味。
    //func groupForYearArr() -> [Int] {
    //    return (1900 ..< 2100).map({ $0 })
    //}
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToDate(date: selectedDate)
        print(WeekViewController.monthArr)
    }
    
    //WeekViewControllerからsegueを使ってDaycheduleViewControllerにselectedDateとselectedItemのデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dayViewController" {
            let vc = segue.destination as! DayViewController
            vc.selectedItem = self.selectedItem
            let dateComponents  = DateComponents(calendar:Calendar.current, year: selectedItem!.year, month: selectedItem!.month, day: selectedItem!.day)
            vc.selectedDate = dateComponents.date!
        }
    }
    
    
    //月表示で選択した日付が日表示で開かれるようにする
    private func scrollToDate(date: Date = Date()) {
        let calendar = Calendar(identifier: .gregorian)
        
        //dateの情報をdateIntervalで秒単位に変換する。→ それをdateComponentsでIntに変換して、今を表示する。
        let yearInterval = calendar.dateInterval(of: .year, for: date)!
        let monthInterval = calendar.dateInterval(of: .month, for: date)!
        //Int?なのでguardでオプショナルバインディングをしている。
        guard let year = calendar.dateComponents([.year], from: yearInterval.start).year,
            let month = calendar.dateComponents([.month], from: monthInterval.start).month
            else { return }
        
        //for文で全ての月のデータが入っているArrayを回して、一致するデータを探す。
        for (section, value) in WeekViewController.monthArr.enumerated() {
            if year == value.year && month == value.month{
                
                let indexPath = IndexPath.init(row: 0, section: section)
                
                //該当の月のカレンダーが、常に画面の真ん中に現れるように設定。animatedは日付を検索した時に、falseだと直移動、trueだと高速スクロールで移動する。
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
                return
            }
        }
    }
    
    
    
    
    
    // 月表示のカレンダーを繰り返し表示する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WeekViewController.monthArr.count
    }
    
    //全データを取得。2400月データがmonthArr配列に入っている。
    //numberOfItemsInSectionは外部パラメーター（ラベル）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let yearMonth = WeekViewController.monthArr[section]
        let monthDays = getMonthDays(monthInfo: yearMonth)
        return monthDays.count
    }
    
    //空のcellを用意する。storyboardで作った"WeekCollectionViewCell"と紐付ける。
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //dequeueすれば他のファイルのIBOutletを使うことができる
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCollectionViewCell", for: indexPath) as! WeekCollectionViewCell
        print(indexPath)
        //今日じゃないところは背景を透明にする。
        cell.contentView.backgroundColor = .clear
        // rowは一日ごとのマス(普通はitemと書く)。sectionは月単位のカレンダー。indexPathは、rowとsectionと一緒に使う。
        //myLabelはstoryboardで、私が決めたセルの名前。
        let yearMonth = WeekViewController.monthArr[indexPath.section]
        if let day = getMonthDays(monthInfo: yearMonth)[indexPath.item] {
            //日曜日を赤色にする。7で割った時に余りが0になるのが日曜日。
            if (indexPath.row % 7 == 0) {
                cell.myLabel.textColor = UIColor.red
                //　土曜日を青色にする。7で割った時に余りが6になるのが日曜日。
            }else if (indexPath.row % 7 == 6 ) {
                cell.myLabel.textColor = UIColor.blue
            }else {
                cell.myLabel.textColor = UIColor.black
            }
            cell.myLabel.text = "\(day.day!)"
            
            
            
            
            //monthInfo型の変数dayをDateComponentsを使ってDate型に変換する。
            let dateComponents = DateComponents(calendar:Calendar.current, year: day.year, month: day.month, day: day.day)
            //NoteはCoreDataを使っていて、CoreDataはAppDelegateに置いている。
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let fetchedDay: [Note] = appDelegate.dataController.fetchNotesWithDate(date:  dateComponents.date!)
                //fetchedDayはスケジュールの日付。myScheduleは緑色の●。
                if fetchedDay.isEmpty {
                    cell.mySchedule.isHidden = true
                }
                else {
                    cell.mySchedule.isHidden = false
                }
            }
            
            //今日をピンク色にする処理
            let d: Date = dateComponents.date!
            if Calendar.current.isDateInToday(d) {
                //↑指定したのは今日の範囲内なのか調べる
                cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)  //colorliteralと打つと出てくる
            }
            
            
            
        } else {
            //値のない場合は、セルは空欄にする。
            cell.myLabel.text = ""
            cell.mySchedule.isHidden = true
        }
        
        return cell
    }
    
    //
    //一週間７日分の７つのセルを固定するためのコード。画面の横幅を７で割って求める。- 1.0は微差調整。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.frame.size.width/7.0 - 1.0
        return CGSize(width: w, height: w)
    }
    
    //セル間の隙間を０にする。縦横。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //セルをタップした時に呼び出されるファンクション。これを使って予定表を作る。
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let yearMonth = WeekViewController.monthArr[indexPath.section]
        let monthInfo = getMonthDays(monthInfo: yearMonth)[indexPath.item] 
        self.selectedItem = monthInfo
            
        performSegue(withIdentifier: "dayViewController", sender: nil)
    }
    
    //headerを設定するための戻り値を設定。
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //年月を表示するためのheaderを設定。
        var headerView = UICollectionReusableView()
        let width = self.view.frame.width
        headerView.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        headerView.backgroundColor = UIColor.green
        if kind == UICollectionView.elementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViews", for: indexPath)
        }
        let yearMonth = WeekViewController.monthArr[indexPath.section]
        
        //headerの上に年月を表示するラベルを作成。
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        label.textAlignment = .center
        label.text = "\(yearMonth.year)/ \(yearMonth.month)"
        _ = headerView.subviews.map({ $0.removeFromSuperview() })
        headerView.addSubview(label)
        return headerView
        
    }
    
}





// 下記はDateComponentsの練習用コード
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
