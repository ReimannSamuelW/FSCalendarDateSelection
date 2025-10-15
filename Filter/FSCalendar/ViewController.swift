//
//  ViewController.swift
//  Filter
//
//  Created by Reimann on 30/11/22.
//

import FSCalendar
import UIKit

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet private weak var fsCalendarView: FSCalendar!
    @IBOutlet weak var selectYearButton: UIButton!
    let picker = UIDatePicker()
    var formatter  = DateFormatter()
    var newArr = [String]()
    
    private let calendar = DateHelper.shared.calendar
    private var datesRangeArray: [Date]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCalendar()
        self.fsCalendarView.reloadData()

    }
    
    private func setupCalendar() {
        fsCalendarView.dataSource = self
        fsCalendarView.delegate = self
        fsCalendarView.register(CalendarCell.self,forCellReuseIdentifier: "CalendarCell")
        // Appearance
        fsCalendarView.appearance.titleOffset = CGPoint(x: 0.0, y: 2.5)
        formatter.dateFormat = "MMMM yyyy"
        let date = Date()
        selectYearButton.setTitle(formatter.string(from: date), for: .normal)
        // Customizations
        fsCalendarView.calendarHeaderView.isHidden = false
        fsCalendarView.placeholderType = .none
        fsCalendarView.scrollDirection = .vertical
        picker.isHidden = false
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("changed")
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        let monthName = DateFormatter().monthSymbols[month - 1].capitalized
        
        let year = Calendar.current.component(.year, from: currentPageDate)
        print(monthName)
        selectYearButton.setTitle("\(monthName) \(year)", for: .normal)
        self.fsCalendarView.reloadData()

    }
    
    // FSCalendarDataSource
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: "CalendarCell",
            for: date,
            at: position
        )
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureCell(cell, for: date, at: monthPosition)
    }
    
    
    private func configureCell(_ cell: FSCalendarCell?, for date: Date?, at position: FSCalendarMonthPosition) {
        guard let cell = cell as? CalendarCell else { return }
        var selectionType = SelectionType.none
        
        guard let index = fsCalendarView.calculator.indexPath(for: date) else {return}

        if let date = date,
           let cellCalendar = cell.calendar,
           cellCalendar.selectedDates.contains(where: { $0.isEqual(date: date, toGranularity: .day) }),
           let previousDate = self.calendar.date(byAdding: .day, value: -1, to: date),
           let nextDate = self.calendar.date(byAdding: .day, value: 1, to: date) {
            
            if cellCalendar.selectedDates.contains(previousDate) && cellCalendar.selectedDates.contains(nextDate) {
                if index.row == 6 || index.row == 13 || index.row == 20 ||  index.row == 27{
                    selectionType = .rightCorner
                }
                else if index.row == 7 || index.row == 14 || index.row == 21 || index.row == 28{
                    selectionType = .leftCorner
                }
//                else  if fsCalendarView.currentPage.isSameDate(date){
//                    selectionType = .leftCorner
//                }
//                else if fsCalendarView.currentPage.isSameDate(date) && index.row == 6{
//                    selectionType = .leftCorner
//                }
//                else if index.row == 6{
//                    selectionType = .rightCorner
//                }
                else {
                  selectionType = .middle
                }
//                selectionType = .middle
            }
            
            else if cellCalendar.selectedDates.contains(previousDate) && cellCalendar.selectedDates.contains(date) {
                selectionType = .rightBorder
            }
            else if cellCalendar.selectedDates.contains(nextDate) {
                selectionType = .leftBorder
            }
            else {
                selectionType = .single
            }
        }
        else if let date = date, date.isEqual() {
            selectionType = .today
        }
        else {
            selectionType = .none
        }
        cell.selectionType = selectionType
        if date == startDate || date == selectedDateArray.last{
            cell.titleLabel.textColor = .white
        }
        else {
            cell.titleLabel.textColor = .black
        }
        if let date = date, date.isEqual()  &&  (self.fsCalendarView.selectedDates.contains(date) == false){
            cell.titleLabel.textColor = .white
        }
        
    }
    
    
    var selectedDateArray: [Date] = [] {
        didSet {
            // sort the array
            selectedDateArray = fsCalendarView.selectedDates.sorted()
            
            switch selectedDateArray.count {
            case 0:
                startDate = nil
                endDate = nil
            case 1:
                startDate = selectedDateArray.first
                endDate = nil
            case _ where selectedDateArray.count > 1:
                startDate = selectedDateArray.first
                endDate = selectedDateArray.last
                
                var nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
                while nextDay!.startOfDay <= endDate! {
                    fsCalendarView.select(nextDay)
                    nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)
                }
            default:
                return
            }
        }
    }
    
    var startDate: Date? {
        didSet {
            startDate = startDate?.startOfDay
        }
    }
    
    var endDate: Date? {
        didSet {
            endDate = endDate?.endOfDay
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.select(date)
        selectedDateArray.append(date)
        //selectionColor
        fsCalendarView.visibleCells().forEach { (cell) in
            let date = fsCalendarView.date(for: cell)
            let position = fsCalendarView.monthPosition(for: cell)
            configureCell(cell, for: date, at: position)
        }
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 0 {
            let datesToDeselect: [Date] = calendar.selectedDates.filter{ $0 > date }
            datesToDeselect.forEach{ calendar.deselect($0) }
            calendar.select(date) // adds back the end date that was just deselected so it matches selectedDateArray
        }
        selectedDateArray = selectedDateArray.filter{ $0 < date }
        selectedDateArray.forEach{fsCalendarView.select($0)}
        //DeSelectionColor
        fsCalendarView.visibleCells().forEach { (cell) in
            let date = fsCalendarView.date(for: cell)
            let position = fsCalendarView.monthPosition(for: cell)
            configureCell(cell, for: date, at: position)
        }
    }
    
    @IBAction func onYearButtonTapped(_ sender: Any) {
        picker.isHidden = false
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.preferredDatePickerStyle = .automatic
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: UIControl.Event.valueChanged)
        let pickerSize : CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x:0, y: 280, width:pickerSize.width, height:460)
        self.view.addSubview(picker)
    }
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        selectYearButton.setTitle(dateFormatter.string(from: sender.date), for: .normal)
        let date = dateFormatter.string(from: sender.date)
        fsCalendarView.setCurrentPage(dateFormatter.date(from: date)!, animated: true)
        picker.isHidden = true
    }
}

extension Date {
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
