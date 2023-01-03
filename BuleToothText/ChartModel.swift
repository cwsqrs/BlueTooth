//
//  ChartModel.swift
//  BuleToothText
//
//  Created by cw on 2022/12/19.
//  Copyright © 2022 TRY. All rights reserved.
//

import UIKit

enum ChartType: Int {
    
    case none = 0           //其他
    case quantity          //电量
    case voltage           //电压
    case electricity       //电流
    case temperature       //温度
}

class ChartModel: NSObject, NSCoding {
    
    dynamic var time: Double = 0
    dynamic var value: String = ""
    dynamic var type: ChartType = .none
    
    override init() {
        super.init()
    }
    
    
    //归档
    func encode(with coder: NSCoder) {
        coder.encode(time, forKey: "time")
        coder.encode(value, forKey: "value")
        coder.encode(type.rawValue, forKey: "type")
        
//        var count: UInt32 = 0
//        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
//            return
//        }
//        for i in 0 ..< count {
//            let ivar = ivars[Int(i)]
//            let name = ivar_getName(ivar)
//
//            let key = String(validatingUTF8: name!)!
//
//            if let value = self.value(forKey: key) {
//                coder.encode(value, forKey: key)
//            }
//        }
//        // 释放ivars
//        free(ivars)
    }
    
    //解档
    required init?(coder: NSCoder) {
        super.init()
        
        self.time = coder.decodeDouble(forKey: "time")
        
        if let value = coder.decodeObject(forKey: "value") as? String {
            self.value = value
        }
        
        let rawValue = coder.decodeInteger(forKey: "type")
        if let type = ChartType(rawValue: rawValue) {
            self.type = type
        }
//        var count: UInt32 = 0
//        guard let ivars = class_copyIvarList(self.classForCoder, &count) else {
//            return
//        }
//        for i in 0 ..< count {
//            let ivar = ivars[Int(i)]
//            let name = ivar_getName(ivar)
//            let key = String(validatingUTF8: name!)!
//            if let value = coder.decodeObject(forKey: key) {
//                self.setValue(value, forKey: key)
//            }
//        }
//        // 释放ivars
//        free(ivars)
    }
        

}
