//
//  Date+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

extension Date {
    func formatted(
        _ format: String,
        timeZone: TimeZone = .autoupdatingCurrent,
        locale: Locale = .current
    ) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension Date {
    /// day 단위로 날짜를 더하거나 뺀다 (DST/윤초 등은 Calendar가 알아서 처리)
    static func addDays(_ days: Int, calendar: Calendar = .current) -> Self? {
        return calendar.date(byAdding: .day, value: days, to: .now)
    }

    func addDays(_ days: Int, calendar: Calendar = .current) -> Self? {
        return calendar.date(byAdding: .day, value: days, to: self)
    }

    /// 다음 날
    var nextDay: Date? {
        addDays(1)
    }

    /// 이전 날
    var previousDay: Date? {
        addDays(-1)
    }
}
