//
//  EditActions.swift
//  
//
//  Created by Ilya on 13.10.20.
//

import SwiftUI


enum ActionSide: CaseIterable {
    case left
    case right
}

public struct EditActions: View {
    
    @ObservedObject var viewModel: EditActionsVM
    @Binding var offset: CGSize
    @Binding var state: ViewState
    @Binding var onChangeSwipe: OnChangeSwipe
    @State var side: ActionSide
    @State var rounded: Bool
    
    
    fileprivate func makeActionView(_ action: Action, height: CGFloat) -> some View {
        return VStack (alignment: .center, spacing: 0){
            #if os(macOS)
            Image(action.iconName)
                .font(.system(size: 20))
                .padding(.bottom, 8)
            #endif
            #if os(iOS)
            Image(systemName: action.iconName)
                .font(.system(size: 20))
                .padding(.bottom, 8)
            #endif
            if viewModel.actions.count < 4 && height > 50 {
                
                Text(action.title)
                    .font(.system(size: 10, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .frame(width: 80)
            }
        }
        .padding()
        .frame(width: getWidth(), height: height)
        .background(action.bgColor.value.saturation(0.8))
        .cornerRadius(rounded ? 10 : 0)
        
    }
    private func getWidth() -> CGFloat {
        let width = CGFloat(abs(offset.width) / CGFloat(viewModel.actions.count))
        
        if width < 80  {
            return 80
        } else {
            return rounded ? width - 5 : width
        }
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        #if DEBUG
        //print("EditActions: = \(geometry.size.width) , \(geometry.size.height)")
        #endif
        
        return HStack(alignment: .center, spacing: rounded ? 5 : 0) {
            ForEach(viewModel.actions) { action in
                Button(action: {
                    action.action()
                    
                    withAnimation(.easeOut) {
                        self.offset = CGSize.zero
                        self.state = .center
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(Animation.easeOut) {
                            if self.state == .center {
                                self.onChangeSwipe = .noChange
                            }
                        }
                    }
                    
                }, label: {
                    #if os(iOS)
                    self.makeActionView(action, height: geometry.size.height)
                        .accentColor(.white)
                    #endif
                    
                    #if os(macOS)
                    self.makeActionView(action, height: geometry.size.height)
                        .colorMultiply(.white)
                    #endif

                    
                })
            }
        }
    }
    
    public var body: some View {
        
        GeometryReader { reader in
            HStack {
                if self.side == .left { Spacer () }
                
                self.makeView(reader)
                
                if self.side == .right { Spacer () }
            }
            
        }
    }
}

struct EditActions_Previews: PreviewProvider {
    
    static var actions = [
        Action(title: "No interest", iconName: "trash", bgColor: .delete, action: {}),
        Action(title: "Request offer", iconName: "doc.text", bgColor: .edit, action: {}),
        Action(title: "Order", iconName: "doc.text.fill", bgColor: .delete, action: {}),
        Action(title: "Order provided", iconName: "car", bgColor: .done, action: {}),
    ]
    static var previews: some View {
        Group {
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), offset: .constant(.zero), state: .constant(.center), onChangeSwipe: .constant(.noChange), side: .right, rounded: false)
                .previewLayout(.fixed(width: 450, height: 400))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), offset: .constant(.zero), state: .constant(.center), onChangeSwipe: .constant(.noChange), side: .left, rounded: false)
                .previewLayout(.fixed(width: 450, height: 100))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 2), offset: .constant(.zero), state: .constant(.center), onChangeSwipe: .constant(.noChange), side: .left, rounded: false)
                .previewLayout(.fixed(width: 450, height: 150))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 3), offset: .constant(.zero), state: .constant(.center), onChangeSwipe: .constant(.noChange), side: .right, rounded: true)
                .previewLayout(.fixed(width: 450, height: 100))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), offset: .constant(.zero), state: .constant(.center), onChangeSwipe: .constant(.noChange), side: .left, rounded: true)
                .previewLayout(.fixed(width: 550, height: 180))
            
            
        }
    }
}

