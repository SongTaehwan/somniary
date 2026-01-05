//
//  Failure.swift
//  Somniary
//
//  Created by 송태환 on 12/23/25.
//

import Foundation

/// 포트 경계를 넘을 때 “도메인 의미의 실패와 “앱 레벨 실패”를 합쳐 전달하는 실패 컨테이너
/// 목적: 도메인 실패와 의존성 실패를 동시에 표현하면서, 레포지토리 경계를 넘을 때 의미를 보존하기 위함
/// "필요성: 이 함수가 어떤 에러를 던질 수 있는지" 가 컴파일 타임에 드러나지 않아 (계약이 약해짐)
enum PortFailure<BoundaryFailure: Error & Equatable>: Error, Equatable {
    case boundary(BoundaryFailure)
    case system(SystemFailure)
}
