//
//  MonthMiniCollectionViewCell.swift
//  Calendar_Alice
//
//  Created by 斉藤アリス on 2020/02/13.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit

class MonthMiniCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var miniMonthMiniCollectionView: MonthMiniCollectionView!
    var monthInfoArry: [MonthInfo?] = []
    
    func setData(monthInfo: [MonthInfo?]) {
        self.monthInfoArry = monthInfo
        
        self.miniMonthMiniCollectionView.performBatchUpdates({
            self.monthInfoArry = monthInfo
        }) { (_) in
            self.miniMonthMiniCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.monthInfoArry = []

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.monthInfoArry = []
    }
}


extension MonthMiniCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthInfoArry.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthMiniDayCell", for: indexPath) as! MonthMiniDayCell
        //今日じゃないところは背景を透明にする。
        cell.contentView.backgroundColor = .clear
        
        if let monthInfo = monthInfoArry[indexPath.row] {
            if let day = monthInfo.day {
                cell.label.text = "\(day)"
            }
            //monthInfo型の変数dayをDateComponentsを使ってDate型に変換する。
            let dateComponents = DateComponents(calendar:Calendar.current, year: monthInfo.year, month: monthInfo.month, day: monthInfo.day)
            //今日をピンク色にする処理
            let d: Date = dateComponents.date!
            if Calendar.current.isDateInToday(d) {
                //↑指定したのは今日の範囲内なのか調べる
                cell.contentView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)  //colorliteralと打つと出てくる
            }
            
        }  else {
            cell.label.text = ""
            
        }
       
        //上記の別の書き方：今日だけピンク色の背景にする方法。
        //        let date:Date = Date()  今日を取得(Date型）
        //        let MonthInfo:MonthInfo  Year,Month,DayをIntで持っている
        //
        //        今知りたいのはYear, Month, Dayと、Date型を比較して、その日かどうか判定する
        //        ↓
        //        func isToday(year: Int, month: Int, day: Int) -> Bool {
        //            let dateComponents = DateComponents(calendar: Calendar.current, year: monthInfo.year, month: monthInfo.month, day:monthInfo.day)
        //            let d: Date = dateComponents.date
        //            if Calenda.current.isDateInToday(date: d) {
        //                return true
        //            }
        //            else {
        //                return false
        //            }
        //        }
        
        //        var isToday: Bool = false
        //        if isToday == true {
        //            cell.contentView.backgroundColor = .red
        //        }
        //
        
        return cell
        //↑色々セットしたcellを最後にreturnで返す
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //タップした日付のデータをコンソルにプリント
        let date = monthInfoArry[indexPath.row]
        print("selected date \(date)")
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var headerView = UICollectionReusableView()
        let width = self.frame.width
        
        if kind == UICollectionView.elementKindSectionHeader {
            var headerView2 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeaderView", for: indexPath) as! AlmanacCollectionReusableView
            headerView2.frame = CGRect.init(x: 0, y: 0, width: width, height: 30)
            headerView2.backgroundColor = UIColor.yellow
            headerView2.AlmanacLabel.text = ""
            headerView = headerView2
            
            let monthName: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            let month: Int = monthInfoArry[10]!.month
            let text = monthName[month - 1]
            headerView2.AlmanacLabel.text = "\(text)"
//            print(indexPath)
        }
        guard  let MonthInfo = monthInfoArry[indexPath.row] else { return headerView }

//        let month = MonthInfo.month
//               let df = DateFormatter.init()
//               let monthSymbol = (df.monthSymbols)[month - 1]
//               let index = monthSymbol.index(monthSymbol.startIndex, offsetBy: 3)
//               let shotSymbol = monthSymbol[..<index]
//               label.text = "\(shotSymbol)"
//
//
//        headerView.addSubview(label)
        return headerView

    }

    
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
}

