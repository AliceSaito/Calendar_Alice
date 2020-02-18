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
            self.miniMonthMiniCollectionView.reloadData()
        }
            // FIXME: もう一回りロードしないとデータがめっちゃくちゃになる
            self.miniMonthMiniCollectionView.reloadData()
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

        if let monthInfo = monthInfoArry[indexPath.row] {
            if let day = monthInfo.day {
                cell.label.text = "\(day)"
            }
        }  else {
            cell.label.text = ""
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let date = monthInfoArry[indexPath.row]
        print("selected date \(date)")
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var headerView = UICollectionReusableView()
        let width = self.frame.width
        headerView.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        headerView.backgroundColor = UIColor.green
        if kind == UICollectionView.elementKindSectionHeader {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MonthHeaderView", for: indexPath)
        }
        guard  let MonthInfo = monthInfoArry[indexPath.row] else { return headerView }

        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .blue
        label.textColor = .black
        
        _ = headerView.subviews.map({ $0.removeFromSuperview() })

        let month = MonthInfo.month
        let df = DateFormatter.init()
        let monthSymbol = (df.monthSymbols)[month - 1]
        let index = monthSymbol.index(monthSymbol.startIndex, offsetBy: 3)
        let shotSymbol = monthSymbol[..<index]
        label.text = "\(shotSymbol)"
        
        headerView.addSubview(label)
        return headerView

    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.frame.width/7, height: 15)
    }
}

