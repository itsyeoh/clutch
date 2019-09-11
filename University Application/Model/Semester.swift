//
//  Semester.swift
//  University App
//
//  Created by Jason Yeoh on 16/08/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation

enum Season: String {
    case Fall = "Fall"
    case Spring = "Spring"
    case Summer = "Summer"
    case Winter = "Winter"
}


class Semester {
    let sid: Int64!
    var season: String!
    var startDate: Date!
    var endDate: Date!
    
    init(id: Int64) {
        self.sid = id
        self.season = ""
        self.startDate = Date()
        self.endDate = Date()
    }
    
    init(sid: Int64, season: String, startDate: Date, endDate: Date) {
        self.sid = sid
        self.season = season
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func getDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    func getStringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: dateString)!
    }
    
    func getDateToYearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getPreviewTextLabel() -> String {
        return String(self.season.uppercased().prefix(2))
    }
    
    func getSeasonTextLabel() -> String {
        return self.season + " " + getDateToYearString(date: self.startDate)
    }
}
