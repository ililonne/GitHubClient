//
//  String+Ext.swift
//  GitHubClient
//
//  Created by Darya on 11.07.2020.
//  Copyright © 2020 ililonne. All rights reserved.
//

extension String {
    //при сложении строк почему-то добавляется нулевой пробел и они не переводятся в url
    var cleared: String {
        return self.replacingOccurrences(of: "\u{200B}", with: "")
    }
}
