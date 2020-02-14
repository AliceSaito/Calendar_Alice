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

    let years: [Int] = groupForYearArr()
    var thisYear: Int {
        let calendar = Calendar.current
        let yearInterval = calendar.dateInterval(of: .year, for: Date())!
        return calendar.dateComponents([.year], from: yearInterval.start).year!

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToDate()
    }


    private func scrollToDate(date: Date = Date()) {
        UIView.animate(withDuration: 0.6) {
            let index = self.thisYear - 1900
            let indexPath = IndexPath.init(row: 0, section: index)
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: false)
            self.collectionView.alpha = 1.0
        }
    }
}


extension YearViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // 月表示のカレンダーを２回繰り返し表示する
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
        
        var monthInfo = MonthInfo.init(year: year, month: month, day: nil)
        
        let date = getMonthDays(monthInfo: monthInfo )

        (cell as? MonthMiniCollectionViewCell)?.setData(monthInfo: date)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.collectionView.frame.width - 40)/3, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var headerView = UICollectionReusableView()
        let width = self.view.frame.width
        headerView.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        headerView.backgroundColor = UIColor.green
        if kind == UICollectionView.elementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "YearHeaderView", for: indexPath)
        }

        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .red
        let year = years[indexPath.section]
        label.text = "\(year)"
        _ = headerView.subviews.map({ $0.removeFromSuperview() })
        headerView.addSubview(label)
        return headerView

    }
}
