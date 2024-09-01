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
    let playerFrame = CGSize(width: 48, height: 48)

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
        .padding(.horizontal, 44)
    }

    var matchTime: some View {
        TimelineView(.periodic(from: .now, by: 10)) { _ in
            Text(match.beginAt.relativeFormat())
                .font(.roboto(12))
                .fontWeight(.bold)
                .padding(8)
                .background(
                    Capsule()
                        .fill(matchIsLive ? Color.live : Color.clear)
                )
        }
    }

    @ViewBuilder
    func playerView(player: Player, firstTeam: Bool = true) -> some View {
        HStack(alignment: .bottom, spacing: 16) {
            VStack(alignment: .trailing) {
                Text(player.name)
                    .font(.roboto(14))
                    .fontWeight(.bold)
                Text(player.fullName)
                    .lineLimit(1)
                    .font(.roboto(12))
                    .foregroundColor(.fullname)
            }
            .offset(y: -5)

            WebImage(url: URL(string: player.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(.unknown)
                    .resizable()
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(playerFrame)
            .offset(y: -5)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(
            Color.card
                .clipShape(
                    RoundedCornerShape(
                        corners: [.topRight, .bottomRight],
                        radius: 12
                    )
                )
        )
        .environment(\.layoutDirection, firstTeam ? .leftToRight : .rightToLeft)
    }

    var playersList: some View {
        HStack(alignment: .top) {
            if let firstTeam, let lastTeam {
                VStack(spacing: 16) {
                    if firstTeam.players.isEmpty {
                        Label("Lista vazia", systemImage: "person.crop.circle.badge.questionmark")
                            .font(.roboto(14))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(firstTeam.players) { player in
                            playerView(player: player)
                        }
                    }
                }
                VStack(spacing: 16) {
                    if lastTeam.players.isEmpty {
                        Label("Lista vazia", systemImage: "person.crop.circle.badge.questionmark")
                            .font(.roboto(14))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(lastTeam.players) { player in
                            playerView(player: player, firstTeam: false)
                        }
                    }
                }
            }
        }
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
            VStack(spacing: 20) {
                matchTeams

                matchTime

                playersList
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
            PandaScoreService.shared.fetchTeams([firstID, lastID]) { result in
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
