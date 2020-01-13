//
//  WeekViewController.swift
//  Calendar_Alice
//
//  Created by 斉藤 アリス on 2019/12/18.
//  Copyright © 2019 斉藤 アリス. All rights reserved.
//

import UIKit
import CalculateCalendarLogic


class WeekViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


	let calendar = Calendar.current
	let rightNow = Date()

	// 200年間の(年、Month)データ
	// 200 x 12 = 2400件の月データがこのmonthArr配列に入っている
	static let monthArr: [(year: Int, month: Int)] = {

		var temp = [(Int, Int)]()
		(1900..<2100).forEach { (year) in

			(1..<13).forEach { (month) in
				temp.append((year, month))
			}
		}
		return temp
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

	// ある年と月をパラメータとして入れるとその年月の日付情報が返される
	func getMonthDays(monthInfo: (year: Int, month: Int)) -> [(year: Int, month: Int, day: Int)?] {

		var monthDays: [(year: Int, month: Int, day: Int)?] = []
		// Date
		let dateComponents = DateComponents(calendar: calendar, year: monthInfo.year, month: monthInfo.month, day: 1)
		let composedDate = calendar.date(from: dateComponents)

		// 例えばパラメータ2020/1/1のDateがこんな感じで作られる
		//     public func date(from components: DateComponents) -> Date?

		guard let startDay = composedDate else { return [] }

		// ある月の一日が何番目にあるかindexを取得して0 ~ そのindexまでは先月の日付だからfor文で回してnilをArrayに入れる
		// nilデータはそのカレンダーに描画されず空白で表示される

		let component = calendar.component(Calendar.Component.weekday, from: startDay)
        let weekday = component - 1 // 

		(0..<weekday).forEach { _ in
			monthDays.append(nil)
		}

		let totalDays = calendar.range(of: .day, in: .month, for: startDay)?.count ?? 0
		(1..<totalDays+1).forEach { (day) in
			monthDays.append((monthInfo.year, monthInfo.month, day))
		}

		// nil, nil, nil, (2020, 1, 1), (2020, 1, 2), (2020, 1, 3), ...]
		return monthDays

	}
    
	// 月表示のカレンダーを２回繰り返し表示する
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return WeekViewController.monthArr.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		let yearMonth = WeekViewController.monthArr[section]
		let monthDays = getMonthDays(monthInfo: yearMonth)
		return monthDays.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCollectionViewCell", for: indexPath) as! WeekCollectionViewCell

		//        cell.myLabel.text = items[indexPath.item]
		print(indexPath)
		//indexPathは、itemとsectionと一緒に使う。itemは月表示のカレンダー、sectionはその繰り返しの回数。

		let yearMonth = WeekViewController.monthArr[indexPath.section]
		if let day = getMonthDays(monthInfo: yearMonth)[indexPath.row] {
			cell.myLabel.text = "\(day.day)"
		} else {
			cell.myLabel.text = ""
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(indexPath.item)
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

		var headerView = UICollectionReusableView()
		let width = self.view.frame.width
		headerView.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
		headerView.backgroundColor = UIColor.green
		if kind == UICollectionView.elementKindSectionHeader {
			headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViews", for: indexPath)
		}
		let yearMonth = WeekViewController.monthArr[indexPath.section]

		let label = UILabel()
		label.frame = CGRect.init(x: 0, y: 0, width: width, height: 40)
		label.textAlignment = .center
		label.text = "\(yearMonth.year)/ \(yearMonth.month)"
		_ = headerView.subviews.map({ $0.removeFromSuperview() })
		headerView.addSubview(label)
		return headerView

	}

}

