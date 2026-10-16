//
//  RoleTabBar.swift
//  IOSMyloqlogin
//

import SwiftUI

struct RoleTabBar: View {
    @Binding var selectedRole: UserRole
    @Namespace private var tabAnimation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(UserRole.allCases) { role in
                let isSelected = selectedRole == role
                
                Button(action: {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
                        selectedRole = role
                    }
                }) {
                    ZStack {
                        if isSelected {
                            // Same capsule design as the primary Login button
                            Capsule()
                                .fill(MyLooQTheme.primaryPurple)
                                .matchedGeometryEffect(id: "ACTIVE_ROLE_TAB", in: tabAnimation)
                                .shadow(color: MyLooQTheme.primaryPurple.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        Text(role.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(isSelected ? .white : MyLooQTheme.secondaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .contentShape(Rectangle())
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .frame(height: 58)
        .background(
            Capsule()
                .fill(MyLooQTheme.lightGrayBackground)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        RoleTabBar(selectedRole: .constant(.user))
        RoleTabBar(selectedRole: .constant(.provider))
    }
    .padding()
}
