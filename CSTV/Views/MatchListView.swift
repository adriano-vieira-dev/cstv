//
//  MatchListView.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MatchListView: View {
    @State private var currentPage: Int = 0
    @State private var matches: Matches = []
    @State private var error: Error? = nil
    @State private var loading: Bool = false
    
    @State private var selectedMatch: Match? = nil
    
    // Default pageSize is 20
    let PAGE_SIZE = 20

    var loadingState: some View {
        ProgressView()
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
    }

    var emptyState: some View {
        VStack(spacing: 20) {
            Label("Nenhuma partida encontrada", systemImage: "magnifyingglass")
            Button("Tentar novamente") {
                fetchMatches(page: 1)
            }
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
                    .onTapGesture {
                        selectedMatch = match
                    }
                    .onAppear {
                        if match.id == matches.last?.id {
                            fetchMatches()
                        }
                    }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .refreshable {
            fetchMatches(page: 1)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationDestination(isPresented: Binding(value: $selectedMatch)) {
            if let selectedMatch {
                MatchDetailedView(match: selectedMatch)
            }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if !matches.isEmpty {
                    listView
                } else if loading {
                    loadingState
                } else {
                    emptyState
                }
            }
            .onAppear {
                fetchMatches(page: 1)
            }
            .alert(
                error?.localizedDescription ?? "Error",
                isPresented: Binding(value: $error)
            ) {}
            .background(Color.background)
            .navigationTitle("Partidas")
        }
    }
    
    func fetchMatches(page: Int? = nil) {
        if let page {
            currentPage = page
        } else {
            currentPage += 1
        }
        loading = true
        PandaScoreService.shared.fetchMatches(
            page: currentPage,
            pageSize: PAGE_SIZE
        ) { result in
            self.loading = false
            switch result {
            case let .failure(error):
                self.error = error
            case let .success(matches):
                if page != nil {
                    self.matches = matches
                } else {
                    self.matches.append(contentsOf: matches)
                }
            }
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
        TimelineView(.periodic(from: .now, by: 10)) { _ in
            Text(match.beginAt.relativeFormat())
                .font(.roboto(8))
                .fontWeight(.bold)
                .padding(8)
                .background(matchIsLive ? Color.live : Color.timeBadge.opacity(0.2))
                .clipShape(RoundedCornerShape(corners: [.bottomLeft], radius: 16))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
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
        .padding(.horizontal, 20)
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
            Text(match.fullSerieName)
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
