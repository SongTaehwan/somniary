//
//  NetAuthErrorCode.swift
//  Somniary
//
//  Created by 송태환 on 1/14/26.
//

import Foundation

/// Supabase Auth API `error.code` values.
/// Supabase Docs - Auth error codes table
/// https://supabase.com/docs/guides/auth/debugging/error-codes#auth-error-codes-table
enum NetAuthErrorCode: Equatable, Sendable, Error, Decodable {

    // MARK: - Known codes (from the table)
    case anonymousProviderDisabled
    case badCodeVerifier
    case badJson
    case badJwt
    case badOauthCallback
    case badOauthState
    case captchaFailed
    case conflict
    case emailAddressInvalid
    case emailAddressNotAuthorized
    case emailConflictIdentityNotDeletable
    case emailExists
    case emailNotConfirmed
    case emailProviderDisabled
    case flowStateExpired
    case flowStateNotFound
    case hookPayloadInvalidContentType
    case hookPayloadOverSizeLimit
    case hookTimeout
    case hookTimeoutAfterRetry
    case identityAlreadyExists
    case identityNotFound
    case insufficientAal
    case invalidCredentials
    case inviteNotFound
    case manualLinkingDisabled
    case mfaChallengeExpired
    case mfaFactorNameConflict
    case mfaFactorNotFound
    case mfaIpAddressMismatch
    case mfaPhoneEnrollNotEnabled
    case mfaPhoneVerifyNotEnabled
    case mfaTotpEnrollNotEnabled
    case mfaTotpVerifyNotEnabled
    case mfaVerificationFailed
    case mfaVerificationRejected
    case mfaVerifiedFactorExists
    case mfaWebAuthnEnrollNotEnabled
    case mfaWebAuthnVerifyNotEnabled
    case noAuthorization
    case notAdmin
    case oauthProviderNotSupported
    case otpDisabled
    case otpExpired
    case overEmailSendRateLimit
    case overRequestRateLimit
    case overSmsSendRateLimit
    case phoneExists
    case phoneNotConfirmed
    case phoneProviderDisabled
    case providerDisabled
    case providerEmailNeedsVerification
    case reauthenticationNeeded
    case reauthenticationNotValid
    case refreshTokenAlreadyUsed
    case refreshTokenNotFound
    case requestTimeout
    case samePassword
    case samlAssertionNoEmail
    case samlAssertionNoUserId
    case samlEntityIdMismatch
    case samlIdpAlreadyExists
    case samlIdpNotFound
    case samlMetadataFetchFailed
    case samlProviderDisabled
    case samlRelayStateExpired
    case samlRelayStateNotFound
    case sessionExpired
    case sessionNotFound
    case signupDisabled
    case singleIdentityNotDeletable
    case smsSendFailed
    case ssoDomainAlreadyExists
    case ssoProviderNotFound
    case tooManyEnrolledMfaFactors
    case unexpectedAudience
    case unexpectedFailure
    case userAlreadyExists
    case userBanned
    case userNotFound
    case userSsoManaged
    case validationFailed
    case weakPassword

    /// Fallback for forward-compatibility (new codes added server-side)
    case unknown(String)

    // MARK: - Raw value mapping
    var rawValue: String {
        switch self {
        case .anonymousProviderDisabled: return "anonymous_provider_disabled"
        case .badCodeVerifier: return "bad_code_verifier"
        case .badJson: return "bad_json"
        case .badJwt: return "bad_jwt"
        case .badOauthCallback: return "bad_oauth_callback"
        case .badOauthState: return "bad_oauth_state"
        case .captchaFailed: return "captcha_failed"
        case .conflict: return "conflict"
        case .emailAddressInvalid: return "email_address_invalid"
        case .emailAddressNotAuthorized: return "email_address_not_authorized"
        case .emailConflictIdentityNotDeletable: return "email_conflict_identity_not_deletable"
        case .emailExists: return "email_exists"
        case .emailNotConfirmed: return "email_not_confirmed"
        case .emailProviderDisabled: return "email_provider_disabled"
        case .flowStateExpired: return "flow_state_expired"
        case .flowStateNotFound: return "flow_state_not_found"
        case .hookPayloadInvalidContentType: return "hook_payload_invalid_content_type"
        case .hookPayloadOverSizeLimit: return "hook_payload_over_size_limit"
        case .hookTimeout: return "hook_timeout"
        case .hookTimeoutAfterRetry: return "hook_timeout_after_retry"
        case .identityAlreadyExists: return "identity_already_exists"
        case .identityNotFound: return "identity_not_found"
        case .insufficientAal: return "insufficient_aal"
        case .invalidCredentials: return "invalid_credentials"
        case .inviteNotFound: return "invite_not_found"
        case .manualLinkingDisabled: return "manual_linking_disabled"
        case .mfaChallengeExpired: return "mfa_challenge_expired"
        case .mfaFactorNameConflict: return "mfa_factor_name_conflict"
        case .mfaFactorNotFound: return "mfa_factor_not_found"
        case .mfaIpAddressMismatch: return "mfa_ip_address_mismatch"
        case .mfaPhoneEnrollNotEnabled: return "mfa_phone_enroll_not_enabled"
        case .mfaPhoneVerifyNotEnabled: return "mfa_phone_verify_not_enabled"
        case .mfaTotpEnrollNotEnabled: return "mfa_totp_enroll_not_enabled"
        case .mfaTotpVerifyNotEnabled: return "mfa_totp_verify_not_enabled"
        case .mfaVerificationFailed: return "mfa_verification_failed"
        case .mfaVerificationRejected: return "mfa_verification_rejected"
        case .mfaVerifiedFactorExists: return "mfa_verified_factor_exists"
        case .mfaWebAuthnEnrollNotEnabled: return "mfa_web_authn_enroll_not_enabled"
        case .mfaWebAuthnVerifyNotEnabled: return "mfa_web_authn_verify_not_enabled"
        case .noAuthorization: return "no_authorization"
        case .notAdmin: return "not_admin"
        case .oauthProviderNotSupported: return "oauth_provider_not_supported"
        case .otpDisabled: return "otp_disabled"
        case .otpExpired: return "otp_expired"
        case .overEmailSendRateLimit: return "over_email_send_rate_limit"
        case .overRequestRateLimit: return "over_request_rate_limit"
        case .overSmsSendRateLimit: return "over_sms_send_rate_limit"
        case .phoneExists: return "phone_exists"
        case .phoneNotConfirmed: return "phone_not_confirmed"
        case .phoneProviderDisabled: return "phone_provider_disabled"
        case .providerDisabled: return "provider_disabled"
        case .providerEmailNeedsVerification: return "provider_email_needs_verification"
        case .reauthenticationNeeded: return "reauthentication_needed"
        case .reauthenticationNotValid: return "reauthentication_not_valid"
        case .refreshTokenAlreadyUsed: return "refresh_token_already_used"
        case .refreshTokenNotFound: return "refresh_token_not_found"
        case .requestTimeout: return "request_timeout"
        case .samePassword: return "same_password"
        case .samlAssertionNoEmail: return "saml_assertion_no_email"
        case .samlAssertionNoUserId: return "saml_assertion_no_user_id"
        case .samlEntityIdMismatch: return "saml_entity_id_mismatch"
        case .samlIdpAlreadyExists: return "saml_idp_already_exists"
        case .samlIdpNotFound: return "saml_idp_not_found"
        case .samlMetadataFetchFailed: return "saml_metadata_fetch_failed"
        case .samlProviderDisabled: return "saml_provider_disabled"
        case .samlRelayStateExpired: return "saml_relay_state_expired"
        case .samlRelayStateNotFound: return "saml_relay_state_not_found"
        case .sessionExpired: return "session_expired"
        case .sessionNotFound: return "session_not_found"
        case .signupDisabled: return "signup_disabled"
        case .singleIdentityNotDeletable: return "single_identity_not_deletable"
        case .smsSendFailed: return "sms_send_failed"
        case .ssoDomainAlreadyExists: return "sso_domain_already_exists"
        case .ssoProviderNotFound: return "sso_provider_not_found"
        case .tooManyEnrolledMfaFactors: return "too_many_enrolled_mfa_factors"
        case .unexpectedAudience: return "unexpected_audience"
        case .unexpectedFailure: return "unexpected_failure"
        case .userAlreadyExists: return "user_already_exists"
        case .userBanned: return "user_banned"
        case .userNotFound: return "user_not_found"
        case .userSsoManaged: return "user_sso_managed"
        case .validationFailed: return "validation_failed"
        case .weakPassword: return "weak_password"
        case .unknown(let value): return value
        }
    }

    init(rawValue: String) {
        switch rawValue {
        case "anonymous_provider_disabled": self = .anonymousProviderDisabled
        case "bad_code_verifier": self = .badCodeVerifier
        case "bad_json": self = .badJson
        case "bad_jwt": self = .badJwt
        case "bad_oauth_callback": self = .badOauthCallback
        case "bad_oauth_state": self = .badOauthState
        case "captcha_failed": self = .captchaFailed
        case "conflict": self = .conflict
        case "email_address_invalid": self = .emailAddressInvalid
        case "email_address_not_authorized": self = .emailAddressNotAuthorized
        case "email_conflict_identity_not_deletable": self = .emailConflictIdentityNotDeletable
        case "email_exists": self = .emailExists
        case "email_not_confirmed": self = .emailNotConfirmed
        case "email_provider_disabled": self = .emailProviderDisabled
        case "flow_state_expired": self = .flowStateExpired
        case "flow_state_not_found": self = .flowStateNotFound
        case "hook_payload_invalid_content_type": self = .hookPayloadInvalidContentType
        case "hook_payload_over_size_limit": self = .hookPayloadOverSizeLimit
        case "hook_timeout": self = .hookTimeout
        case "hook_timeout_after_retry": self = .hookTimeoutAfterRetry
        case "identity_already_exists": self = .identityAlreadyExists
        case "identity_not_found": self = .identityNotFound
        case "insufficient_aal": self = .insufficientAal
        case "invalid_credentials": self = .invalidCredentials
        case "invite_not_found": self = .inviteNotFound
        case "manual_linking_disabled": self = .manualLinkingDisabled
        case "mfa_challenge_expired": self = .mfaChallengeExpired
        case "mfa_factor_name_conflict": self = .mfaFactorNameConflict
        case "mfa_factor_not_found": self = .mfaFactorNotFound
        case "mfa_ip_address_mismatch": self = .mfaIpAddressMismatch
        case "mfa_phone_enroll_not_enabled": self = .mfaPhoneEnrollNotEnabled
        case "mfa_phone_verify_not_enabled": self = .mfaPhoneVerifyNotEnabled
        case "mfa_totp_enroll_not_enabled": self = .mfaTotpEnrollNotEnabled
        case "mfa_totp_verify_not_enabled": self = .mfaTotpVerifyNotEnabled
        case "mfa_verification_failed": self = .mfaVerificationFailed
        case "mfa_verification_rejected": self = .mfaVerificationRejected
        case "mfa_verified_factor_exists": self = .mfaVerifiedFactorExists
        case "mfa_web_authn_enroll_not_enabled": self = .mfaWebAuthnEnrollNotEnabled
        case "mfa_web_authn_verify_not_enabled": self = .mfaWebAuthnVerifyNotEnabled
        case "no_authorization": self = .noAuthorization
        case "not_admin": self = .notAdmin
        case "oauth_provider_not_supported": self = .oauthProviderNotSupported
        case "otp_disabled": self = .otpDisabled
        case "otp_expired": self = .otpExpired
        case "over_email_send_rate_limit": self = .overEmailSendRateLimit
        case "over_request_rate_limit": self = .overRequestRateLimit
        case "over_sms_send_rate_limit": self = .overSmsSendRateLimit
        case "phone_exists": self = .phoneExists
        case "phone_not_confirmed": self = .phoneNotConfirmed
        case "phone_provider_disabled": self = .phoneProviderDisabled
        case "provider_disabled": self = .providerDisabled
        case "provider_email_needs_verification": self = .providerEmailNeedsVerification
        case "reauthentication_needed": self = .reauthenticationNeeded
        case "reauthentication_not_valid": self = .reauthenticationNotValid
        case "refresh_token_already_used": self = .refreshTokenAlreadyUsed
        case "refresh_token_not_found": self = .refreshTokenNotFound
        case "request_timeout": self = .requestTimeout
        case "same_password": self = .samePassword
        case "saml_assertion_no_email": self = .samlAssertionNoEmail
        case "saml_assertion_no_user_id": self = .samlAssertionNoUserId
        case "saml_entity_id_mismatch": self = .samlEntityIdMismatch
        case "saml_idp_already_exists": self = .samlIdpAlreadyExists
        case "saml_idp_not_found": self = .samlIdpNotFound
        case "saml_metadata_fetch_failed": self = .samlMetadataFetchFailed
        case "saml_provider_disabled": self = .samlProviderDisabled
        case "saml_relay_state_expired": self = .samlRelayStateExpired
        case "saml_relay_state_not_found": self = .samlRelayStateNotFound
        case "session_expired": self = .sessionExpired
        case "session_not_found": self = .sessionNotFound
        case "signup_disabled": self = .signupDisabled
        case "single_identity_not_deletable": self = .singleIdentityNotDeletable
        case "sms_send_failed": self = .smsSendFailed
        case "sso_domain_already_exists": self = .ssoDomainAlreadyExists
        case "sso_provider_not_found": self = .ssoProviderNotFound
        case "too_many_enrolled_mfa_factors": self = .tooManyEnrolledMfaFactors
        case "unexpected_audience": self = .unexpectedAudience
        case "unexpected_failure": self = .unexpectedFailure
        case "user_already_exists": self = .userAlreadyExists
        case "user_banned": self = .userBanned
        case "user_not_found": self = .userNotFound
        case "user_sso_managed": self = .userSsoManaged
        case "validation_failed": self = .validationFailed
        case "weak_password": self = .weakPassword
        default: self = .unknown(rawValue)
        }
    }

    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        self = NetAuthErrorCode(rawValue: code)
    }
}
