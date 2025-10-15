//
//  FSCalenderView.swift
//  Filter
//
//  Created by Reimann on 05/12/22.
//

import UIKit
import FSCalendar

class FSCalenderView: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
   
    var  calendar: FSCalendar!
    var formatter  = DateFormatter()
    private var datesRange: [Date]?
    let label = UILabel()
    let picker = UIDatePicker()

    @IBOutlet weak var changeYearBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 100.0, width: self.view.frame.width, height: self.view.frame.height))
        calendar.scrollDirection = .vertical
        self.view.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        formatter.dateFormat = "MMMM yyyy"
        picker.isHidden = true
      
    }

 
    func datesRange(from: Date, to: Date) -> [Date] {
            if from > to { return [Date]() }
            var tempDate = from
            var array = [tempDate]
            while tempDate < to {
                tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
                array.append(tempDate)
            }
            return array
        }
    
    
    @IBAction func onChangeYearTapped(_ sender: Any) {
//        calendar.setCurrentPage(formatter.date(from: "March 1998")!, animated: true)
        picker.isHidden = false
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.preferredDatePickerStyle = .automatic
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0, y: -150, width:pickerSize.width, height:460)
            // you probably don't want to 10 background color as black
            // picker.backgroundColor = UIColor.blackColor()
            self.view.addSubview(picker)
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        //    calendar.setCurrentPage(formatter.date(from: "March 1998")!, animated: true)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        changeYearBtn.setTitle(dateFormatter.string(from: sender.date), for: .normal)
        let date = dateFormatter.string(from: sender.date)
        calendar.setCurrentPage(dateFormatter.date(from: date)!, animated: true)

    }
    
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        performDateDeselect(calendar, date: date)
        return true
    }
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        performDateSelection(calendar)
    }
    
    private func performDateDeselect(_ calendar: FSCalendar, date: Date) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let index = sorted.firstIndex(of: date)  {
             datesRange = Array(sorted[index...])
                for date in datesRange!{
                    calendar.deselect(date)
                }
        }
    }
    
    private func performDateSelection(_ calendar: FSCalendar) {
        let sorted = calendar.selectedDates.sorted { $0 < $1 }
        if let firstDate = sorted.first, let lastDate = sorted.last {
            datesRange = datesRange(from: firstDate, to: lastDate)
            for date in datesRange!{
                calendar.select(date)
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
            //where startDate and endDate make the range of dates
        if date > calendar.selectedDates.first ?? Date.now, date < calendar.selectedDates.last ?? Date.now {
                return .green
            } else {
                return nil
            }
    }
   
}

