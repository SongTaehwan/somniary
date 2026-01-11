//
//  UseCaseResolution.swift
//  Somniary
//
//  Created by 송태환 on 1/5/26.
//

import Foundation

// MARK: - Error Resolution (UseCaseError -> UI Action)
enum UseCaseResolution: Equatable {
    // MARK: 공통
    /// 사용자에게 즉시 안내
    case inform(message: String)

    /// 재시도 안내(자동 재시도는 하지 않음)
    case retry(message: String, diagnostic: String? = nil)

    /// 일정 시간 대기 안내
    case cooldown(seconds: Int?, message: String)

    /// 앱 업데이트 유도 (또는 문의)
    case updateApp(message: String, diagnostic: String? = nil)
    
    /// 문의/리포트 유도
    case contactSupport(message: String, diagnostic: String? = nil)

    // MARK: 인증 관련
    enum ReauthMode: Equatable {
        /// 로컬에 저장된 토큰 정보가 유효한 상태에서 다시 로그인이 필요한 경우
        case normal
        /// 강제 로그아웃
        /// - 리포트 로그아웃 등
        /// - 서버에서 토큰 강제 만료
        case forceLogout
        /// credential 변경 등: 보안 재인증
        case securityReauth
    }

    case reauth(mode: ReauthMode, message: String, diagnostic: String? = nil)
    case accessDenied(message: String, diagnostic: String? = nil)
}

// MARK: Common Error Resolver
/// - NOTE: 고정 메시지 사용 시 UserMessageKeyProviding 사용
/// - 다른 메시지 사용/액션 변경이 필요하면 feature 타입 명시 resolver 구현
extension UseCaseResolution {
    /// 기본 구현체: Feature 별로 메시지가 세분화되지 않아도 괜찮은 경우 사용.
    /// - Note: 사용자 노출 메시지에서 `String(describing:)` 를 절대 사용하지 않는다.
    static func resolve<Contract: Error & Equatable, Boundary: Error & Equatable>(
        _ error: UseCaseError<Contract, Boundary>,
        defaultContractMessageKey: String = "error.invalid_input",
        defaultOutOfContractMessageKey: String = "error.out_of_contract"
    ) -> UseCaseResolution {
        switch error {
        case .contract(let contract):
            // UserMessageKeyProviding 를 우선 사용하고, 없으면 기본 키로 fallback
            let key = messageKey(contract, default: defaultContractMessageKey)
            return .inform(message: key)

        case .outOfContract(let boundary):
            // outOfContract 는 내부 정책/상태가 섞일 수 있으므로 기본은 문의로 유도
            // message 는 안전한 키만, diagnostic 에만 상세를 남긴다.
            let key = messageKey(boundary, default: defaultOutOfContractMessageKey)
            return .contactSupport(message: key, diagnostic: "out_of_contract: \(boundary)")

        case .system(let system):
            return resolve(system)
        }
    }

    /// SystemFailure 기본 매핑(공통 정책)
    static func resolve(_ system: SystemFailure) -> UseCaseResolution {
        switch system {
        case .rateLimited(let retryAfterSeconds):
            return .cooldown(seconds: retryAfterSeconds, message: "요청이 너무 많아요. 잠시 후 다시 시도해주세요.")
        case .dependencyUnavailable(let details):
            return .retry(message: "네트워크 상태가 원활하지 않아요. 잠시 후 다시 시도해 주세요.", diagnostic: details)
        case .contractViolation(let details):
            return .updateApp(message: "일시적인 오류가 발생했어요. 앱을 업데이트하거나 문의해 주세요.", diagnostic: details)
        case .internalInvariantViolation(let reason):
            return .contactSupport(message: "예상치 못한 오류가 발생했어요. 문제가 계속되면 고객센터에 문의해 주세요.", diagnostic: reason)
        case .unknown(let details):
            return .contactSupport(message: "오류가 발생했어요. 잠시 후 다시 시도해 주세요.", diagnostic: details)
        }
    }

    /// UserMessageKeyProviding 를 우선 제공한다.
    private static func messageKey<E: Error>(_ error: E, default defaultKey: String) -> String {
        (error as? UserMessageKeyProviding)?.userMessageKey ?? defaultKey
    }
}

#if DEBUG
extension UseCaseResolution {
    func debugPrint(caller: String = #function, file: String = #file, line: Int = #line) {
        let message = {
            let time = Date.now.formatted(date: .numeric, time: .standard)
            let fileName = (file as NSString).lastPathComponent
            return """
            ╔══════════════════════════════════════════════════════════════
            ║ 💥 \(UseCaseResolution.self)
            ╠══════════════════════════════════════════════════════════════
            ║ 📚 Layer      : Presentation
            ║ 📞 Caller     : \(caller)
            ║ 📍 Location   : \(fileName):\(line)
            ╠══════════════════════════════════════════════════════════════
            ║ 💬 Case       : \(String.init(describing: self).replacingOccurrences(of: "Somniary.", with: ""))
            ╠──────────────────────────────────────────────────────────────
            ║ ⏰ Time       : \(time)
            ╚══════════════════════════════════════════════════════════════
            """
        }()

        print(message)
    }
}
#endif
