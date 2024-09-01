//
//  MatchDetailedView.swift
//  CSTV
//
//  Created by Adriano Vieira on 31/08/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MatchDetailedView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstTeam: Team? = nil
    @State private var lastTeam: Team? = nil
    @State private var loading: Bool = false

    var match: Match

    let teamFrame = CGSize(width: 60, height: 60)

    var matchIsLive: Bool {
        match.beginAt < .now
    }

    var matchTeams: some View {
        HStack(spacing: 20) {
            VStack(spacing: 10) {
                WebImage(url: URL(string: match.opponents.first?.opponent.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Circle()
                }
                .frame(teamFrame)
                Text(match.opponents.first?.opponent.name ?? "Team 1")
                    .font(.roboto(10))
            }
            .frame(maxWidth: .infinity)

            Text("vs")
                .font(.roboto(12))
                .foregroundStyle(.white.opacity(0.5))

            VStack(spacing: 10) {
                WebImage(url: URL(string: match.opponents.last?.opponent.imageURL ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Circle()
                }
                .frame(teamFrame)
                Text(match.opponents.last?.opponent.name ?? "Team 2")
                    .font(.roboto(10))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 18.5)
        .padding(.vertical, 44)
    }

    var matchTime: some View {
        Text(match.beginAt.relativeFormat())
            .font(.roboto(12))
            .fontWeight(.bold)
            .padding(8)
            .background(
                Capsule()
                    .fill(matchIsLive ? Color.live : Color.clear)
            )
    }

    var loadingState: some View {
        ProgressView()
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
    }

    var matchView: some View {
        ScrollView {
            VStack {
                matchTeams

                matchTime
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
        }
    }

    var body: some View {
        Group {
            if loading {
                loadingState
            } else {
                matchView
            }
        }
        .onAppear {
            fetchTeams()
        }
        .background(Color.background)
        .navigationTitle(match.fullSerieName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .tint(.white)
                }
            }
        }
    }

    func fetchTeams() {
        if let firstID = match.opponents.first?.opponent.id,
           let lastID = match.opponents.last?.opponent.id {
            loading = true
            PandaScoreService.shared.fetchTeam([firstID, lastID]) { result in
                loading = false
                switch result {
                case .failure:
                    break
                case let .success(teams):
                    self.firstTeam = teams.first { $0.id == firstID }
                    self.lastTeam = teams.first { $0.id == lastID }
                }
            }
        }
    }
}
