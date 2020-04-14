//
//  BottomSheetView.swift
//  HealthExpLog
//
//  Created by ARMSTRONG on 1/25/20.
//  Copyright © 2020 ARMSTRONG. All rights reserved.
//

import SwiftUI

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .pressing, .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

struct BottomSheetView<Content>: View  where Content: View{

    @Binding var isShow: Bool
    
    @GestureState private var dragState = DragState.inactive
    
    let content: ()-> Content
    
    var body: some View {
        GeometryReader { geometry in
             VStack {
                 
                 Spacer()
                                  
                 HandleBar()
                 
                 ScrollView(.vertical){
                     self.content()
                         .animation(.easeIn)
                         .background(Color.white)
                         .cornerRadius(10, antialiased: true)
                         .disabled(self.dragState.isDragging)
                 }
             }
             .offset(y: geometry.size.height/6 + self.dragState.translation.height)
             .animation(.interpolatingSpring(stiffness: 200.0, damping: 25.0, initialVelocity: 10.0))
             .edgesIgnoringSafeArea(.all)
               .gesture(DragGesture()
               .updating(self.$dragState, body: { (value, state, transaction) in
                 if value.translation.height > 0 {
                     state = .dragging(translation: value.translation)
                 }
             })
               .onEnded( { value in
                 if value.translation.height > geometry.size.height * 0.5 {
                     self.isShow = false
                 }
             })
           )
         } // GeometryReader
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isShow: .constant(true)) {
            Text("Botton Sheet View")
        }
    }
}

struct HandleBar: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 50.0, height: 5.0)
                .foregroundColor(Color(.systemGray5))
                .cornerRadius(5.0)
        }
    }
}

struct TriangleBar: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 50.0, height: 5.0)
                .foregroundColor(Color(.systemGray5))
                .cornerRadius(5.0)
            Text("TriangleBar !")
        }
    }
}
