//
//  LineChartVC.swift
//  BuleToothText
//
//  Created by cw on 2022/12/16.
//  Copyright © 2022 TRY. All rights reserved.
//

import UIKit


class LineChartVC: UIViewController {
    
    var charts = [ChartModel]()
    
    dynamic var type: ChartType = .none
    
    var lineChartView = ORLineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .quantity:
            title = "电量波动"
        case .voltage:
            title = "电压波动"
        case .electricity:
            title = "电流波动"
        case .temperature:
            title = "温度波动"
        default:
            break
        }
//        charts = [("17:28:01", "334"), ("17:29:02", "434"), ("17:30:03", "534"), ("17:31", "8000"), ("17:32", "3000"), ("17:33", "2000"), ("17:34", "334"), ("17:35", "434"), ("17:36", "534"), ("17:37", "8000"), ("17:38", "3000"), ("17:39", "2000")]
        
        
        
        lineChartView.frame = CGRect(x: 0, y: (UIScreen.main.bounds.size.height - 350) / 2, width: UIScreen.main.bounds.size.width, height: 350)
//        lineChartView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        lineChartView.config.gradientLocations = [0.8, 0.9]
        lineChartView.config.bottomLabelWidth = 65
        lineChartView.config.bottomInset = 0
        lineChartView.config.leftWidth = 60
        
        
        lineChartView.defaultSelectIndex = 0
        lineChartView.dataSource = self
        lineChartView.delegate = self
        view.addSubview(lineChartView)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lineChartView.reloadData()
    }
    
    

}

extension LineChartVC: ORLineChartViewDelegate, ORLineChartViewDataSource {
    func numberOfHorizontalData(of chartView: ORLineChartView) -> Int {
        return charts.count
    }
    
    func chartView(_ chartView: ORLineChartView, valueForHorizontalAt index: Int) -> CGFloat {
        return CGFloat(Double(charts[index].value) ?? 0)
    }
    
    func numberOfVerticalLines(of chartView: ORLineChartView) -> Int {
        return 10
    }
    
    func chartView(_ chartView: ORLineChartView, titleForHorizontalAt index: Int) -> String {
        let time = charts[index].time
        let date = Date.getDate(time)
        var dateFormat = "yyyy-MM-dd HH:mm:ss"
        if date.isToday() {
            dateFormat = "HH:mm:ss"
        } else {
            dateFormat = "MM-dd"
        }
        let title = Date.timeIntervalChangeToTimeStr(timeInterval: time, dateFormat)
        return title
    }
    
    func chartView(_ chartView: ORLineChartView, attributedStringForIndicaterAt index: Int) -> NSAttributedString {
        let attr = NSAttributedString(string: charts[index].value)
        return attr
    }
    
    func labelAttrbutesForVertical(of chartView: ORLineChartView) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    
    func labelAttrbutesForHorizontal(of chartView: ORLineChartView) -> [NSAttributedString.Key : Any] {
        return [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
}
