//
//  DetailBLEVC.swift
//  BuleToothText
//
//  Created by cw on 2022/12/7.
//  Copyright © 2022 TRY. All rights reserved.
//

import UIKit
import CoreBluetooth

typealias PeripheralType = (title: String, content: String, image: UIImage?, type: ChartType)

class DetailBLEVC: UIViewController {
    
    @objc var peripheral: CBPeripheral?
    @objc var sensor: SerialGATT?
    
    @IBOutlet weak var tableView: UITableView!
    
    var datas = [PeripheralType]()
    var quantitys = [ChartModel]()
    var voltages = [ChartModel]()
    var electricitys = [ChartModel]()
    var temperatures = [ChartModel]()
    
    var quantity: Int = -1
    var temperature: Int = -1
    private var sourceTimer : DispatchSourceTimer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = sensor?.activePeripheral.name
        tableView.register(UINib(nibName: "DetailShowCell", bundle: nil), forCellReuseIdentifier: "DetailShowCell")
        sensor?.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        addNavLeftItem()
        
        datas.append(("电量：", "1%", UIImage(named: "quantity"), .quantity))
//        datas.append(("电压：", "64V", UIImage(named: "voltage"), .voltage))
        
        
        DispatchQueue.main.asyncAfter(deadline: (.now() + 3)) {
            self.repeatQuantity()
        }
        
        if let quantityData = UserDefaults.standard.object(forKey: "quantityCacheKey") as? Data {
            if let quantitys = NSKeyedUnarchiver.unarchiveObject(with: quantityData) as? [ChartModel] {
                let time = Date.getTime()
                self.quantitys = quantitys.filter({time - $0.time < 60 * 60 * 24 * 7})
            }
        }
        
        if let voltageData = UserDefaults.standard.object(forKey: "voltageCacheKey") as? Data {
            if let voltages = NSKeyedUnarchiver.unarchiveObject(with: voltageData) as? [ChartModel] {
                let time = Date.getTime()
                self.voltages = voltages.filter({time - $0.time < 60 * 60 * 24 * 7})
            }
        }
        
        if let electricityData = UserDefaults.standard.object(forKey: "electricityCacheKey") as? Data {
            if let electricitys = NSKeyedUnarchiver.unarchiveObject(with: electricityData) as? [ChartModel] {
                let time = Date.getTime()
                self.electricitys = electricitys.filter({time - $0.time < 60 * 60 * 24 * 7})
            }
        }
        
        if let temperatureData = UserDefaults.standard.object(forKey: "temperatureCacheKey") as? Data {
            if let temperatures = NSKeyedUnarchiver.unarchiveObject(with: temperatureData) as? [ChartModel] {
                let time = Date.getTime()
                self.temperatures = temperatures.filter({time - $0.time < 60 * 60 * 24 * 7})
            }
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.sourceTimer?.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        repeatQuantity()
    }
    
    func repeatQuantity() {
        sourceTimer?.cancel()
        sourceTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())     //定时器(倒计时用)
         sourceTimer?.schedule(deadline: .now(), repeating: .seconds(20))
//        sourceTimer?.schedule(deadline: .now(), repeating: .seconds(60 * 10))
         sourceTimer?.setEventHandler( handler: {[weak self] in
             self?.refreshQuantity()
        })
         sourceTimer?.resume()
    }
    
    @objc func refreshQuantity() {
        let time = Date.getTime()
        if quantity >= 0 {
            let model = ChartModel()
            model.time = time
            model.value = "\(quantity)"
            model.type = ChartType.quantity
            quantitys.insert(model, at: 0)
            
            let data = NSKeyedArchiver.archivedData(withRootObject: quantitys)
            UserDefaults.standard.set(data, forKey: "quantityCacheKey")
            UserDefaults.standard.synchronize()
        }
        
        if temperature >= 0 {
            let model1 = ChartModel()
            model1.time = time
            model1.value = "\(temperature)"
            model1.type = ChartType.temperature
            temperatures.insert(model1, at: 0)
            
            let data1 = NSKeyedArchiver.archivedData(withRootObject: temperatures)
            UserDefaults.standard.set(data1, forKey: "temperatureCacheKey")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    // 导航栏左键点击处理
    func addNavLeftItem() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: self.navigationController?.navigationBar.bounds.size.height ?? 0.0)
        button.setImage(UIImage(named: "Navigation_Back_icon"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(leftItemClickHandle), for: .touchUpInside)

        let navRightItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = navRightItem
    }

    // 导航栏右键点击处理
    @objc func leftItemClickHandle() {
        sensor?.disconnect(peripheral)
        self.navigationController?.popViewController(animated: true)
    }
    

    

}

extension DetailBLEVC: BTSmartSensorDelegate {
    
    //持续接受蓝牙数据
    func serialGATTCharValueUpdated(_ UUID: String!, value str: String!) {
        print("!!!!!!!!!\(str ?? "")!!!!!!!!!")
//        var quantity = 0
        var voltage = 0
        var electricity = 0
//        var temperature = 0
        var fastCharge = 0
        datas.removeAll()
        if str.count >= 2 {
            let str1: String = String(str.prefix(2))
            quantity = Int(str1, radix: 16) ?? 0
            datas.append(("电量：", "\(quantity)%", UIImage(named: "quantity"), .quantity))
            
            
            if str.count >= 4 {
                let str2: String = String(str.dropFirst(2).prefix(2))
                voltage = (Int(str2, radix: 16) ?? 0)  * 64
                datas.append(("电压：", "\(voltage)mV", UIImage(named: "voltage"), .voltage))
                
                let time = Date.getTime()
                let model = ChartModel()
                model.time = time
                model.value = "\(voltage)"
                model.type = ChartType.voltage
                voltages.insert(model, at: 0)
                
                let data = NSKeyedArchiver.archivedData(withRootObject: voltages)
                UserDefaults.standard.set(data, forKey: "voltageCacheKey")
                UserDefaults.standard.synchronize()
                
                
                if str.count >= 6 {
                    let str3: String = String(str.dropFirst(4).prefix(2))
                    electricity = (Int(str3, radix: 16) ?? 0) * 32
                    datas.append(("电流：", "\(electricity)mA", UIImage(named: "electricity"), .electricity))
                    
                    let time = Date.getTime()
                    let model = ChartModel()
                    model.time = time
                    model.value = "\(electricity)"
                    model.type = ChartType.electricity
                    electricitys.insert(model, at: 0)
                    
                    let data = NSKeyedArchiver.archivedData(withRootObject: electricitys)
                    UserDefaults.standard.set(data, forKey: "electricityCacheKey")
                    UserDefaults.standard.synchronize()
                    
                    
                    if str.count >= 8 {
                        let str4: String = String(str.dropFirst(6).prefix(2))
                        temperature = Int(str4, radix: 16) ?? 0
                        datas.append(("温度：", "\(temperature)℃", UIImage(named: "temperature"), .temperature))
                        
                        
                        if str.count >= 10 {
                            let str5: String = String(str.dropFirst(8).prefix(2))
                            fastCharge = Int(str5, radix: 16) ?? 0
                            datas.append(("是否快充：", fastCharge == 1 ? "是" : "否", UIImage(named: "fast_charge"), .none))
                            
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func setConnect() {
        print("22")
    }
    
    func setDisconnect() {
        print("11")
    }
    
}

extension DetailBLEVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailShowCell", for: indexPath) as? DetailShowCell {
            cell.updateCell(datas[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = datas[indexPath.row].type
        var models = [ChartModel]()
        switch type {
        case .quantity:
            models = quantitys
        case .voltage:
            models = voltages
        case .electricity:
            models = electricitys
        case .temperature:
            models = temperatures
        default:
            return
        }
        let lineChartVC = LineChartVC()
        lineChartVC.charts = models
        lineChartVC.type = type
        navigationController?.pushViewController(lineChartVC, animated: true)
    }
    
}
