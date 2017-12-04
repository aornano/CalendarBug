//
//
//  CalendarBug
//
//  Created by Swift on 25.11.2017.
//  Copyright © 2017 Swift. All rights reserved.
//


import UIKit
import Foundation
import JTAppleCalendar

class ViewController: UIViewController, UIGestureRecognizerDelegate  {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var infos: UILabel!
    
    
    let months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December" ]
    let kStartDate = "2016-01-01"
    let kEndDate = "2049-12-31"
    var numberOfRows = 6
    let formatter = DateFormatter()
    var myCalendar = Calendar(identifier: .gregorian)
    var generateInDates: InDateCellGeneration = .forFirstMonthOnly
    var generateOutDates: OutDateCellGeneration = .off
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .monday
    var monthSize: MonthSize? = nil
    
    
    let dates = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December" ]
    
    
    
    let datas = [
        "2017-11-18*1",
        "2017-11-18*1",
        "2017-11-18*2",
        "2017-11-23*1",
        "2017-11-23*2",
        "2017-11-23*3",
        "2017-11-23*1",
        "2017-11-21*1",
        "2017-11-21*2",
        "2017-11-21*1",
        "2017-11-21*2",
        "2017-10-16*3",
        "2017-10-16*4",
        "2017-10-17*1",
        "2017-10-17*1",
        "2017-10-17*2",
        "2017-10-19*1",
        "2017-10-19*2",
        "2017-10-19*3",
        "2017-10-19*1",
        "2017-11-21*1",
        "2017-11-21*2",
        "2017-11-21*1",
        "2017-11-21*2",
        "2017-10-16*3",
        "2017-10-16*4",
        "2017-10-16*1" ]
    
    
    var tags = [UILabel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let swipeGestureL = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeGestureL.direction = .left
        swipeGestureL.delegate = self
        self.calendarView.addGestureRecognizer(swipeGestureL)
        
        let swipeGestureR = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeGestureR.direction = .right
        swipeGestureR.delegate = self
        self.calendarView.addGestureRecognizer(swipeGestureR)
        
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "tr_TR")
        
        
        self.calendarView.selectDates([NSDate() as Date])
        self.calendarView.scrollToDate(NSDate() as Date, animateScroll: true)
        self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        })
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    @IBAction func prev(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    @IBAction func today(_ sender: Any) {
        self.calendarView.selectDates([NSDate() as Date])
        self.calendarView.scrollToDate(NSDate() as Date, animateScroll: true)
        self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        })
    }
    
    
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        print (sender.direction)
        if sender.direction == .right {
            self.prev(UIButton())
        } else if sender.direction == .left {
            self.next(UIButton())
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = myCalendar.dateComponents([.month], from: startDate).month!
        let monthName = months[(month-1) % 12]
        let year = myCalendar.component(.year, from: startDate)
        infos.text = monthName + " " + String(year)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CellView  else {
            return
        }
        
        
        cell.dayLabel.text = cellState.text
        
        
        
        
        if cellState.isSelected {
            cell.dayLabel.textColor = UIColor.white
        } else {
            
            
            if cellState.dateBelongsTo == .thisMonth {
                if myCalendar.isDateInToday(cellState.date) {
                    cell.dayLabel.textColor = UIColor.red
                } else {
                    cell.dayLabel.textColor = UIColor.black
                }
            } else {
                cell.dayLabel.textColor = UIColor.init(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
            }
        }
    }
    
    @objc func tap(_ sender:UIGestureRecognizer)
    {
        let label = (sender.view as! UILabel)
        print("\(label.text!) id = \(label.tag)")
       
    }
    
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CellView else {return }
        if cellState.isSelected {
            
            cell.dayLabel.textColor = UIColor.white
            cell.selectedView.layer.cornerRadius =  cell.selectedView.frame.size.width / 2
            cell.selectedView.isHidden = false
            if myCalendar.isDateInToday(cellState.date) {
                cell.selectedView.backgroundColor = UIColor.red
            } else {
                cell.selectedView.backgroundColor = UIColor.black
            }
        } else {
            cell.selectedView.isHidden = true
        }
        
        cell.selectedView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 0.5,
            delay: 0, usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.1,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                cell.selectedView.transform = CGAffineTransform(scaleX: 1, y: 1)
        },
            completion: nil
        )
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        var cell = cell as! CellView
        cell = sharedFunctionToConfigureCell(cell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        var cell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        cell = sharedFunctionToConfigureCell(cell: cell, cellState: cellState, date: date)
        return cell
    }
    
    func sharedFunctionToConfigureCell(cell: CellView, cellState: CellState, date: Date)-> CellView {
        var currentdate = String(describing: myCalendar.date(byAdding: .day, value: 1, to: cellState.date))
        currentdate = currentdate.substring(from: 9, length: 10)
        cell.tagList.tags.removeAll()
        cell.tagList.hide()
        cell.contentView.backgroundColor = nil
        cell.tagList.alpha = 0
        cell.tagList.numberOfRows = 0
        cell.tagList.backgroundColor = UIColor.clear
        cell.tagList.isHidden = true
        var i : Int
        i = 0
        for object in datas {
            i =  i + 1
            let clean = "\(object)".components(separatedBy: "*")
            if clean[0] == currentdate {
                let gotag : Int
                gotag = Int(clean[1])!
                cell.tagList.isHidden = false
                cell.dayLabel.text = cellState.text
                cell.contentView.backgroundColor = UIColor.gray
                let itemName = "Item name  \(i)"
                cell.tagList.alpha = 1
                if clean[1] == "1" {
                    cell.tagList.addTag(itemName, target: self, tapAction: #selector(ViewController.tap(_:)), longPressAction: #selector(ViewController.tap(_:)),backgroundColor: UIColor.orange,textColor: UIColor.white,comesTag: gotag)
                }else if clean[1] == "2" {
                    cell.tagList.addTag(itemName, target: self, tapAction: #selector(ViewController.tap(_:)), longPressAction: #selector(ViewController.tap(_:)),backgroundColor: UIColor.green,textColor: UIColor.white,comesTag: gotag)
                }else if clean[1] == "3" {
                    cell.tagList.addTag(itemName, target: self, tapAction: #selector(ViewController.tap(_:)), longPressAction: #selector(ViewController.tap(_:)),backgroundColor: UIColor.brown,textColor: UIColor.white,comesTag: gotag)
                }else if clean[1] == "4" {
                    cell.tagList.addTag(itemName, target: self, tapAction: #selector(ViewController.tap(_:)), longPressAction: #selector(ViewController.tap(_:)),backgroundColor: UIColor.black,textColor: UIColor.white,comesTag: gotag)
                }
            }else{
                cell.tagList.backgroundColor = UIColor.clear
            }
        }
        handleCellConfiguration(cell: cell, cellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "tr_TR")
        
        let startDate = formatter.date(from: kStartDate)!
        let endDate = formatter.date(from: kEndDate)!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: myCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("Clicked Tarih = \(formatter.string(from: date))")
     
     
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        let visibleDates = calendarView.visibleDates()
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return monthSize
    }
    
    
    
}


extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return self[startIndex ..< endIndex]
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
}



