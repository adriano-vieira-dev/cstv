//
//  MatchListView.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MatchListView: View {
    @State private var matches: Matches = [
        Match(
            id: 1,
            beginAt: Date(fromISO8601String: "2024-08-31T08:00:00Z")!,
            opponents: [
                OpponentElement(
                    opponent: Opponent(
                        imageURL: "https://cdn.pandascore.co/images/team/image/135381/157px_betclic_apogee_esports_darkmode.png",
                        name: "Apogee Esports"
                    )
                ),
                OpponentElement(
                    opponent: Opponent(
                        imageURL: "https://cdn.pandascore.co/images/team/image/131389/900px_ence_academy_dec_2023_allmode.png",
                        name: "ENCE Academy"
                    )
                ),
            ],
            serie: Serie(name: "Division 2"),
            league: League(
                imageURL: "https://cdn.pandascore.co/images/league/image/4854/799px-european_pro_league_2023_lightmode-png",
                name: "European Pro League"
            )
        ),
    ]
    @State private var error: Error? = nil
    @State private var loading: Bool = false

    func fetchMatches() {
        loading = true
        PandaScoreService.shared.fetchMatches { result in
            self.loading = false
            switch result {
            case let .failure(error):
                self.error = error
            case let .success(matches):
                self.matches = matches
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

    var emptyState: some View {
        Button("Get Matches") {
            fetchMatches()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
    }

    var listView: some View {
        List {
            ForEach(matches) { match in
                MatchRow(match: match)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    loadingState
                } else if matches.isEmpty {
                    emptyState
                } else {
                    listView
                }
            }
            .alert(
                error?.localizedDescription ?? "Error",
                isPresented: Binding(value: $error)
            ) {}
            .background(Color.background)
            .navigationTitle("Partidas")
        }
    }
}

struct MatchRow: View {
    var match: Match

    let teamFrame = CGSize(width: 60, height: 60)
    let seriesFrame = CGSize(width: 16, height: 16)

    var matchIsLive: Bool {
        match.beginAt < .now
    }

    var cardHeader: some View {
        Text(match.beginAt.relativeFormat())
            .font(.roboto(8))
            .fontWeight(.bold)
            .padding(8)
            .background(matchIsLive ? Color.live : Color.timeBadge.opacity(0.2))
            .clipShape(RoundedCornerShape(corners: [.bottomLeft], radius: 16))
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    var cardContent: some View {
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
        }
        .padding(.vertical, 18.5)
    }

    var cardFooter: some View {
        HStack {
            WebImage(url: URL(string: match.league.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Circle()
            }
            .frame(seriesFrame)
            Text("\(match.league.name) - \(match.serie.name)")
                .font(.roboto(8))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }

    var body: some View {
        VStack(spacing: .zero) {
            cardHeader

            cardContent

            Divider()

            cardFooter
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    MatchListView()
        .preferredColorScheme(.dark)
}
