//
//  KeyboardResponder.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 3/30/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//
import SwiftUI
import Combine

// https://stackoverflow.com/questions/56716311/how-to-show-complete-list-when-keyboard-is-showing-up-in-swiftui

final class KeyboardResponder: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published private(set) var keyboardHeight: CGFloat = 0

    let keyboardWillShow = NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillShowNotification)
        .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height  }

    let keyboardWillHide = NotificationCenter.default
      .publisher(for: UIResponder.keyboardWillHideNotification)
      .map { _ -> CGFloat in 0 }

    init() {
      cancellable = Publishers.Merge(keyboardWillShow, keyboardWillHide)
        .subscribe(on: RunLoop.main)
        .assign(to: \.keyboardHeight, on: self)
    }
}
