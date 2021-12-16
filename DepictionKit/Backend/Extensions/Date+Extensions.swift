//
//  Date+Extensions.swift
//  DepictionKit
//
//  Created by Andromeda on 16/12/2021.
//

import Foundation

/// :nodoc:
extension Date {
    
    func relative(from: Date) -> String {
        _RelativeDateFormatter.relative(from: from, to: self)
    }
    
    static func relative(from: Date) -> String {
        _RelativeDateFormatter.relative(from: from, to: Date())
    }
    
}

/// :nodoc:
// swiftlint:disable type_name
internal final class _RelativeDateFormatter {
// swiftlint:enable type_name
    class func relative(from: Date, to: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        let calendar = Calendar.current
        if calendar.isDateInToday(from) {
            return "Today at \(formatter.string(from: from))"
        } else if calendar.isDateInTomorrow(from) {
            return "Tomorrow at \(formatter.string(from: from))"
        } else if calendar.isDateInYesterday(from) {
            return "Yesterday at \(formatter.string(from: from))"
        }
        
        let isFuture = from > to
        let comp = Calendar.current.dateComponents([.month, .year, .day], from: from, to: to)
        let year = abs(comp.year ?? 0)
        if year != 0 {
            if year == 1 {
                return isFuture ? "In a year" : "A year ago"
            }
            return isFuture ? "In \(year) years" : "\(year) years ago"
        }
        let month = abs(comp.month ?? 0)
        if month != 0 {
            if month == 1 {
                return isFuture ? "In a month" : "A month ago"
            }
            return isFuture ? "In \(month) months" : "\(month) months ago"
        }
        let day = abs(comp.day ?? 0)
        return isFuture ? "In \(day) days" : "\(day) days ago"
    }
    
}
