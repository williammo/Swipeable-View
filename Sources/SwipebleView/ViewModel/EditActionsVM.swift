//
//  EditActionsVM.swift
//  SwipebleView
//
//  Created by Ilya on 10.10.20.
//

import SwiftUI

public enum EditActionColor {
    case edit
    case delete
    case done
    case note
}

extension EditActionColor {
    var value: Color {
        get {
            switch self {
            case .delete: return .red
            case .done: return .green
            case .edit: return .yellow
            case .note: return .blue
            }
        }
    }
}

public struct Action: Identifiable {
    public init(title: String, iconName: String, bgColor: EditActionColor, action: @escaping () -> ()?) {
        self.title = title
        self.iconName = iconName
        self.bgColor = bgColor
        self.action = action
    }
    
    public let id: UUID = UUID.init()
    let title: String
    let iconName: String
    let bgColor: EditActionColor
    let action: () -> ()?
}

open class EditActionsVM: ObservableObject {
    let actions: [Action]
    public init(_ actions: [Action], maxActions: Int) {
        self.actions = Array(actions.prefix(maxActions))
    }
}

public struct EditActions: View {
    
    @ObservedObject var viewModel: EditActionsVM
   // @State var frameSize: CGSize = .zero
    @State var height: CGFloat
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        print("EditActions: = \(geometry.size.width) , \(geometry.size.height)")
        
        return HStack(alignment: .center, spacing: 5) {
            ForEach(viewModel.actions) { action in
                Button(action: {
                    action.action()
                }, label: {
                    VStack (alignment: .center){
                        Image(systemName: action.iconName)
                            .font(.system(size: 20))
                            .padding()
                        
                        if viewModel.actions.count < 4  { // && height > 50
                            Text(action.title)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                        
                    }
                    .frame(height: height)
                    .frame(width: 60)
                    //.frame(maxWidth: (geometry.size.width)/CGFloat(viewModel.actions.count))
                    .padding(8)
                    .background(action.bgColor.value.opacity(0.8))
                    .cornerRadius(10)
                })
                .accentColor(.white)
            }
        }
    }
    
    public var body: some View {
        
        GeometryReader { reader in
            HStack {
                Spacer ()
                self.makeView(reader)
            }.padding(1)
            
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
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), height: 10)
                .previewLayout(.fixed(width: 450, height: 400))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), height: 20)
                .previewLayout(.fixed(width: 450, height: 100))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 2), height: 50)
                .previewLayout(.fixed(width: 450, height: 150))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 3), height: 100)
                .previewLayout(.fixed(width: 450, height: 100))
            
            EditActions(viewModel: EditActionsVM(actions, maxActions: 4), height: 100)
                .previewLayout(.fixed(width: 550, height: 80))
            
            
        }
    }
}

