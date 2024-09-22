//
//  ViewController.swift
//  MultipleSelectionCalendar
//
//  Created by Mark on 2024/9/22.
//

import UIKit
import SnapKit
import FSCalendar

class ViewController: UIViewController {
    
    internal var calendar: FSCalendar = FSCalendar()
    private var isDoneSelected: Bool = false
    private let currentCalendar = Calendar.current
    private var selectedDates: [Date] = [] {
        didSet {
            sendButton.isEnabled = selectedDates.isEmpty ? false : true
            sendButton.alpha = selectedDates.isEmpty ? 0.5 : 1
        }
    }
    
    //MARK: - Views
    let calenderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .blue
        return button
    }()
    
    let selectDatesTitle: UILabel = {
        let label = UILabel()
        label.text = "Selected Dates:"
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayouts()
        initClickEvent()
        initView()
    }
    
    //MARK: - Functions
    private func initLayouts() {
        
        view.addSubview(calenderView)
        calenderView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.leading.trailing.equalTo(view).inset(20)
            make.height.equalTo(350)
        }
        
        calenderView.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(calenderView)
            make.height.equalTo(300)
        }
        
        calenderView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(calenderView)
            make.top.equalTo(calendar.snp.bottom)
            make.height.equalTo(1)
        }
        
        calenderView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(separatorView)
            make.top.equalTo(separatorView.snp.bottom)
            make.height.equalTo(50)
        }
        
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.leading.equalTo(calendar.calendarHeaderView).offset(15)
            make.width.height.equalTo(20)
        }
        
        view.addSubview(forwardButton)
        view.bringSubviewToFront(forwardButton)
        forwardButton.snp.makeConstraints { make in
            make.centerY.equalTo(calendar.calendarHeaderView)
            make.trailing.equalTo(calendar.calendarHeaderView).offset(-15)
            make.width.height.equalTo(20)
        }
        
        view.addSubview(selectDatesTitle)
        selectDatesTitle.snp.makeConstraints { make in
            make.bottom.equalTo(calenderView.snp.top).offset(-50)
            make.leading.equalTo(view)
        }
        
        view.addSubview(selectedDateLabel)
        selectedDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(selectDatesTitle)
            make.leading.equalTo(selectDatesTitle.snp.trailing).offset(20)
            make.trailing.equalTo(view)
        }
        
    }
    
    private func initCalendarView() {
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = .white
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerDateFormat = "MMM yyyy"
        calendar.appearance.weekdayTextColor = .blue
        calendar.appearance.headerTitleColor = .blue
        calendar.appearance.selectionColor = .blue
        calendar.appearance.todayColor = .white
        calendar.appearance.caseOptions = .headerUsesCapitalized
        calendar.appearance.titleTodayColor = .black
        
        // 設置日曆背景為白色
        calendar.backgroundColor = .white

        // 隱藏月份標題旁邊的淡化月份，將它們的透明度設為0
        calendar.appearance.headerMinimumDissolvedAlpha = 0

        // 設置日曆標題的日期格式為 "MMM yyyy"，例如 "Sep 2024"
        calendar.appearance.headerDateFormat = "MMM yyyy"

        // 設置日曆上週一至週日的文字顏色為藍色
        calendar.appearance.weekdayTextColor = .blue

        // 設置日曆標題（例如 "Sep 2024"）的文字顏色為藍色
        calendar.appearance.headerTitleColor = .blue

        // 設置選中日期的背景顏色為藍色
        calendar.appearance.selectionColor = .blue

        // 設置今天的日期背景顏色為白色
        calendar.appearance.todayColor = .white

        // 設置日曆的標題使用大寫字母
        calendar.appearance.caseOptions = .headerUsesCapitalized

        // 設置今天日期的文字顏色為黑色
        calendar.appearance.titleTodayColor = .black
        
    }
    
    /// 初始化日曆
    /// - Parameters:
    ///   - multipleSelection: 是否可多選
    func initView(multipleSelection: Bool = true) {
        
        view.backgroundColor = .black
        
        calendar.allowsMultipleSelection = multipleSelection
        
        initCalendarView()
        
    }
    
    private func initClickEvent() {
        
        sendButton.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        
        forwardButton.addTarget(self, action: #selector(forwardButtonDidTap), for: .touchUpInside)
        
    }
    
    @objc func sendButtonDidTap() {
        
        guard !selectedDates.isEmpty else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.ReferenceType.local
        
        let startDate = formatter.string(from: selectedDates.first!)
        let endDate = formatter.string(from: selectedDates.last!)
        
        selectedDateLabel.text = startDate + " - " + endDate
        
    }
    
    @objc func backButtonDidTap() {
        
        if let lastMonth = currentCalendar.date(byAdding: .month, value: -1, to: calendar.currentPage) {
            calendar.setCurrentPage(lastMonth, animated: true)
        }
        
    }
    
    @objc func forwardButtonDidTap() {
        
        if let nextMonth = currentCalendar.date(byAdding: .month, value: 1, to: calendar.currentPage) {
            calendar.setCurrentPage(nextMonth, animated: true)
        }
        
    }
    
    /// 將選擇的兩個日期之間的日期也變成選擇狀態
    func selectDaysBetweenTwoDays() {
        
        if selectedDates.count != 2 { return }
        
        if let startDate = selectedDates.first, let endDate = selectedDates.last {
            
            var currentDate = startDate
            //選擇起訖日中間的日期
            while currentDate <= endDate {
                // 增加一天
                self.calendar.select(currentDate)
                currentDate = currentCalendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            selectedDates.sort()
            self.isDoneSelected = true
        }
        
    }


}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if self.isDoneSelected {
            
            let allSelectedDates = calendar.selectedDates
            
            selectedDates.removeAll()
            self.isDoneSelected = false
            
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                
                guard let wSelf = self else {return}

                for date in allSelectedDates {
                    calendar.deselect(date)
                }
                
                calendar.select(date)
                wSelf.selectedDates.append(date)
            }
            
            return
        }
        
        selectedDates.append(date)
        selectedDates.sort()
        
        selectDaysBetweenTwoDays()
        
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if self.isDoneSelected {
            
            let selected = calendar.selectedDates
            
            for date in selected {
                calendar.deselect(date)
            }
            selectedDates.removeAll()
            self.isDoneSelected = false
            
            return
        }
        
        self.selectedDates.removeAll()
        
    }

}
