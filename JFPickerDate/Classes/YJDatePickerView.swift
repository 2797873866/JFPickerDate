//
//  YJDatePickerView.swift
//  test
//
//  Created by summer on 2019/10/30.
//  Copyright © 2019 summer. All rights reserved.
//

import UIKit

class YJDatePickerView: UIView {

    private var backBlock:(((String,TimeInterval))->Void)?
    
    private lazy var contentView: UIView = {
    
        let contentView = UIView.init()
        let height = CGFloat(250)
        let width = self.frame.size.width
        let y = self.frame.size.height - height
        contentView.frame = CGRect.init(x: 0, y: y, width: width, height: height)
        
        self.addSubview(contentView)
        contentView.addSubview(self.buttons)
        contentView.addSubview(self.pickerView)
        
        return contentView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView =  UIPickerView.init()
        
        let width = self.frame.size.width
        let height = CGFloat(200)
        let y = CGFloat(50)
       
        pickerView.frame = CGRect.init(x: 0, y: y, width: width, height: height)
        
        pickerView.backgroundColor = UIColor.white
        
        self.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
   private lazy var tapGesture: UITapGestureRecognizer = {
        var tapGesture = UITapGestureRecognizer.init(target: self, action:#selector(tapGestureAction))
        
        return tapGesture
    }()

    
   private lazy var buttons: UIView = {
        let height = CGFloat(50)
        let width = self.frame.size.width
        let y = CGFloat(0)
        var buttons = UIView.init(frame: CGRect.init(x: 0, y: y, width: width, height: height))
        buttons.backgroundColor = UIColor.gray
            
        let btnWidth = CGFloat(80)
        let leftBtn = UIButton.init(type: UIButton.ButtonType.custom)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: btnWidth, height: 50)
        leftBtn.titleLabel?.textAlignment = .center
        leftBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        leftBtn.setTitle("取消", for: UIControl.State.normal)
        leftBtn.setTitleColor(UIColor.green, for: UIControl.State.normal)
        leftBtn.addTarget(self, action: #selector(cancelBtnAction), for: UIControl.Event.touchUpInside)
        leftBtn.backgroundColor = UIColor.clear

        buttons.addSubview(leftBtn)

        let rightBtn = UIButton.init(type: UIButton.ButtonType.custom)
        rightBtn.frame = CGRect.init(x: buttons.frame.size.width - btnWidth, y: 0, width: btnWidth, height: 50)
        rightBtn.titleLabel?.textAlignment = .center
        leftBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        rightBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18)
        rightBtn.setTitle("确定", for: UIControl.State.normal)
        rightBtn.setTitleColor(UIColor.green, for: UIControl.State.normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: UIControl.Event.touchUpInside)
        rightBtn.backgroundColor = UIColor.clear

        buttons.addSubview(rightBtn)
        return buttons
    }()
    
    
     
    //============== 数据源 =================
    public typealias DetaMode = UIDatePicker.Mode
    
    private var mode = DetaMode.dateAndTime
    private let width =  UIScreen.main.bounds.width

    private var startDate : Date?
    private var endDate : Date?
    private var seleterTime : Date?

    private var year : [Int]?
    private var yearArray : [Int] {
         if year == nil  {
             year = handlerData(start: startCompo.year ?? 0, end: endCompo.year ?? 0)
         }
         return year!
     }
     
      
    private var monthFirst : [Int]?
    private var month : [Int]?
    private var monthLast : [Int]?
    private var monthArray : [Int] {
         if selectYear == 0 {
             if monthFirst == nil {
                if let yearA = startCompo.year,let yearB = endCompo.year, yearA == yearB {
                    monthFirst = handlerData(start: startCompo.month ?? 1 ,end: endCompo.month ?? 1)
                }else{
                    monthFirst = handlerData(start: startCompo.month ?? 1 ,end: 12)
                }
             }
             return monthFirst!
         }else if selectYear + 1 >= yearArray.count {
             if monthLast == nil {
                 monthLast = handlerData(start: 1 ,end: endCompo.month ?? 1)
             }
             return monthLast!
         }else {
             if month == nil {
                 month = handlerData(start: 1 ,end: 12)
             }
             return month!
         }
     }
     
     
    private var dayFirst : [Int]? /// 启始时间
    private var dayLast : [Int]?  /// 结束时间
    private var dayLarge : [Int]? /// 大月
    private var daySmall : [Int]? /// 小月
    private var dayLeapFeyMonth : [Int]? /// 闰二月
    private var dayFebMonth : [Int]? /// 二月
    private var dayArray : [Int] {
         
         if selectMonth == 0,selectYear == 0{ // 启始日期
             if monthArray[selectMonth] != 2,[1,3,5,7,8,10,12].contains(monthArray[selectMonth]) == true { // 启始日期不是二月,是大月 31天
                 if dayFirst == nil {
                    if let yearA = startCompo.year,let yearB = endCompo.year,let monthA = startCompo.month ,let monthB = endCompo.month, yearA == yearB ,monthA == monthB{
                        dayFirst = handlerData(start: startCompo.day ?? 0, end: endCompo.day ?? 1)
                    }else{
                        dayFirst = handlerData(start: startCompo.day ?? 0, end: 31)
                    }
                 }
                 return dayFirst!
             }else if monthArray[selectMonth] != 2 ,[4,6,9,11].contains(monthArray[selectMonth]) == true { // 启始日期不是二月,是小月 30天
                 if dayFirst == nil {
                    if let yearA = startCompo.year,let yearB = endCompo.year,let monthA = startCompo.month ,let monthB = endCompo.month, yearA == yearB ,monthA == monthB{
                        dayFirst = handlerData(start: startCompo.day ?? 0, end: endCompo.day ?? 1)
                    }else{
                        dayFirst = handlerData(start: startCompo.day ?? 0, end: 30)
                    }
                 }
                  return dayFirst!
             }else if monthArray[selectMonth] == 2 ,[1,3,5,7,8,10,12].contains(monthArray[selectMonth]) == false , [4,6,9,11].contains(monthArray[selectMonth]) == false{
                 let year = yearArray[selectYear]
                 if year != 0, year%100 != 0,(year%400 == 0 || year%4 == 0) { /// 闰月天数 29
                     
                      if dayFirst == nil {
                        if let yearA = startCompo.year,let yearB = endCompo.year,let monthA = startCompo.month ,let monthB = endCompo.month, yearA == yearB ,monthA == monthB{
                              dayFirst = handlerData(start: startCompo.day ?? 0, end: endCompo.day ?? 1)
                          }else{
                            dayFirst = handlerData(start: startCompo.day ?? 0, end: 29)
                          }
                      }
                     return dayFirst!
                  
                 }else{ /// 平年天数 28
                    
                    if dayFirst == nil {
                        if let yearA = startCompo.year,let yearB = endCompo.year,let monthA = startCompo.month ,let monthB = endCompo.month, yearA == yearB ,monthA == monthB{
                              dayFirst = handlerData(start: startCompo.day ?? 0, end: endCompo.day ?? 1)
                          }else{
                            dayFirst = handlerData(start: startCompo.day ?? 0, end: 28)
                          }
                     }
                  return dayFirst!
                 }
             }else{
                 return [Int]()
             }
         }else if (selectMonth + 1) >= monthArray.count,(selectYear + 1) >= yearArray.count{ // 结束日期
             if dayLast == nil {
                 dayLast = handlerData(start: 1, end: endCompo.day ?? 0)
             }
             return dayLast!
         }else{  // 二月日期
              
             if [1,3,5,7,8,10,12].contains(monthArray[selectMonth]) == true{ // 大月
                 /// 大月
                 if dayLarge == nil{
                    dayLarge = handlerData(start: 1, end: 31)
                 }
                 return dayLarge!
             }else if [4,6,9,11].contains(monthArray[selectMonth]) == true{ // 小月
                /// 小月
                 if daySmall == nil{
                    daySmall = handlerData(start: 1, end: 30)
                 }
                 return daySmall!
             }else if 2 == monthArray[selectMonth] { // 二月
                 /// 闰月天数 29
                 let year = yearArray[selectYear]
                 if year != 0, year%100 != 0 ,( year%4 == 0 || year%400 == 0 ){ // 闰二月
                    /// 闰月天数
                     if dayLeapFeyMonth == nil {
                         dayLeapFeyMonth = handlerData(start: 1, end: 29)
                     }
                 return dayLeapFeyMonth!
                 
                }else  { // 平二月
                    /// 平月天数
                  if dayFebMonth == nil {
                     dayFebMonth = handlerData(start: 1, end: 28)
                 }
                 return dayFebMonth!
                }
              }else{
                 return [Int]()
             }
         }
     }
     
     
    private var hourFirst : [Int]?
    private var hour : [Int]?
    private var hourLast : [Int]?
    private var hourArray : [Int] {
     if selectday == 0 ,selectMonth == 0,selectYear == 0,(mode == .dateAndTime || mode == .date){
            if hourFirst == nil {
             hourFirst = handlerData(start: startCompo.hour ?? 0 ,end: 23)
            }
            return hourFirst!
             
        }else if (selectYear + 1 ) >= yearArray.count,(selectMonth + 1) >= monthArray.count,(selectday + 1) >= dayArray.count,(mode == .dateAndTime || mode == .date){
            if hourLast == nil {
               hourLast = handlerData(start:0, end: endCompo.hour ?? 23)
            }
            return hourLast!
             
        }else{
            if hour == nil {
                hour = handlerData(start:0, end: 23)
            }
            return hour!
        }
     }
     
     
    private var minuteFirst : [Int]?
    private var minute : [Int]?
    private var minuteLast : [Int]?
    private var minuteArray : [Int] {
         if selectHour == 0 ,selectday == 0 ,selectMonth == 0,selectYear == 0,(mode == .dateAndTime || mode == .date) {
            
             if minuteFirst == nil {
                 minuteFirst = handlerData(start: startCompo.minute ?? 0,end: 59)
            }
             return minuteFirst!
             
        }else if (selectYear + 1 ) >= yearArray.count,(selectMonth + 1) >= monthArray.count,(selectday + 1) >= dayArray.count,(selectHour + 1) >= hourArray.count,(mode == .dateAndTime || mode == .date) {
            
             if minuteLast == nil {
                 minuteLast = handlerData(start:0,end: endCompo.minute ?? 0)
            }
            return minuteLast!
             
        }else{
             
            if minute == nil {
                minute = handlerData(start:0,end: 59)
            }
            return minute!
        }
     }
     

    private var secondFirst : [Int]?
    private var second : [Int]?
    private var secondLast : [Int]?
    private var secondArray : [Int] {
         if selectminute == 0 ,selectHour == 0 ,selectday == 0 ,selectMonth == 0,selectYear == 0,(mode == .dateAndTime || mode == .date) {
             if secondFirst == nil {
                 secondFirst = handlerData(start:startCompo.second ?? 0,end: 59)
             }
             return secondFirst!
                 
         }else if (selectYear + 1 ) >= yearArray.count,(selectMonth + 1) >= monthArray.count,(selectday + 1) >= dayArray.count,(selectHour + 1) >= hourArray.count ,(selectminute  + 1 ) >= minuteArray.count ,(mode == .dateAndTime || mode == .date){
             if secondLast == nil {
                 secondLast = handlerData(start: 0,end: endCompo.second ?? 0)
            }
            return secondLast!
                 
         }else{
            if second == nil {
                second = handlerData(start: 0,end: 59)
            }
             return second!
         }
     }

    private var selectYear : Int = 0
    private var selectMonth : Int = 0
    private var selectday : Int = 0
    private var selectHour : Int = 0
    private var selectminute : Int = 0
    private var selectsecond : Int = 0
     
     var startCompo : DateComponents {
        let startCompo = dateFormatter.calendar.dateComponents(yearSet, from: startDate ?? Date.init(timeIntervalSince1970: 0))
         return startCompo
     }
    
     var endCompo : DateComponents {
        let endCompo = dateFormatter.calendar.dateComponents(yearSet, from: endDate ?? Date.init())
         return endCompo
     }
     
     var dateFormatter: DateFormatter {
         let dateFormatter = DateFormatter.init()
             dateFormatter.dateFormat = formate
         return dateFormatter
     }
     
     var formate = "yyyy-MM-dd HH:mm:ss"
     
     let yearSet = Set(arrayLiteral: Calendar.Component.year,Calendar.Component.month,Calendar.Component.day,Calendar.Component.hour,Calendar.Component.minute,Calendar.Component.second)
     
     var component: DateComponents {
        return dateFormatter.calendar.dateComponents(yearSet, from: startDate!, to: endDate!)
     }

    
    deinit {
        print("\(self.self)")
    }
 }

 extension YJDatePickerView:UIPickerViewDelegate{
     
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
       
        
        let scale = UIScreen.main.bounds.width/375
         if mode == .dateAndTime ||  mode == .date{
             if component == 0 {
                    // 年
                    return 70 * scale
                }else if component == 1 {
                    // 月
                    return 50 * scale
                }else if component == 2 {
                    // 日
                    return 50 * scale
                }else if component == 3 {
                    // 时
                    return 50 * scale
                }else if component == 4 {
                    // 分
                    return 50 * scale
                }else if component == 5 {
                    // 秒
                    return 50 * scale
                }
             
         }else if mode == .time{
              if component == 0 {
                 // 时
                 return 100 * scale
             }else if component == 1 {
                 // 分
                 return 100 * scale
             }else if component == 2 {
                 // 秒
                 return 100 * scale
             }
         }
         return 0
         
     }
     
     func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
         return 30
     }
     
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        var value = 0
          if mode == .dateAndTime ||  mode == .date{
             if component == 0 {
                 // 年
                 value =  yearArray[row]
             }else if component == 1 {
                 // 月
                value = monthArray[row]
             }else if component == 2 {
                 // 日
                 value = dayArray[row]
             }else if component == 3 {
                 // 时
                 value = hourArray[row]
             }else if component == 4 {
                 // 分
                 value = minuteArray[row]
             }else if component == 5 {
                 // 秒
                 value = secondArray[row]
             }
          }else if mode == .time {
           if component == 0 {
                 // 时
                value = hourArray[row]
             }else if component == 1 {
                 // 分
               value = minuteArray[row]
             }else if component == 2 {
                 // 秒
                value = secondArray[row]
             }
         }
        
        if let view = view ,let cell = view as? YJPickerCell{
             cell.title(model: mode, component: component, title: "\(value)")
            return cell
        }else{
           let cell = YJPickerCell.cell
            cell.title(model: mode, component: component, title: "\(value)")
            return cell
        }
     }

     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
         
         if mode == .dateAndTime ||  mode == .date{

             if component == 0 {
                // 年
                 selectYear = row
             }else if component == 1 {
                // 月
                 selectMonth = row
             }else if component == 2 {
                // 日
                 selectday = row
             }else if component == 3 {
                // 时
                 selectHour = row
             }else if component == 4 {
                // 分
                 selectminute = row
             }else if component == 5 {
                // 秒
                 selectsecond = row
             }
            
         }else if mode == .time {
            if component == 0 {
               // 时
                selectHour = row
            }else if component == 1 {
               // 分
                selectminute = row
            }else if component == 2 {
               // 秒
                selectsecond = row
            }
         }

        handlerOutBundle(pickerView, didSelectRow: row, inComponent: component)

       let sel = #selector(handlePickerSelectCellHighlight)
       
        YJDatePickerView.cancelPreviousPerformRequests(withTarget:self, selector: sel, object: nil)
//        YJDatePickerView.cancelPreviousPerformRequests(withTarget:self, selector: sel, object: nil)
        perform(sel, with: nil, afterDelay: 0.01)
        perform(sel, with: nil, afterDelay: 0.2)

    }
     
     func handlerOutBundle(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
         if mode == .dateAndTime ||  mode == .date{

             for item in component..<pickerView.numberOfComponents {
                
                 pickerView.reloadComponent(item)

                 /// 越界处理
                 if  (selectMonth + 1) > monthArray.count,item >= 0 {
                     selectMonth = monthArray.count - 1
                     pickerView.reloadComponent(item)
                     pickerView.selectRow(selectMonth, inComponent: 0, animated: true)
                 }
                 
                 if  (selectday + 1) > dayArray.count,item >= 1 {
                     selectday = dayArray.count - 1
                     pickerView.reloadComponent(item)
                     pickerView.selectRow(selectday, inComponent: 1, animated: true)
                 }
                 
                 if  (selectHour + 1) > hourArray.count ,item >= 2{
                     selectHour = hourArray.count - 1
                     pickerView.reloadComponent(item)
                     pickerView.selectRow(selectHour, inComponent: 2, animated: true)
                 }
                 
                 if  (selectminute + 1) > minuteArray.count ,item >= 3{
                     selectminute = minuteArray.count - 1
                     pickerView.reloadComponent(item)
                     pickerView.selectRow(selectminute, inComponent: 3, animated: true)
                 }
                 
                 if  (selectsecond + 1) > secondArray.count ,item >= 4{
                     selectsecond = minuteArray.count - 1
                     pickerView.reloadComponent(item)
                     pickerView.selectRow(selectsecond, inComponent: 4, animated: true)
                 }
             }
          }else if mode == .time {
               for item in component..<pickerView.numberOfComponents {
                 if  (selectHour + 1) > hourArray.count ,item >= 0{
                    selectHour = hourArray.count - 1
                    pickerView.reloadComponent(item)
                    pickerView.selectRow(selectHour, inComponent: 0, animated: true)
                }
                
                if  (selectminute + 1) > minuteArray.count ,item >= 1{
                    selectminute = minuteArray.count - 1
                    pickerView.reloadComponent(item)
                    pickerView.selectRow(selectminute, inComponent: 1, animated: true)
                }
                
                if  (selectsecond + 1) > secondArray.count ,item >= 2{
                    selectsecond = minuteArray.count - 1
                    pickerView.reloadComponent(item)
                    pickerView.selectRow(selectsecond, inComponent: 2, animated: true)
                }
             }
         }
     }
    
 }

 extension YJDatePickerView:UIPickerViewDataSource {
        
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         if mode == .dateAndTime {
               return 6
         }else if mode == .date{
              return 3
         }else if mode == .time{
              return 3
         }
         return 0
     }
    
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

         if mode == .dateAndTime || mode == .date {
             if component == 0 {
                 // 年
                 return yearArray.count
             }else if component == 1 {
                 // 月
                 return monthArray.count
             }else if component == 2 {
                 // 日
                 return dayArray.count
             }else if component == 3 {
                 // 时
                 return hourArray.count
             }else if component == 4 {
                 // 分
                 return minuteArray.count
             }else if component == 5 {
                 // 秒
                 return secondArray.count
             }
         }else if mode == .time{
            if component == 0 {
                 // 时
                 return hourArray.count
             }else if component == 1 {
                 // 分
                 return minuteArray.count
             }else if component == 2 {
                 // 秒
                 return secondArray.count
             }
         }
      return 0
     }
 }

 // 数据处理
 extension YJDatePickerView{
    
     /// 处理天数据
     func handlerDayData() -> [Int]{
        var starIndex = 1
        var endIndex = 31
        
         /// 大月
         if [1,3,5,7,8,10,12].contains(monthArray[selectMonth]){
              
             if selectMonth == 0,selectYear == 0 {
                starIndex = startCompo.day ?? 0
             }else if selectMonth >= monthArray.count,selectYear >= yearArray.count {
                endIndex = endCompo.day ?? 0
             }else{
                endIndex = 31
             }
         }else if [4,6,9,11].contains(monthArray[selectMonth]){
          
         /// 小月
            if selectMonth == 0,selectYear == 0 {
                 starIndex = startCompo.day ?? 0
            }else if selectMonth >= monthArray.count,selectYear >= yearArray.count {
                 endIndex = endCompo.day ?? 0
             }else{
                 endIndex = 30
             }
         }else if 2 == monthArray[selectMonth]{
           
             /// 二月
             if selectMonth == 0 {
                  starIndex = startCompo.day ?? 0
             }else if selectMonth + 1 >= monthArray.count {
                  endIndex = endCompo.day ?? 0
             }else{
                 /// 小闰年这就是通常所说的：四年一闰，百年不闰，四百年再闰。 例如，2000年是闰年，2100年则是平年。
                 let year = yearArray[selectYear]
                 if year != 0,year%4 == 0, year%100 != 0 {
                     /// 小闰月
                     endIndex = 29
                 }else if year%400 == 0 {
                     /// 400年大闰月
                   endIndex = 29
                 }else{
                    /// 闰天数
                     endIndex = 28
                 }
             }
         }
         
            var numArray = [Int]()

            for index in starIndex...endIndex{
                numArray.append(index)
            }
            return numArray
        }
     
     /// 数据生成
     func handlerData(start : Int,end : Int) -> [Int]{
            
         var numArray = [Int]()
         
            for index in start...end{
                numArray.append(index)
            }
            return numArray
        }
   
    func getSelectData() -> String {
        var comP = DateComponents.init()
            comP.calendar = Calendar.current

            if mode == .dateAndTime {
                comP.year = yearArray[selectYear]
                comP.month = monthArray[selectMonth]
                comP.day = dayArray [selectday]
                comP.hour = hourArray [selectHour]
                comP.minute = minuteArray[selectminute]
                comP.second = secondArray[selectsecond]

            }else if mode == .date{
               comP.year = yearArray[selectYear]
               comP.month = monthArray[selectMonth]
               comP.day = dayArray [selectday]

            } else if mode == .time{

              comP.hour = hourArray [selectHour]
              comP.minute = minuteArray[selectminute]
              comP.second = secondArray[selectsecond]
            }
        guard let currentDate = comP.date else { return ""  }

        let dataf = DateFormatter.init()
        dataf.dateFormat = formate
        return dataf.string(from: currentDate)
    }
 }
extension YJDatePickerView{
    
    /**
     dateformatter: 时间格试化
     mode : 控件模式
     max  : 最近的时间
     min  : 最远的时间
     select : 介于max > select > min 的时间
     backBlock : 回调
     */
    class func show(dateformatter:String,mode:DetaMode = .dateAndTime,min:TimeInterval? ,max:TimeInterval?,select:TimeInterval?,backBlock:@escaping ((String,TimeInterval )) -> Void) {
        if let max = max ,let min = min, max < min{
            return
        }
        
        let pickV = initDatePickerViewInit()
            pickV.mode = mode
            pickV.backBlock = backBlock
            pickV.formate = dateformatter
        
        pickV.handleInitData(min: min, max: max, select: select)
        
    }
    
    /// 处理初始化数据
  private func handleInitData(min:TimeInterval? ,max:TimeInterval?,select:TimeInterval?){
        if let min = min {
                 startDate = Date.init(timeIntervalSince1970: min )
             }else{
                let zoom = NSTimeZone.system
                let zoomTimerinterval = zoom.secondsFromGMT(for: Date.init())
                startDate = Date.init(timeIntervalSince1970: TimeInterval(-(zoomTimerinterval)))
             }

             if let max = max {
                 endDate = Date.init(timeIntervalSince1970: max )
             }else{
                var dateComponent = dateFormatter.calendar.dateComponents(self.yearSet, from: Date.init())
                 var year = dateComponent.year ?? 0
                 while true {
                     if year % 100 == 0 {
                         break
                     }
                     year = year + 1
                 }
                 dateComponent.year = year
                 dateComponent.month = 12
                 dateComponent.day = 31
                 dateComponent.hour = 23
                 dateComponent.minute = 59
                 dateComponent.second = 59

                 endDate = dateFormatter.calendar.date(from: dateComponent)
             }
        
        /// 不能越界
        if let select = select ,select < 0 {
            return
        }
        
        /// 处理选择
        if let select = select, max == nil,min == nil {
            self.handlePickerSelect(select: select)
        }else if let select = select, let max = max ,min == nil ,max > select {
            self.handlePickerSelect(select: select)
        }else if let select = select, let min = min ,max == nil , select > min {
            self.handlePickerSelect(select: select)
        }else if let select = select, let max = max ,let min = min, max > select,select > min {
            self.handlePickerSelect(select: select)
        }else if select == nil,min == nil,max == nil{
            self.handlePickerSelect(select: Date.init().timeIntervalSince1970)
        }
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {[weak self] in
            self?.handlePickerSelectCellHighlight()
        }
    }
    
 private  class func initDatePickerViewInit() -> YJDatePickerView{
        let view : UIView = UIApplication.shared.keyWindow!
        let pickV = YJDatePickerView.init(frame: UIScreen.main.bounds)
            pickV.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            pickV.addGestureRecognizer(pickV.tapGesture)
            view.addSubview(pickV)
            pickV.contentView.backgroundColor = UIColor.clear
    
            pickV.pickerView.reloadAllComponents()
            pickV.addViewAnimate()
        return pickV
    }
    
  private  func handlePickerSelect(select: TimeInterval) {
       
    self.seleterTime = Date.init(timeIntervalSince1970: select )
    let dateComponent = dateFormatter.calendar.dateComponents(self.yearSet, from: self.seleterTime ?? Date.init())
    
    if mode == .dateAndTime || mode == .date{
        /// 年
        if let year = dateComponent.year, yearArray.contains(year) == true {
            for indes in 0..<yearArray.count {
                if yearArray[indes] == year {
                    selectYear = indes
                    pickerView.reloadComponent(1)
                    pickerView.selectRow(indes, inComponent: 0, animated: true)
                }
            }
        }
        
        /// 月
        if let month = dateComponent.month, monthArray.contains(month) == true {
            for indes in 0..<monthArray.count {
                if monthArray[indes] == month {
                    selectMonth = indes
                    pickerView.reloadComponent(2)
                    pickerView.selectRow(indes, inComponent: 1, animated: true)
                }
            }
        }
    }
    
        /// 日
        if let day = dateComponent.day, dayArray.contains(day) == true {
            for indes in 0..<dayArray.count {
                if dayArray[indes] == day {
                    selectday = indes
                    if mode == .dateAndTime || mode == .time{
                        pickerView.reloadComponent(3)
                    }
                    pickerView.selectRow(indes, inComponent: 2, animated: true)
                }
            }
        }
      if mode == .dateAndTime || mode == .time{
        /// 时
        if let hour = dateComponent.hour, hourArray.contains(hour) == true {
            for indes in 0..<hourArray.count {
                if hourArray[indes] == hour {
                    selectHour = indes
                    if mode == .time {
                         pickerView.reloadComponent(1)
                         pickerView.selectRow(indes, inComponent: 0, animated: true)
                    }else{
                         pickerView.reloadComponent(4)
                         pickerView.selectRow(indes, inComponent: 3, animated: true)
                    }
                }
            }
        }
        
        /// 分
        if let minute = dateComponent.minute, minuteArray.contains(minute) == true {
            for indes in 0..<minuteArray.count {
                if minuteArray[indes] == minute {
                    selectminute = indes
                     if mode == .time {
                        pickerView.reloadComponent(2)
                         pickerView.selectRow(indes, inComponent: 1, animated: true)
                     }else{
                        pickerView.reloadComponent(5)
                         pickerView.selectRow(indes, inComponent: 4, animated: true)
                    }
                }
            }
        }
        
        /// 秒
        if let second = dateComponent.second, secondArray.contains(second) == true {
            for indes in 0..<secondArray.count {
                if secondArray[indes] == second {
                    selectsecond = indes
                     if mode == .time {
                        pickerView.selectRow(indes, inComponent: 2, animated: true)
                     }else{
                        pickerView.selectRow(indes, inComponent: 5, animated: true)
                    }
                }
            }
        }
    }
}
    
    @objc private  func handlePickerSelectCellHighlight() {
        if mode == .dateAndTime {
            if let view = pickerView.view(forRow: selectYear, forComponent: 0),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
            }
            if let view = pickerView.view(forRow: selectMonth, forComponent: 1),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
            }
            if let view = pickerView.view(forRow: selectday, forComponent: 2),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
            }
            if let view = pickerView.view(forRow: selectHour, forComponent: 3),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
            }
            if let view = pickerView.view(forRow: selectminute, forComponent: 4),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
            }
            if let view = pickerView.view(forRow: selectsecond, forComponent: 5),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
            }
        }else if mode == .date{
            if let view = pickerView.view(forRow: selectYear, forComponent: 0),let cell = view as? YJPickerCell {
                cell.select(isSelect: true)
           }
           if let view = pickerView.view(forRow: selectMonth, forComponent: 1),let cell = view as? YJPickerCell {
               cell.select(isSelect: true)
           }
           if let view = pickerView.view(forRow: selectday, forComponent: 2),let cell = view as? YJPickerCell {
               cell.select(isSelect: true)
           }
        }else{
          if let view = pickerView.view(forRow: selectHour, forComponent: 0),let cell = view as? YJPickerCell {
              cell.select(isSelect: true)
          }
          if let view = pickerView.view(forRow: selectminute, forComponent: 1),let cell = view as? YJPickerCell {
              cell.select(isSelect: true)
          }
          if let view = pickerView.view(forRow: selectsecond, forComponent: 2),let cell = view as? YJPickerCell {
              cell.select(isSelect: true)
          }

        }
    }
    
    @objc func tapGestureAction(tap : UITapGestureRecognizer) {
      
        let touchView = tap.view
        let touchPoint = tap.location(ofTouch: 0, in: touchView)
       
        if touchPoint.y >= (self.frame.size.height - contentView.frame.size.height) {
            return
        }

        removeView()
    }
    
    
    @objc func cancelBtnAction() {
        removeView()
    }
    
    
    @objc func rightBtnAction() {
        if let backBlock = backBlock {
            backBlock(getPickerValue())
            self.backBlock = nil
        }
        removeView()
    }
    
 private func getPickerValue() -> (String ,TimeInterval) {
     let clendar = Calendar.current
     var currentCom = DateComponents.init()
     
     if mode == .dateAndTime {
        let year =  yearArray[selectYear]
        let month = monthArray[selectMonth]
        let day =  dayArray[selectday]
        let hour =  hourArray[selectHour]
        let minute =  minuteArray[selectminute]
        let second =  secondArray[selectsecond]
         
         currentCom.setValue(year, for: .year)
         currentCom.setValue(month, for: .month)
         currentCom.setValue(day, for: .day)
         currentCom.setValue(hour, for: .hour)
         currentCom.setValue(minute, for: .minute)
         currentCom.setValue(second, for: .second)
     }else if mode == .date{
         let year =  yearArray[selectYear]
         let month = monthArray[selectMonth]
         let day =  dayArray[selectday]
         
         currentCom.setValue(year, for: .year)
         currentCom.setValue(month, for: .month)
         currentCom.setValue(day, for: .day)
     } else if mode == .time{
         let hour =  hourArray[selectHour]
         let minute =  minuteArray[selectminute]
         let second =  secondArray[selectsecond]
         
         currentCom.setValue(hour, for: .hour)
         currentCom.setValue(minute, for: .minute)
         currentCom.setValue(second, for: .second)
     }
     
     let selectDate = clendar.date(from: currentCom)
     let forma = DateFormatter.init()
         forma.dateFormat = formate
     
     let dateStr = forma.string(from: selectDate!)
     
     var interval : TimeInterval = 0
       
     if mode == .date || mode == .dateAndTime{
         interval = selectDate?.timeIntervalSince1970 ?? 0
     }else if mode == .time {
         let hour = (currentCom.hour ?? 0) * 60
         let minute = (currentCom.minute ?? 0) * 60
         let second = currentCom.second ?? 0

       interval = TimeInterval(hour * minute + second)
     }
     
     print("selectDate\(selectDate)  dateStr \(dateStr)")
     
     return (dateStr,interval)
    }
    
    /// 移除
  private  func removeView() {
        UIView.animate(withDuration: 0.25, animations: {
            let frame = self.contentView.frame
            self.contentView.frame = CGRect.init(x: 0, y: self.frame.size.height, width: frame.size.width, height: frame.size.height)
            self.backgroundColor = UIColor.clear
        }) { (bool) in
            self.pickerView.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
  private  func addViewAnimate() {
        let animate = CABasicAnimation.init()
        animate.keyPath = "position"
        
        animate.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: self.frame.size.height))
        animate.toValue = NSValue.init(cgPoint: CGPoint.init(x: 0, y: self.frame.size.height - self.contentView.frame.size.height))
        animate.duration = 0.3
        contentView.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
        contentView.layer.position = CGPoint.init(x: 0, y: self.frame.size.height - self.contentView.frame.size.height)
        contentView.layer.add(animate, forKey: nil)
    }
}


     

