//
//  ProviderBottomTabBar.swift
//  IOSMyloqlogin
//

import SwiftUI

struct ProviderBottomTabBar: View {
    @Binding var selectedTab: ProviderTab
    
    var body: some View {
        HStack {
            // 1. Home Tab (with active capsule pill)
            Button(action: {
                selectedTab = .home
            }) {
                if selectedTab == .home {
                    HStack(spacing: 8) {
                        Image(systemName: "house")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Home")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color(hex: "2A2A2E"))
                    )
                } else {
                    Image(systemName: "house")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "6E6E73"))
                        .padding(.horizontal, 16)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // 2. Orders / Bookings Tab
            Button(action: {
                selectedTab = .orders
            }) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == .orders ? .white : Color(hex: "6E6E73"))
                    .padding(8)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // 3. Wallet Tab
            Button(action: {
                selectedTab = .wallet
            }) {
                Image(systemName: "creditcard")
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == .wallet ? .white : Color(hex: "6E6E73"))
                    .padding(8)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // 4. Profile Tab
            Button(action: {
                selectedTab = .profile
            }) {
                Image(systemName: "person")
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == .profile ? .white : Color(hex: "6E6E73"))
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 22)
        .background(
            Color.black
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    VStack {
        Spacer()
        ProviderBottomTabBar(selectedTab: .constant(.home))
    }
}
