//
//  SettingEntryView.swift
//  Somniary
//
//  Created by 송태환 on 12/20/25.
//

import SwiftUI

struct SettingEntryView: View {
    @ObservedObject var viewModel: SettingViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SettingEntryView(viewModel: AppContainer.shared.makeSettingViewModel(nil))
}
