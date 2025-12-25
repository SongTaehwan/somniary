//
//  AuthDomainError.swift
//  Somniary
//
//  Created by 송태환 on 12/25/25.
//

import Foundation

enum AuthDomainError: Error, Equatable {
  /// 로그인 필요(세션이 더 이상 유효하지 않음)
  case loginRequired

  /// refresh token 만료
  case refreshTokenExpired

  /// refresh token 회수/폐기(재사용 감지 포함)
  case refreshTokenRevoked

  /// 계정 정지/탈퇴 등 정책으로 인증 불가
  case accountDisabled(reason: String)
}
