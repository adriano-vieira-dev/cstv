//
//  Date+Extensions.swift
//  CSTV
//
//  Created by Adriano Vieira on 31/08/24.
//

import Foundation

extension Date {
    init?(fromISO8601String isoString: String) {
        let formatter = ISO8601DateFormatter()

        guard let date = formatter.date(from: isoString) else { return nil }

        self = date
    }

    func relativeFormat() -> String {
        let calendar = Calendar.current
        let now = Date()

        guard self > now else { return "AGORA" }

        let dateFormatter = DateFormatter()

        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "'Hoje,' HH:mm"
        } else if let daysDifference = calendar.dateComponents([.day], from: now, to: self).day, daysDifference <= 6 {
            dateFormatter.dateFormat = "EEE, HH:mm"
        } else if calendar.isDate(self, equalTo: now, toGranularity: .year) {
            dateFormatter.dateFormat = "dd.MM, HH:mm"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        }

        return dateFormatter.string(from: self)
    }
}
