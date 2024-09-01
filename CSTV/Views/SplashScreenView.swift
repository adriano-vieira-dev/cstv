//
//  SplashScreenView.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var showSplash = true
    
    // Given time to keep the fuze logo on screen
    let SPLASH_SCREEN_TIME = 2000
    
    var splash: some View {
        Image(.fuze)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .background(Color.background)
    }
    
    var body: some View {
        if showSplash {
            splash
                .onAppear {
                    onAppear()
                }
        } else {
            MatchListView()
        }
    }
    
    func onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(SPLASH_SCREEN_TIME)) {
            withAnimation {
                showSplash = false
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
