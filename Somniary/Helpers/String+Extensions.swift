//
//  String+Extensions.swift
//  Somniary
//
//  Created by 송태환 on 9/19/25.
//

import Foundation

extension String {
    @available(iOS 16, *)
    var isValidEmail: Bool {
        // 영문/숫자 시작 → @ → 도메인 → 최종 .TLD
        let regex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return self.wholeMatch(of: regex) != nil
    }
}
