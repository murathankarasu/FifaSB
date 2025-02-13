//
//  ContentView.swift
//  FifaSB
//
//  Created by Murathan Karasu on 12.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PlayerViewModel() // ✅ @StateObject olarak tanımlandı

    var body: some View {
        PlayerListView(viewModel: viewModel) // ✅ Parametre olarak geçirildi
    }
}

