//
//  MatchListView.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SwiftUI

struct MatchListView: View {
    let teamFrame = CGSize.init(width: 60, height: 60)
    let seriesFrame = CGSize.init(width: 16, height: 16)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .zero) {
                    Text("AGORA")
                        .font(.roboto(8))
                        .padding(8)
                        .background(Color.live)
                        .clipShape(RoundedCornerShape(corners: [.bottomLeft], radius: 16))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    HStack(spacing: 20) {
                        VStack(spacing: 10) {
                            Circle()
                                .frame(teamFrame)
                            Text("Team 1")
                                .font(.roboto(10))
                        }
                        
                        Text("vs")
                            .font(.roboto(12))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        VStack(spacing: 10) {
                            Circle()
                                .frame(teamFrame)
                            Text("Team 2")
                                .font(.roboto(10))
                        }
                    }
                    .padding(.vertical, 18.5)
                    
                    Divider()
                    
                    HStack {
                        Circle()
                            .frame(seriesFrame)
                        Text("League + serie")
                            .font(.roboto(8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
                .background(Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .contentMargins(24, for: .scrollContent)
            .background(Color.background)
            .navigationTitle("Partidas")
        }
    }
}

#Preview {
    MatchListView()
        .preferredColorScheme(.dark)
}
