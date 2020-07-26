//
//  YJPickerCell.swift
//  text
//
//  Created by summer on 2019/12/20.
//  Copyright © 2019 summer. All rights reserved.
//

import UIKit

class YJPickerCell: UIView {

    @IBOutlet weak var titleLB: UILabel!
    
    
  static var cell : YJPickerCell{
        if let view =  Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first ,let cell = view as? YJPickerCell{
            return cell
        }else{
            return YJPickerCell.init()
        }
    }
    
    func select(isSelect :Bool) {
        if isSelect == true {
            titleLB.textColor = UIColor.green
        }else{
           titleLB.textColor = UIColor.gray
        }
    }
    
    func title(model:UIDatePicker.Mode,component:Int,title:String) {
        
        select(isSelect:  false)
        
        if model == .date || model == .dateAndTime {
            switch component {
            case 0:
                titleLB.text = "\(title)年"
            case 1:
                titleLB.text = "\(title)月"
            case 2:
                titleLB.text = "\(title)日"
            case 3:
                titleLB.text = "\(title)时"
            case 4:
                titleLB.text = "\(title)分"
            case 5:
                titleLB.text = "\(title)秒"
            default:break

            }
            
        }else if model == .time {
            switch component {
            case 0:
                titleLB.text = "\(title)时"
            case 1:
                titleLB.text = "\(title)分"
            case 2:
                titleLB.text = "\(title)秒"
            default:break
            }
        }
    }
}
