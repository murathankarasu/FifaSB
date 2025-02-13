//
//  PlayerDetailView.swift
//  FifaSB
//
//  Created by Murathan Karasu on 13.02.2025.
//
import SwiftUI

struct PlayerDetailView: View {
    var player: Player

    var body: some View {
        VStack {
            Text(player.name)
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()

            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 10) {
                Text("Ülke: \(player.country)")
                Text("Kulüp: \(player.club)")
                Text("Yaş: \(player.age)")
                Text("Piyasa Değeri: \(player.value)")
                Text("Genel Reyting: \(player.rating)")
            }
            .font(.headline)
            .foregroundColor(.green)
            .padding()

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

