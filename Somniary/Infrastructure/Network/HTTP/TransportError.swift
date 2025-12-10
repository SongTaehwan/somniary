//
//  TransportError.swift
//  Somniary
//
//  Created by 송태환 on 10/25/25.
//

import Foundation

/// 전송 성공 여부가 에러를 가르는 기준
/// 네트워크 프로토콜에 대한 해석은 Data Source
enum TransportError: Error, Equatable {
    /// 네트워크 연결 관련 오류
    case network(Network)

    /// URL, 인코딩, 멀티파트 등 Request 생성 오류
    /// - Note: 에러 케이스별 대응 정책이 있다면 세부 케이스로 쪼개기
    case requestBuildFailed

    /// SSL/TLS/핀닝/체인 문제
    case tls

    /// 전송 요청 취소
    case cancelled

    case unknown

    /// 케이스별 세부 정책
    /// - offline - 오프라인 안내 문구 노출
    /// - timeout - 재시도 안내 문구 노출
    /// - dnsLookupFailed - 재시도 안내 문구 노출
    /// - other - 오류 안내 문구 노출
    enum Network: Equatable {
        case offline
        case timeout
        case dnsLookupFailed
        case connectionLost
        case redirectLoop
        case other(URLError.Code)
    }
}
