//
//  CustomDateFormatter.swift
//  GitHubClient
//
//  Created by Darya on 18.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

import Foundation
class StringDateFormatter {
    
    private let stringToDateFormatter = DateFormatter()
    private let dateToStringFormatter = DateFormatter()
    
    init(originalDateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ",
         requiredDateFormat: String = "dd.MM.yyyy") {
        stringToDateFormatter.dateFormat = originalDateFormat
        dateToStringFormatter.dateFormat = requiredDateFormat
    }
    
    func stringDate(from string: String) -> String? {
        if let date = stringToDateFormatter.date(from: string) {
            return dateToStringFormatter.string(from: date)
        }
        return nil
    }
}
