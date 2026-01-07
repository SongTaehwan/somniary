//
//  SettingEnvironment.swift
//  Somniary
//
//  Created by 송태환 on 1/7/26.
//

import Foundation

struct SettingEnvironment {
    let reducerEnv: SettingReducerEnvironment
}

struct SettingReducerEnvironment {
    let useCaseResolutionResolver: any UseCaseResolutionResolving
    let makeRequestId: () -> UUID
}
