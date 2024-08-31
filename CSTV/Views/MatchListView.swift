//
//  MatchListView.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MatchListView: View {
    let teamFrame = CGSize(width: 60, height: 60)
    let seriesFrame = CGSize(width: 16, height: 16)

    @State private var matches: Matches = []
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

    @ViewBuilder
    func matchRow(_ match: Match) -> some View {
        VStack(spacing: .zero) {
            Text("AGORA")
                .font(.roboto(8))
                .padding(8)
                .background(Color.live)
                .clipShape(RoundedCornerShape(corners: [.bottomLeft], radius: 16))
                .frame(maxWidth: .infinity, alignment: .trailing)
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

            Divider()

            HStack {
                WebImage(url: URL(string: match.league.imageURL)) { image in
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
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
                matchRow(match)
            }
            .listRowBackground(Color.clear)
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

#Preview {
    MatchListView()
        .preferredColorScheme(.dark)
}
