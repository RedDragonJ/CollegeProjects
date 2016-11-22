//
//  ExportViewController.swift
//  FamilyOrganizer
//
//  Created by James Sun on 6/15/16.
//  Copyright © 2016 Sevenlogics. All rights reserved.
//

import UIKit

class ExportViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, DatePickerViewDelegate
{
    //sections tags
    let SECTION_SEG_TAG = "SECTION_SEG_TAG"
    let SECTION_ENTRY_TAG = "SECTION_ENTRY_TAG"
    
    //section row tags
    let ROW_DATE_FROM_TAG = "ROW_DATE_FROM_TAG"
    let ROW_DATE_TO_TAG = "ROW_DATE_TO_TAG"
    let ROW_ENTRY_TAG = "ROW_ENTRY_TAG"
    let ROW_ENTRY_CALENDAR_TAG = "ROW_ENTRY_CALENDAR_TAG"
    let ROW_ENTRY_TODO_TAG = "ROW_ENTRY_TODO_TAG"
    let ROW_ENTRY_JOURNAL_TAG = "ROW_ENTRY_JOURNAL_TAG"
    let ROW_ENTRY_STICKY_TAG = "ROW_ENTRY_STICKY_TAG"
    let ROW_BUTTON_TAG = "ROW_BUTTON_TAG"
    
    //switches tag
    let CALENDAR_SWITCH_TAG = 1
    let TODO_SWITCH_TAG = 2
    let STICKY_SWITCH_TAG = 3
    let JOURNAL_SWITCH_TAG = 4
    
    //data tags
    let EXPORT_FORMAT_TAG = "exportformat"
    let START_DATE_TAG = "From"
    let END_DATE_TAG = "To"
    let START_DATE_PICKER_TAG = 1
    let END_DATE_PICKER_TAG = 2
    let NUM_OF_ROWS = 5
    let FROM = NSLocalizedString("From", comment: "From")
    let TO = NSLocalizedString("To", comment: "To")
    let ADDED_SECONDS_FOR_END_DATE = 60.0
    
    //alert stuff
    let START_DATE_NO_LATER_THAN_END_DATE = NSLocalizedString("End date must be later than start date", comment: "End date must be later than start date")
    let ENTRY_TYPE_SELECTION_TITLE = NSLocalizedString("Please select at least one entry type.", comment: "Please select at least one entry type.")
    let REPORT_LOADING_ALERT = NSLocalizedString("Creating report...", comment: "Creating report...")
    let EXCEPTION_TITLE = NSLocalizedString("Oops", comment: "Oops")
    let EXCEPTION_DESCRIPTION = NSLocalizedString("There was a problem exporting your data. Please try again or contact us. (More > Send Us Feedback)", comment: "There was a problem exporting your data. Please try again or contact us. (More > Send Us Feedback)")
    //report title
    let REPORT_TITLE_FROM = NSLocalizedString("Family's report from", comment: "Family's report from")
    let REPORT_TITLE_TO = NSLocalizedString("to", comment: "to")
    //data alert
    let NO_DATA_TITLE = NSLocalizedString("No Data", comment: "No Data")
    let NO_DATA_DESCRIPTION = NSLocalizedString("There is no data for the date range and entry types that you selected.", comment: "There is no data for the date range and entry types that you selected.")
    
    //HTML stuff
    let HTML_DATA_TABLE_CALENDAR_START_TAG = "<table width=800 border=0>"
    let HTML_DATA_TABLE_TODO_START_TAG = "<table width=800 border=0>"
    let HTML_DATA_TABLE_JOURNAL_START_TAG = "<table width=800 border=0>"
    let HTML_DATA_TABLE_STICKY_START_TAG = "<table width=800 border=0>"
    let HTML_DATA_TABLE_END_TAG = "</table><br><br>"
    
    let HTML_DATA_HEADER_FORMAT = "<h2 %@>%@</h2><br>"
    let HTML_TITLE_STYLE = "style=\"display:inline\""
    
    let HTML_SCHEDULE_TITLE_FORMAT = "<tr style=\"cellspacing=20\"><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td></tr><br>"
    let HTML_SCHEDULE_TEXT_FORMAT = "<tr style=\"font-size:10pt;cellspacing=20\"><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>"
    //html for todo
    let HTML_TODO_TITLE_FORMAT = "<tr style=\"cellspacing=20\"><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td><br>"
    let HTML_TODO_TEXT_FORMAT = "<tr style=\"font-size:10pt;cellspacing=20\"><td>%@&nbsp&nbsp&nbsp%@</td><td>%@</td><td>%@</td>"
    //html for journal
    let HTML_JOURNAL_TITLE_FORMAT = "<tr style=\"cellspacing=20\"><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td></tr><br>"
    let HTML_JOURNAL_TEXT_FORMAT = "<tr style=\"font-size:10pt;cellspacing=20\"><td>%@&nbsp&nbsp&nbsp%@</td><td>%@</td></tr>"
    //html for sticky
    let HTML_STICKY_TITLE_FORMAT = "<tr style=\"cellspacing=20\"><td><h3 style=\"display:inline\">%@</h3></td><td><h3 style=\"display:inline\">%@</h3></td></tr><br>"
    let HTML_STICKY_TEXT_FORMAT = "<tr style=\"font-size:10pt;cellspacing=20\"><td>%@</td><td>%@</td></tr>"
    
    
    //CSV stuff
    let CSV_DELIMITER = ","
    let CSV_LINE_BREAK = "\n"
    
    
    //export dates
    var startDate:NSDate!
    var endDate:NSDate!
    var ekEvents:NSArray!
    
    //table section stuff
    var tableSections = NSMutableArray()
    var exportFormatSection:TableViewSection!
    var exportDateSection:TableViewSection!
    var exportSwitchSection:TableViewSection!
    var buttonSection:TableViewSection!
    
    //user setting
    let userSettings = AppDelegate.sharedInstance().userInfos
    
    @IBOutlet weak var registeredTableView:UITableView?
    @IBOutlet weak var exportButton:UIButton?
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //register cells
        self.registeredTableView!.registerNib(UINib(nibName: "ExportTableViewCell", bundle: nil), forCellReuseIdentifier: "ExportTableViewCellID")
        self.registeredTableView!.registerNib(UINib(nibName: "ScheduleDetailSegControlCell", bundle: nil), forCellReuseIdentifier: "ScheduleDetailSegControlCellID")
        self.registeredTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellButtonID")
        
        self.setDate()
        self.buildTableSections()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        self.navigationController?.navigationBar.barTintColor = SETTINGS_BASE_COLOR
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        print("leaving export view - save data to user default, it will be save again to make sure everything saved when terminate app")
        self.userSettings!.synchronize()
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("deinit ExportViewController")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- DateStuff
    func setDate() -> Void
    {
        //date may need adjust and change
        if (self.endDate == nil)
        {
            self.endDate = DateUtil.date(DateUtil.date(DateUtil.dateWithNoSeconds(NSDate()), addTimeInterval: ADDED_SECONDS_FOR_END_DATE), addDays: 13)
        }
        
        if (self.startDate == nil)
        {
            self.startDate = DateUtil.date(DateUtil.date(self.endDate, addTimeInterval: -ADDED_SECONDS_FOR_END_DATE), addDays: -13)
        }
    }
    
    //MARK: - IBAction
    @IBAction func doneAction(sender:UIButton?)
    {
        if (!(self.userSettings!.objectForKey("calendarSwitch")!.boolValue! || self.userSettings!.objectForKey("todoSwitch")!.boolValue! || self.userSettings!.objectForKey("stickySwitch")!.boolValue! || self.userSettings!.objectForKey("journalSwitch")!.boolValue!))
        {
            AlertViewHelper.alertOkMsgWithTitle(ENTRY_TYPE_SELECTION_TITLE, message: "")
        }
        else
        {
            //popover view here
//            ModalPopoverViewController.sharedInstance().presentModalLoadingPopoverInView(AppDelegate.sharedInstance().window, loadingText: REPORT_LOADING_ALERT)
            
            AppDelegate.sharedInstance().presentSyncStatusView(REPORT_LOADING_ALERT, completionClosure: { 
                
            })
            
            self.performSelector(#selector(createReport), withObject:nil, afterDelay:0.5)
        }
    }
    
    @IBAction func switchToggled(sender:UISwitch)
    {
        if sender.tag == CALENDAR_SWITCH_TAG
        {
            //toggle the calendar switch
            if (sender.on)
            {
                self.userSettings?.setBool(true, forKey: "calendarSwitch")
            }
            else
            {
                self.userSettings?.setBool(false, forKey: "calendarSwitch")
            }
        }
        else if sender.tag == TODO_SWITCH_TAG
        {
            //toggle the calendar switch
            if (sender.on)
            {
                self.userSettings?.setBool(true, forKey: "todoSwitch")
            }
            else
            {
                self.userSettings?.setBool(false, forKey: "todoSwitch")
            }
        }
        else if sender.tag == STICKY_SWITCH_TAG
        {
            //toggle the calendar switch
            if (sender.on)
            {
                self.userSettings?.setBool(true, forKey: "stickySwitch")
            }
            else
            {
                self.userSettings?.setBool(false, forKey: "stickySwitch")
            }
        }
        else if sender.tag == JOURNAL_SWITCH_TAG
        {
            //toggle the calendar switch
            if (sender.on)
            {
                self.userSettings?.setBool(true, forKey: "journalSwitch")
            }
            else
            {
                self.userSettings?.setBool(false, forKey: "journalSwitch")
            }
        }
    }
    
    //MARK:- ExportStuff
    func createReport()
    {
        var exportString: NSMutableString!
        var subExportString: NSMutableString!
        var headerExportString: NSString!
        var newStartDate: NSDate!
        var dateRangeString: NSString!
        
        exportString = NSMutableString.init(capacity: 10000)
        newStartDate = DateUtil.date(self.startDate, addDays: -1)
        
        dateRangeString = NSString.init(format: "%@ %@ %@ %@", REPORT_TITLE_FROM, DateUtil.stringFromDate(self.startDate, dateFormat: "EEE, MM/dd/yyyy"), REPORT_TITLE_TO, DateUtil.stringFromDate(DateUtil.date(self.endDate, addTimeInterval: -ADDED_SECONDS_FOR_END_DATE), dateFormat: "EEE, MM/dd/yyyy"))
        
        //check and grab ios calendar events if any
        let userCalendars = FamilyCBLManager.sharedInstance.calendars() as? [CBLFamilyUserCalendar]

        self.ekEvents = nil
        
        if nil != userCalendars
        {
            let ekCalendars = NSMutableArray()
            
            for userCalendar in userCalendars!
            {
                let ekCalendar = EKEventManager.sharedInstance().calendarWithIdentifier(userCalendar.calendarIdentifier)
                
                if nil != ekCalendar
                {
                    ekCalendars.addObject(ekCalendar)
                }
            }
            
            if ekCalendars.count > 0
            {
                self.ekEvents = EKEventManager.sharedInstance().eventsForCalendars(ekCalendars as [AnyObject], startDate: self.startDate, endDate: self.endDate)
            }
        }
        else
        {
            //this just for test, if user didnt import anything it will not do anything here at this step
            print("User did not import iOS calendar!")
        }
        
        
        //export calendar/schedule
        if (self.userSettings!.boolForKey("calendarSwitch") == true)
        {
            var scheduleArr:NSArray!
            var scheduleObject:CBLFamilySchedule!
            var testMemberIDArray:NSArray!
            var membersString:NSString!
            
            subExportString = NSMutableString.init(capacity: 1000)
            headerExportString = nil
            
            if (self.userSettings!.integerForKey("exportFormatUnit") == 0)//html
            {
                subExportString.appendString(HTML_DATA_TABLE_CALENDAR_START_TAG)
                headerExportString = NSString.init(format: HTML_DATA_HEADER_FORMAT, HTML_TITLE_STYLE, "Calendar")
                subExportString.appendFormat(HTML_SCHEDULE_TITLE_FORMAT, "Start", "", "End", "", "Event", "Members", "Notes", "Calendar")
                
                //family schedule events
                scheduleArr = FamilyCBLManager.sharedInstance.schedules(newStartDate, toDate: self.endDate)
                for item in scheduleArr
                {
                    scheduleObject = item as! CBLFamilySchedule
                    testMemberIDArray = NSArray.init(array: scheduleObject.memberIds!)
                    
                    for memberId in scheduleObject.memberIds!
                    {
                        let document = FamilyCBLManager.sharedInstance.cblDatabase!.existingDocumentWithID(memberId as! String)
                        
                        if nil != document
                        {
                            let member = CBLFamilyMember(forDocument: document!)
                            
                            if (scheduleObject.memberIds! == testMemberIDArray)
                            {
                                if (membersString == nil)
                                {
                                    membersString = member!.memberName
                                }
                                else
                                {
                                    membersString = "\(membersString), \(member!.memberName! as NSString)"
                                }
                            }
                        }
                    }
                    
                    if (scheduleObject.notes != nil)
                    {
                        if (scheduleObject.allDay!.boolValue)
                        {
                            subExportString.appendFormat(HTML_SCHEDULE_TEXT_FORMAT, DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy"), "", DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy"), "", scheduleObject.scheduleName!, membersString, scheduleObject.notes!, "Family Organizer")
                        }
                        else
                        {
                            subExportString.appendFormat(HTML_SCHEDULE_TEXT_FORMAT, DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "hh:mm a"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "hh:mm a"), scheduleObject.scheduleName!, membersString, scheduleObject.notes!, "Family Organizer")
                        }
                    }
                    else
                    {
                        if (scheduleObject.allDay!.boolValue)
                        {
                            subExportString.appendFormat(HTML_SCHEDULE_TEXT_FORMAT, DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy"), "", DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy"), "", scheduleObject.scheduleName!, membersString, "-", "Family Organizer")
                        }
                        else
                        {
                            subExportString.appendFormat(HTML_SCHEDULE_TEXT_FORMAT, DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "hh:mm a"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "hh:mm a"), scheduleObject.scheduleName!, membersString, "-", "Family Organizer")
                        }
                    }
                    membersString = nil
                }
                
                //ios calendar events
                if (self.ekEvents != nil)
                {
                    for objects in self.ekEvents
                    {
                        if (objects.allDay!)
                        {
                            subExportString.appendFormat(HTML_SCHEDULE_TEXT_FORMAT, DateUtil.stringFromDate(objects.startDate, dateFormat: "MM/dd/yyyy"), "", DateUtil.stringFromDate(objects.endDate, dateFormat: "MM/dd/yyyy"), "", objects.title, "-", "-", objects.calendar.title)
                        }
                        else
                        {
                            subExportString.appendFormat(HTML_SCHEDULE_TEXT_FORMAT, DateUtil.stringFromDate(objects.startDate, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(objects.startDate, dateFormat: "hh:mm a"), DateUtil.stringFromDate(objects.endDate, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(objects.endDate, dateFormat: "hh:mm a"), objects.title, "-", "-", objects.calendar.title)
                        }
                    }
                }
                
                subExportString.appendString(HTML_DATA_TABLE_END_TAG)
            }
            else if (self.userSettings!.integerForKey("exportFormatUnit") == 1)//csv
            {
                var calendarCSVArray:NSArray!
                headerExportString = NSString.init(format: "Calendar%@", CSV_LINE_BREAK)
                subExportString.appendString("Start,End,Event,Members,Notes,Calendar\n")
                
                scheduleArr = FamilyCBLManager.sharedInstance.schedules(newStartDate, toDate: self.endDate)
                for item in scheduleArr
                {
                    scheduleObject = item as! CBLFamilySchedule
                    testMemberIDArray = NSArray.init(array: scheduleObject.memberIds!)
                    
                    for memberId in scheduleObject.memberIds!
                    {
                        let document = FamilyCBLManager.sharedInstance.cblDatabase!.existingDocumentWithID(memberId as! String)
                        
                        if nil != document
                        {
                            let member = CBLFamilyMember(forDocument: document!)
                            
                            if (scheduleObject.memberIds! == testMemberIDArray)
                            {
                                if (membersString == nil)
                                {
                                    membersString = member!.memberName
                                }
                                else
                                {
                                    
                                    membersString = "\(membersString), \(member!.memberName! as NSString)"
                                }
                            }
                        }
                    }
                    
                    if (scheduleObject.notes != nil)
                    {
                        if (scheduleObject.allDay!.boolValue)
                        {
                            calendarCSVArray = NSArray(objects: DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy"), String(format: "\"%@\"", scheduleObject.scheduleName!), String(format: "\"%@\"", membersString), String(format: "\"%@\"", scheduleObject.notes!), "Family Organizer")
                        }
                        else
                        {
                            calendarCSVArray = NSArray(objects: DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), String(format: "\"%@\"", scheduleObject.scheduleName!), String(format: "\"%@\"", membersString), String(format: "\"%@\"", scheduleObject.notes!), "Family Organizer")
                        }
                    }
                    else
                    {
                        if (scheduleObject.allDay!.boolValue)
                        {
                            calendarCSVArray = NSArray(objects: DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy"), String(format: "\"%@\"", scheduleObject.scheduleName!), String(format: "\"%@\"", membersString), "-", "Family Organizer")
                        }
                        else
                        {
                            calendarCSVArray = NSArray(objects: DateUtil.stringFromDate(scheduleObject.startGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), DateUtil.stringFromDate(scheduleObject.endGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), String(format: "\"%@\"", scheduleObject.scheduleName!), String(format: "\"%@\"", membersString), "-", "Family Organizer")
                        }
                    }
                    subExportString.appendFormat("%@%@", calendarCSVArray.componentsJoinedByString(CSV_DELIMITER),CSV_LINE_BREAK)
                    membersString = nil
                }
                
                //ios calendar events
                if (self.ekEvents != nil)
                {
                    for objects in self.ekEvents
                    {
                        if (objects.allDay!)
                        {
                            calendarCSVArray = NSArray(objects: DateUtil.stringFromDate(objects.startDate, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(objects.endDate, dateFormat: "MM/dd/yyyy"), String(format: "\"%@\"", objects.title), "-", "-", String(format: "\"%@\"", objects.calendar.title))
                        }
                        else
                        {
                            calendarCSVArray = NSArray(objects: DateUtil.stringFromDate(objects.startDate, dateFormat: "MM/dd/yyyy  hh:mm a"),DateUtil.stringFromDate(objects.endDate, dateFormat: "MM/dd/yyyy  hh:mm a"), String(format: "\"%@\"", objects.title), "-", "-", String(format: "\"%@\"", objects.calendar.title))
                        }
                        subExportString.appendFormat("%@%@", calendarCSVArray.componentsJoinedByString(CSV_DELIMITER),CSV_LINE_BREAK)
                    }
                }
                
                subExportString.appendFormat("%@", CSV_LINE_BREAK)
                
            }
            
            subExportString.insertString(headerExportString as String, atIndex: 0)
            exportString.appendString(subExportString as String)
        }
        
        //export todo
        if (self.userSettings!.boolForKey("todoSwitch") == true)
        {
            var todoArray: [CBLFamilyToDo]!
            var nextDay: NSDate!
            
            nextDay = self.startDate
            subExportString = NSMutableString.init(capacity: 1000)
            headerExportString = nil
            
            if (self.userSettings!.integerForKey("exportFormatUnit") == 0)//html
            {
                subExportString.appendString(HTML_DATA_TABLE_TODO_START_TAG)
                headerExportString = NSString.init(format: HTML_DATA_HEADER_FORMAT, HTML_TITLE_STYLE, "To-do")
                subExportString.appendFormat(HTML_TODO_TITLE_FORMAT, "Due Date", "To-do", "Notes")
                
                while nextDay.compare(self.endDate) == NSComparisonResult.OrderedAscending
                {
                    todoArray = FamilyCBLManager.sharedInstance.toDos(dueDate: nextDay)
                    
                    for todoObject in todoArray
                    {
                        if (todoObject.notes != nil)
                        {
                            subExportString.appendFormat(HTML_TODO_TEXT_FORMAT, DateUtil.stringFromDate(todoObject.dueGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(todoObject.dueGMT!, dateFormat: "hh:mm a"), todoObject.toDoName!, todoObject.notes!)
                        }
                        else
                        {
                            subExportString.appendFormat(HTML_TODO_TEXT_FORMAT, DateUtil.stringFromDate(todoObject.dueGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(todoObject.dueGMT!, dateFormat: "hh:mm a"), todoObject.toDoName!, "-")
                        }
                    }
                    nextDay = DateUtil.date(nextDay, addDays: 1)
                }
                
                subExportString.appendString(HTML_DATA_TABLE_END_TAG)
            }
            else if (self.userSettings!.integerForKey("exportFormatUnit") == 1)//csv
            {
                var todoCSVArray:NSArray!
                headerExportString = NSString.init(format: "To-do%@", CSV_LINE_BREAK)
                subExportString.appendString("Due Date,To-do,Notes\n")
                
                while nextDay.compare(self.endDate) == NSComparisonResult.OrderedAscending
                {
                    todoArray = FamilyCBLManager.sharedInstance.toDos(dueDate: nextDay)
                    
                    for todoObject in todoArray
                    {
                        if (todoObject.notes != nil)
                        {
                            todoCSVArray = NSArray(objects: DateUtil.stringFromDate(todoObject.dueGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), String(format: "\"%@\"", todoObject.toDoName!), String(format: "\"%@\"", todoObject.notes!))
                        }
                        else
                        {
                            todoCSVArray = NSArray(objects: DateUtil.stringFromDate(todoObject.dueGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), String(format: "\"%@\"", todoObject.toDoName!), "-")
                        }
                        subExportString.appendFormat("%@%@", todoCSVArray.componentsJoinedByString(CSV_DELIMITER),CSV_LINE_BREAK)
                    }
                    nextDay = DateUtil.date(nextDay, addDays: 1)
                }
                subExportString.appendFormat("%@", CSV_LINE_BREAK)
            }
            
            subExportString.insertString(headerExportString as String, atIndex: 0)
            exportString.appendString(subExportString as String)
        }
        
        //export journal
        if (self.userSettings!.boolForKey("journalSwitch") == true)
        {
            var journalArray: [CBLFamilyJournal]!
            var nextDay: NSDate!
            
            nextDay = self.startDate
            subExportString = NSMutableString.init(capacity: 1000)
            headerExportString = nil
            
            if (self.userSettings!.integerForKey("exportFormatUnit") == 0)//html
            {
                subExportString.appendString(HTML_DATA_TABLE_JOURNAL_START_TAG)
                headerExportString = NSString.init(format: HTML_DATA_HEADER_FORMAT, HTML_TITLE_STYLE, "Journal (Text Only)")
                subExportString.appendFormat(HTML_JOURNAL_TITLE_FORMAT, "Date", "Journal")
                
                while nextDay.compare(self.endDate) == NSComparisonResult.OrderedAscending
                {
                    journalArray = FamilyCBLManager.sharedInstance.journals(nextDay)
                    for journalObject in journalArray
                    {
                        subExportString.appendFormat(HTML_JOURNAL_TEXT_FORMAT, DateUtil.stringFromDate(journalObject.dateGMT!, dateFormat: "MM/dd/yyyy"), DateUtil.stringFromDate(journalObject.dateGMT!, dateFormat: "hh:mm a"), journalObject.journalContent!)
                    }
                    nextDay = DateUtil.date(nextDay, addDays: 1)
                }
                subExportString.appendString(HTML_DATA_TABLE_END_TAG)
            }
            else if (self.userSettings!.integerForKey("exportFormatUnit") == 1)//csv
            {
                var journalCSVArray:NSArray!
                headerExportString = NSString.init(format: "Journal (Text Only)%@", CSV_LINE_BREAK)
                subExportString.appendString("Date,Journal\n")
                
                while nextDay.compare(self.endDate) == NSComparisonResult.OrderedAscending
                {
                    journalArray = FamilyCBLManager.sharedInstance.journals(nextDay)
                    for journalObject in journalArray
                    {
                        journalCSVArray = NSArray(objects: DateUtil.stringFromDate(journalObject.dateGMT!, dateFormat: "MM/dd/yyyy  hh:mm a"), String(format: "\"%@\"", journalObject.journalContent!))
                        subExportString.appendFormat("%@%@", journalCSVArray.componentsJoinedByString(CSV_DELIMITER),CSV_LINE_BREAK)
                    }
                    nextDay = DateUtil.date(nextDay, addDays: 1)
                }
                subExportString.appendFormat("%@", CSV_LINE_BREAK)
            }
            
            subExportString.insertString(headerExportString as String, atIndex: 0)
            exportString.appendString(subExportString as String)
        }
        
        //export sticky
        if (self.userSettings!.boolForKey("stickySwitch") == true)
        {
            var stickyArray: [CBLFamilySticky]!
            var nextDay: NSDate!
            
            nextDay = self.startDate
            subExportString = NSMutableString.init(capacity: 1000)
            headerExportString = nil
            
            if (self.userSettings!.integerForKey("exportFormatUnit") == 0)//html
            {
                subExportString.appendString(HTML_DATA_TABLE_STICKY_START_TAG)
                headerExportString = NSString.init(format: HTML_DATA_HEADER_FORMAT, HTML_TITLE_STYLE, "Sticky Notes")
                subExportString.appendFormat(HTML_STICKY_TITLE_FORMAT, "Date", "Sticky Note")
                
                while nextDay.compare(self.endDate) == NSComparisonResult.OrderedAscending
                {
                    stickyArray = FamilyCBLManager.sharedInstance.stickies(nextDay)
                    for stickyObject in stickyArray
                    {
                        subExportString.appendFormat(HTML_STICKY_TEXT_FORMAT, DateUtil.stringFromDate(stickyObject.dateGMT!, dateFormat: "MM/dd/yyyy"), stickyObject.note!)
                    }
                    nextDay = DateUtil.date(nextDay, addDays: 1)
                }
                subExportString.appendString(HTML_DATA_TABLE_END_TAG)
            }
            else if (self.userSettings!.integerForKey("exportFormatUnit") == 1)//csv
            {
                var stickyCSVArray:NSArray!
                headerExportString = NSString.init(format: "Sticky Notes%@", CSV_LINE_BREAK)
                subExportString.appendString("Date,Sticky Note\n")
                
                while nextDay.compare(self.endDate) == NSComparisonResult.OrderedAscending
                {
                    stickyArray = FamilyCBLManager.sharedInstance.stickies(nextDay)
                    for stickyObject in stickyArray
                    {
                        stickyCSVArray = NSArray(objects: DateUtil.stringFromDate(stickyObject.dateGMT!, dateFormat: "MM/dd/yyyy"), String(format: "\"%@\"", stickyObject.note!))
                        subExportString.appendFormat("%@%@", stickyCSVArray.componentsJoinedByString(CSV_DELIMITER),CSV_LINE_BREAK)
                    }
                    nextDay = DateUtil.date(nextDay, addDays: 1)
                }
                subExportString.appendFormat("%@", CSV_LINE_BREAK)
            }
            
            subExportString.insertString(headerExportString as String, atIndex: 0)
            exportString.appendString(subExportString as String)
        }
        
        //export email format stuff
        if (StringHelper.isEmptyString(exportString as String))
        {
            AlertViewHelper.alertOkMsgWithTitle(NO_DATA_TITLE, message: NO_DATA_DESCRIPTION)
        }
        else
        {
            let subject = dateRangeString as String
            
            if (self.userSettings!.integerForKey("exportFormatUnit") == 1)//csv
            {
                //convert csvString to NSData
                var attachmentData:NSData!
                attachmentData = exportString.dataUsingEncoding(NSUTF8StringEncoding)
                EmailUtil.sharedInstance().displayComposerSheetInViewController(self, subject: subject, toEmail: nil, body: "", attachment: attachmentData, fileName: "report.csv", mimeType: "csv", isHTML: false, hideStatusBar: false)
            }
            else if (self.userSettings!.integerForKey("exportFormatUnit") == 0)//html
            {
                EmailUtil.sharedInstance().displayComposerSheetInViewController(self, subject: subject, toEmail: nil, body: exportString as String, isHTML: true, hideStatusBar: false)
            }
        }
        
//        ModalPopoverViewController.sharedInstance().dismissModalPopoverView()
        AppDelegate.sharedInstance().dismissSyncStatusView { 
            
        }
        
        //may need a try catch or something like that to handle potential exceptions
        //AlertViewHelper.alertOkMsgWithTitle(EXCEPTION_TITLE, message: EXCEPTION_DESCRIPTION)
    }
    
    func buildTableSections()
    {
        self.tableSections.removeAllObjects()
        
        //segment section
        self.exportFormatSection = TableViewSection()
        self.exportFormatSection.data.addObject(SECTION_SEG_TAG)
        
        //date range section
        self.exportDateSection = TableViewSection()
        self.exportDateSection.data.addObject(START_DATE_TAG)
        self.exportDateSection.data.addObject(END_DATE_TAG)
        
        //switch section
        self.exportSwitchSection = TableViewSection()
        self.exportSwitchSection.data.addObject(ROW_ENTRY_CALENDAR_TAG)
        self.exportSwitchSection.data.addObject(ROW_ENTRY_TODO_TAG)
        self.exportSwitchSection.data.addObject(ROW_ENTRY_STICKY_TAG)
        self.exportSwitchSection.data.addObject(ROW_ENTRY_JOURNAL_TAG)
        
        //button section
        self.buttonSection = TableViewSection()
        self.buttonSection.data.addObject(ROW_BUTTON_TAG)
        
        //add all sections to table
        self.tableSections.addObject(self.exportFormatSection)
        self.tableSections.addObject(self.exportDateSection)
        self.tableSections.addObject(self.exportSwitchSection)
        self.tableSections.addObject(self.buttonSection)
    }
    
    //MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let tableSection = self.tableSections[section] as! TableViewSection
        
        return tableSection.data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableSections.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let rowTags = TableViewSection.rowDataForSectionGroup(self.tableSections as [AnyObject], indexPath: indexPath) as! String
        
        if (rowTags == ROW_ENTRY_CALENDAR_TAG || rowTags == ROW_ENTRY_TODO_TAG || rowTags == ROW_ENTRY_STICKY_TAG || rowTags == ROW_ENTRY_JOURNAL_TAG)
        {
            return 70
        }
        else if (rowTags == ROW_BUTTON_TAG)
        {
            return 100
        }
        
        return 60
    }
    
    //MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let rowTags = TableViewSection.rowDataForSectionGroup(self.tableSections as [AnyObject], indexPath: indexPath) as! String
        
        if (rowTags == SECTION_SEG_TAG)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleDetailSegControlCellID", forIndexPath: indexPath) as! ScheduleDetailSegControlCell
            
            cell.layoutBottomDivider(self.tableSections, indexPath: indexPath)
            
            let attr = NSDictionary(object: UIFont.systemFontOfSize(13.0), forKey: NSFontAttributeName)
            cell.segControl.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: UIControlState.Normal)
            
            cell.nameLabel!.text = ""
            cell.segControl.frame = CGRectMake(tableView.frame.minX, tableView.frame.minY+15, tableView.frame.size.width-50, 30.0)
            cell.segControl.setTitle("HTML", forSegmentAtIndex: 0)
            cell.segControl.setTitle("CSV", forSegmentAtIndex: 1)
            cell.segControl.selectedSegmentIndex = self.userSettings!.integerForKey("exportFormatUnit")
            cell.segControl.addTarget(self, action: #selector(ExportViewController.exportFormatUnitChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            
            return cell
        }
        else if (rowTags == ROW_BUTTON_TAG)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellButtonID", forIndexPath: indexPath) as UITableViewCell
            
            self.exportButton!.backgroundColor = CALENDAR_BASE_COLOR
            self.exportButton!.layer.cornerRadius = 5
            self.exportButton!.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
            self.exportButton!.frame = CGRectMake(tableView.frame.minX+10, tableView.frame.minY+10, tableView.frame.size.width-20, 50)
            self.exportButton!.addTarget(self, action: #selector(ExportViewController.doneAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.addSubview(self.exportButton!)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ExportTableViewCellID", forIndexPath: indexPath) as! ExportTableViewCell
            
            cell.textLabel!.font = UIFont(name: "Quicksand-Regular", size: 18.0)
            cell.layoutBottomDivider(self.tableSections, indexPath: indexPath)
            cell.iconImage = UIImageView.init(frame: CGRectMake(25, cell.frame.size.height/3, 25, 25))
            
            if (rowTags == START_DATE_TAG)
            {
                cell.nameLabel!.hidden = false
                cell.nameLabel!.text = rowTags as String
                
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
                cell.valueTextField!.hidden = false
                cell.valueTextField!.enabled = false
                cell.valueSwitch?.hidden = true
                cell.valueTextField!.text = DateUtil.stringFromDate(self.startDate, dateFormat: "EEE, MMM dd, yyyy")
            }
            else if (rowTags == END_DATE_TAG)
            {
                cell.nameLabel!.hidden = false
                cell.nameLabel!.text = rowTags as String
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
                cell.valueTextField!.hidden = false
                cell.valueTextField!.enabled = false
                cell.valueSwitch?.hidden = true
                cell.valueTextField!.text = DateUtil.stringFromDate(DateUtil.date(self.endDate, addTimeInterval:-ADDED_SECONDS_FOR_END_DATE), dateFormat: "EEE, MMM dd, yyyy")
            }
            else if (rowTags == ROW_ENTRY_CALENDAR_TAG)
            {
                cell.indentationLevel = 5
                ViewHelper.view(cell.valueSwitch, setY: cell.frame.size.height/3 - 2)
                
                cell.nameLabel!.text = ""
                cell.textLabel!.text = "Calendar"
                cell.textLabel!.textColor = CALENDAR_BASE_COLOR
                cell.valueSwitch?.hidden = false
                cell.iconImage!.image = UIImage(named: "calendar.png")
                cell.valueSwitch!.tag = CALENDAR_SWITCH_TAG
                
                cell.valueSwitch!.addTarget(self, action: #selector(ExportViewController.switchToggled(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.valueSwitch!.setOn(self.userSettings!.boolForKey("calendarSwitch"), animated: false)
            }
            else if (rowTags == ROW_ENTRY_TODO_TAG)
            {
                cell.indentationLevel = 5
                ViewHelper.view(cell.valueSwitch, setY: cell.frame.size.height/3 - 2)
                
                cell.nameLabel!.text = ""
                cell.textLabel!.text = "To-do"
                cell.textLabel!.textColor = TODO_BASE_COLOR
                cell.valueSwitch?.hidden = false
                cell.iconImage!.image = UIImage(named: "todo.png")
                cell.valueSwitch!.tag = TODO_SWITCH_TAG
                
                cell.valueSwitch!.addTarget(self, action: #selector(ExportViewController.switchToggled(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.valueSwitch!.setOn(self.userSettings!.boolForKey("todoSwitch"), animated: false)
            }
            else if (rowTags == ROW_ENTRY_STICKY_TAG)
            {
                cell.indentationLevel = 5
                ViewHelper.view(cell.valueSwitch, setY: cell.frame.size.height/3 - 2)
                
                cell.nameLabel!.text = ""
                cell.textLabel!.text = "Sticky Notes"
                cell.textLabel!.textColor = STICKY_BASE_COLOR
                cell.valueSwitch?.hidden = false
                cell.iconImage!.image = UIImage(named: "stickyIcon.png")
                cell.valueSwitch!.tag = STICKY_SWITCH_TAG
                
                cell.valueSwitch!.addTarget(self, action: #selector(ExportViewController.switchToggled(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.valueSwitch!.setOn(self.userSettings!.boolForKey("stickySwitch"), animated: false)
            }
            else if (rowTags == ROW_ENTRY_JOURNAL_TAG)
            {
                cell.indentationLevel = 5
                ViewHelper.view(cell.valueSwitch, setY: cell.frame.size.height/3 - 2)
                
                cell.nameLabel!.text = ""
                cell.textLabel!.text = "Journal (text only)"
                cell.textLabel!.textColor = JOURNAL_BASE_COLOR
                cell.valueSwitch?.hidden = false
                cell.iconImage!.image = UIImage(named: "journal.png")
                cell.valueSwitch!.tag = JOURNAL_SWITCH_TAG
                
                cell.valueSwitch!.addTarget(self, action: #selector(ExportViewController.switchToggled(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.valueSwitch!.setOn(self.userSettings!.boolForKey("journalSwitch"), animated: false)
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let rowTags = TableViewSection.rowDataForSectionGroup(self.tableSections as [AnyObject], indexPath: indexPath) as! String
        
        var datePickerView: DatePickerView!
        if (rowTags == START_DATE_TAG)
        {
            datePickerView = DatePickerView.datePickerViewForDate()
            datePickerView.delegate = self;
            datePickerView.tag = START_DATE_PICKER_TAG;
            datePickerView.datePicker.minimumDate = DateUtil.date(DateUtil.date(self.startDate, addTimeInterval: -ADDED_SECONDS_FOR_END_DATE), addYears: -1)
            datePickerView.datePicker.maximumDate = NSDate()
            datePickerView.datePicker.date = self.startDate
            datePickerView.presentTextfieldInputViewFromView(self.view)
        }
        else if (rowTags == END_DATE_TAG)
        {
            var date:NSDate!
            date = DateUtil.date(self.endDate, addTimeInterval: -ADDED_SECONDS_FOR_END_DATE)
            datePickerView = DatePickerView.datePickerViewForDate();
            datePickerView.delegate = self;
            datePickerView.tag = END_DATE_PICKER_TAG;
            datePickerView.datePicker.minimumDate = DateUtil.date(NSDate(), addTimeInterval: -ADDED_SECONDS_FOR_END_DATE)
            datePickerView.datePicker.maximumDate = DateUtil.date(DateUtil.date(self.endDate, addTimeInterval: -ADDED_SECONDS_FOR_END_DATE), addYears: 1)
            //Calculation does not include end date so added 1 min to selected end date. (need to remove the extra min before setting picker)
            //very strange problem, the time does not get passed into the date of the datepicker unless we pass it twice??
            datePickerView.datePicker.date = date;
            datePickerView.datePicker.date = date;
            datePickerView.presentTextfieldInputViewFromView(self.view)
        }
        else if (rowTags == ROW_ENTRY_CALENDAR_TAG)
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExportTableViewCell
            cell.valueSwitch!.setOn(!cell.valueSwitch!.on, animated: true)
            self.switchToggled(cell.valueSwitch!)
        }
        else if (rowTags == ROW_ENTRY_TODO_TAG)
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExportTableViewCell
            cell.valueSwitch!.setOn(!cell.valueSwitch!.on, animated: true)
            self.switchToggled(cell.valueSwitch!)
        }
        else if (rowTags == ROW_ENTRY_JOURNAL_TAG)
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExportTableViewCell
            cell.valueSwitch!.setOn(!cell.valueSwitch!.on, animated: true)
            self.switchToggled(cell.valueSwitch!)
        }
        else if (rowTags == ROW_ENTRY_STICKY_TAG)
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! ExportTableViewCell
            cell.valueSwitch!.setOn(!cell.valueSwitch!.on, animated: true)
            self.switchToggled(cell.valueSwitch!)
        }
    }
    
    //MARK:- Helpers
    func exportFormatUnitChanged(segControl:UISegmentedControl)
    {
        self.userSettings?.setInteger(segControl.selectedSegmentIndex, forKey: "exportFormatUnit")
    }
    
    //MARK:- DatePickerViewDelegate
    func datePickerView(datePickerView: DatePickerView!, selectedDate date: NSDate!)
    {
        if (START_DATE_PICKER_TAG == datePickerView.tag)
        {
            if (date.timeIntervalSinceDate(DateUtil.date(self.endDate, addTimeInterval: -ADDED_SECONDS_FOR_END_DATE)) > 0)
            {
                AlertViewHelper.alertOkMsgWithTitle("", message: START_DATE_NO_LATER_THAN_END_DATE)
                return;
            }
            self.startDate = date;
        }
        else if (END_DATE_PICKER_TAG == datePickerView.tag)
        {
            if (date.timeIntervalSinceDate(self.startDate) < 0)
            {
                AlertViewHelper.alertOkMsgWithTitle("", message: START_DATE_NO_LATER_THAN_END_DATE)
                return;
            }
            
            self.endDate = DateUtil.date(date, addTimeInterval: ADDED_SECONDS_FOR_END_DATE)
            //Calculation does not include end date so added 1 min to selected end date.
        }
        
        self.registeredTableView!.reloadSections(NSIndexSet.init(index:1), withRowAnimation:UITableViewRowAnimation.Fade)
    }
}


















