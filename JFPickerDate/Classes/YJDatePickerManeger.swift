//
//  YJDatePickerManeger.swift
//  text
//
//  Created by summer on 2019/12/20.
//  Copyright © 2019 summer. All rights reserved.
//

enum FixType {
    case noFix
    case year
    case month
    case day
    case hour
    case minute
    case second
}

import UIKit

extension UIDatePicker{
    /// 默认时期
    static func showView( formatter: String = "yyyy-MM-dd" ,backBlock:@escaping ((String,TimeInterval )) -> Void) {
                
        YJDatePickerView.show(dateformatter: formatter,mode: .date, min: nil, max: nil, select: nil,backBlock: backBlock)
    }
    
      /// day 过去的天数
      /// date 开始时间点
    static func showView( formatter: String = "yyyy-MM-dd" ,mode:YJDatePickerView.DetaMode = .date ,fix:FixType = .noFix ,day: Int = 1, date: Date = Date(),select:Date?,backBlock:@escaping ((String,TimeInterval )) -> Void) {
       
        var oldDate =  Calendar.current.date(byAdding: Calendar.Component.day, value: -(day), to: date)
        
        if fix != .noFix,let fixDate = oldDate {
            oldDate = timeFix(date: fixDate, type:fix )
        }
        
        let selectInter = select?.timeIntervalSince1970
       
        YJDatePickerView.show(dateformatter: formatter,mode: mode, min: oldDate?.timeIntervalSince1970, max: date.timeIntervalSince1970, select: selectInter,backBlock: backBlock)
        
    }
    
    /// day 过去的月份
    /// date 开始时间点
    static func showView( formatter: String = "yyyy-MM-dd" ,month: Int = 1,fix:FixType = .noFix , date: Date = Date(),backBlock:@escaping ((String,TimeInterval )) -> Void) {
        
        var oldDate =  Calendar.current.date(byAdding: Calendar.Component.month, value: -(month), to: date)
        
        if fix != .noFix,let fixDate = oldDate {
            oldDate = timeFix(date: fixDate, type:fix )
        }
        
        YJDatePickerView.show(dateformatter: formatter,mode: .date, min: oldDate?.timeIntervalSince1970, max: date.timeIntervalSince1970, select: nil,backBlock: backBlock
        )

    }
       
    /// day 过去的年
       /// date 开始时间点
       static func showView( formatter: String = "yyyy-MM-dd" ,year: Int = 1,fix:FixType = .noFix , date: Date = Date(),backBlock:@escaping ((String,TimeInterval )) -> Void) {
          
        var oldDate =  Calendar.current.date(byAdding: Calendar.Component.year, value: -(year), to: date)
            
        if fix != .noFix,let fixDate = oldDate {
            oldDate = timeFix(date: fixDate, type:fix )
        }
        
        YJDatePickerView.show(dateformatter: formatter,mode: .date, min: oldDate?.timeIntervalSince1970, max: date.timeIntervalSince1970, select: nil,backBlock: backBlock)
       }
    
       
    static func showView( formatter: String = "yyyy-MM-dd" ,mode: YJDatePickerView.DetaMode = .date,min: Date, max: Date = Date(),select: Date? = nil,backBlock:@escaping ((String,TimeInterval )) -> Void) {
           let startInterval = min.timeIntervalSince1970
           let endInterval = max.timeIntervalSince1970
           var selectInterval : TimeInterval?
           if let selectDate = select {
               selectInterval = selectDate.timeIntervalSince1970
           }

           YJDatePickerView.show(dateformatter: formatter,mode: mode, min: startInterval, max: endInterval, select: selectInterval,backBlock: backBlock)
       }
    
    
       static func showView( formatter: String = "yyyy-MM-dd" ,min: TimeInterval, max: TimeInterval,select: TimeInterval,backBlock:@escaping ((String,TimeInterval )) -> Void) {
           
            YJDatePickerView.show(dateformatter: formatter,mode: .date, min: min, max: max, select: nil,backBlock: backBlock)
       }
    
    
    
    static func showView( formatter: String = "yyyy-MM-dd" ,mode: YJDatePickerView.DetaMode = .date,min: Date?, max: Date?,select: Date?,backBlock:@escaping ((String,TimeInterval )) -> Void) {

        YJDatePickerView.show(dateformatter: formatter,mode: mode, min: min?.timeIntervalSince1970, max: max?.timeIntervalSince1970, select: select?.timeIntervalSince1970,backBlock: backBlock)
        }
    
   static func timeFix(date:Date,type:FixType) -> Date {

       let format = "yyyy-MM-dd HH:mm"
          
       var dateFormatter: DateFormatter {
           let dateFormatter = DateFormatter.init()
           dateFormatter.dateFormat = format
           return dateFormatter
       }
               
        let year = Set(arrayLiteral: Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second)

        var endComp = dateFormatter.calendar.dateComponents(year, from: date)
        
        switch type {
        case .year:
            endComp.month = 1
            endComp.day = 1
            endComp.hour = 00
            endComp.minute = 00
            endComp.second = 00
        case .month:
            endComp.day = 1
            endComp.hour = 00
            endComp.minute = 00
            endComp.second = 00
        case .day:
            endComp.hour = 00
            endComp.minute = 00
            endComp.second = 00
        case .hour:
            endComp.minute = 00
            endComp.second = 00
        case .minute:
            endComp.second = 00
            break
        default : break
        }
          return dateFormatter.calendar.date(from: endComp) ?? Date.init()
    }
}
