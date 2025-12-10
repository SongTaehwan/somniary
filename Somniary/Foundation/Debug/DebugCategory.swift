//
//  DebugCategory.swift
//  Somniary
//
//  Created by 송태환 on 12/9/25.
//

import Foundation

/// 디버그 카테고리
enum DebugCategory: String, Codable {
    case network = "🌐"
    case data = "💾"
    case ui = "🎨"
    case logic = "🧠"
    case state = "📊"
}
