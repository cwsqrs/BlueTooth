//
//  UIButtonExtension.swift
//  BuleToothText
//
//  Created by cw on 2022/12/6.
//  Copyright © 2022 TRY. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    //图片在左边
     @objc func setIconInLeftWithSpacing(_ spacing: CGFloat){
         
         self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
         self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
    
     }
     
     //图片在右边
    @objc func setIconInRightWithSpacing(_ spacing: CGFloat){
         
         let img_W : CGFloat = self.imageView?.frame.size.width ?? 0
//         let tit_W : CGFloat = self.titleLabel?.frame.size.width ?? 0
        var titleSize = CGSize.zero
         if let txtFont = titleLabel?.font, let str = titleLabel?.text {
             titleSize = str.stringSize(font: txtFont, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
         }
        let width = min(titleSize.width, self.frame.size.width)
         self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(img_W + spacing / 2), bottom: 0, right: (img_W + spacing / 2))
         self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (width + spacing / 2), bottom: 0, right: -(width + spacing / 2))
     }

     //图片在上
     @objc func setIconInTopWithSpacing(_ Spacing: CGFloat){
         
         let img_W: CGFloat = self.imageView?.frame.size.width ?? 0
         let img_H: CGFloat = self.imageView?.frame.size.height ?? 0
         let tit_W: CGFloat = self.titleLabel?.frame.size.width ?? 0
         let tit_H: CGFloat = self.titleLabel?.frame.size.height ?? 0
         
         self.titleEdgeInsets = UIEdgeInsets(top: (tit_H / 2 + Spacing / 2), left: -(img_W / 2), bottom: -(tit_H / 2 + Spacing / 2), right: (img_W / 2))
         self.imageEdgeInsets = UIEdgeInsets(top: -(img_H / 2 + Spacing / 2), left: (tit_W / 2), bottom: (img_H / 2 + Spacing / 2), right: -(tit_W / 2))
     }

     //图片在下
    @objc func setIconInBottomWithSpacing(_ Spacing: CGFloat){
         
         let img_W: CGFloat = self.imageView?.frame.size.width ?? 0
         let img_H: CGFloat = self.imageView?.frame.size.height ?? 0
         let tit_W: CGFloat = self.titleLabel?.frame.size.width ?? 0
         let tit_H: CGFloat = self.titleLabel?.frame.size.height ?? 0
         
         self.titleEdgeInsets = UIEdgeInsets(top: -(tit_H / 2 + Spacing / 2), left: -(img_W / 2), bottom: (tit_H / 2 + Spacing / 2), right: (img_W / 2))
         self.imageEdgeInsets = UIEdgeInsets(top: (img_H / 2 + Spacing / 2), left: (tit_W / 2), bottom: -(img_H / 2 + Spacing / 2), right: -(tit_W / 2))
     }
    
}


extension String {
    
    //获取字符串显示占用的size(非多属性字符串)
    func stringSize(font : UIFont, size : CGSize) -> CGSize {
        
        if self.count > 0 {

            return NSString(string: self).boundingRect(with: size,
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: [NSAttributedString.Key.font: font],
                                                       context: nil).size
        }
        return .zero
    }
    
}

extension Date {
    
    
    
    //获取当前时间戳
    public static func getTime() -> TimeInterval {
        
        return NSDate().timeIntervalSince1970
    }
    
    //时间戳转date
    public static func getDate(_ interval: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: interval)
    }
    
    
    
    func isToday() -> Bool {
        
        let calendar = Calendar.current
        //当前时间
        let nowComponents = calendar.dateComponents([.day,.month,.year], from: Date() )
        //self
        let selfComponents = calendar.dateComponents([.day,.month,.year], from: self as Date)
        
        return (selfComponents.year == nowComponents.year) &&
            (selfComponents.month == nowComponents.month) &&
            (selfComponents.day == nowComponents.day)
    }
    
    //时间戳转成字符串
    public static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let date: NSDate = .init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    
}


