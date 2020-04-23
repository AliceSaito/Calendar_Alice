//
//  YearViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2020/01/10.
//  Copyright © 2020 斉藤 アリス. All rights reserved.
//

import UIKit


class YearViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedDate: Date?

    let years: [Int] = groupForYearArr()
    var thisYear: Int {
        
        let calendar = Calendar.current
        let yearInterval = calendar.dateInterval(of: .year, for: Date())!
        return calendar.dateComponents([.year], from: yearInterval.start).year!

    }
    //viewDidLoadは最初の一回しか呼ばれない。
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0.0
        
        
    }
    var firstAppear: Bool = false
    //viewDidAppearは何回も呼ばれる。でもviewDidLoadでは処理が間に合わないのでココで呼ぶ。何度も呼ばれないようにif文を下記に記載。
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear == false {
            print("1回目")
            //scrollToDateは指定された日付にスクロールさせるfunc。
            scrollToTHisYear()
            firstAppear = true
        }
        
    }
    
    //次の画面にデータを渡す。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WeekViewController
        vc.selectedDate = self.selectedDate
    }
    
    
    //今年が出るようにしている
    private func scrollToTHisYear() {
        
        UIView.animate(withDuration: 0.6) {
            let index: Int = self.thisYear - 1900
            let indexPath = IndexPath.init(row: 0, section: index)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
            self.collectionView.alpha = 1.0
        }
    }
}


extension YearViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // 月表示のカレンダーを繰り返し表示する
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return years.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthMiniCollectionViewCell", for: indexPath) as! MonthMiniCollectionViewCell
        let year = self.years[indexPath.section]
        let month = indexPath.row + 1
        
        let monthInfo = MonthInfo.init(year: year, month: month, day: nil)
        
        let date = getMonthDays(monthInfo: monthInfo )

        (cell as? MonthMiniCollectionViewCell)?.setData(monthInfo: date)

        return cell
    }
    
    

    //didSelectItemAt：タップした日付の情報を次の画面に渡す。
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let year = self.years[indexPath.section]
        let month = indexPath.row + 1
        
        let dateComponents = DateComponents(calendar:Calendar.current, year: year, month: month, day: 1)
        self.selectedDate = dateComponents.date
        
        return true
    }
    
    //年間表示中のカレンダー部分のサイズ調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.collectionView.frame.width - 40)/3, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        //「2020」の部分。
        var headerView = UICollectionReusableView()
        let width = self.view.frame.width
        if kind == UICollectionView.elementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "YearHeaderView", for: indexPath)
        }
//        headerView.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        headerView.backgroundColor = UIColor.green

        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .black
        let year = years[indexPath.section]
        label.text = "\(year)"
        _ = headerView.subviews.map({ $0.removeFromSuperview() })
        headerView.addSubview(label)
        return headerView

    }
}
