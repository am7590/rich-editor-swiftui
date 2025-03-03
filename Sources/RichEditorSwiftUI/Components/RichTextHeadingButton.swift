//
//  RichTextHeadingButton.swift
//  RichEditorSwiftUI
//
//  Created by Alek Michelson on 3/3/25.
//


import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS) || os(tvOS)
public struct RichTextHeadingButton: View {
    @ObservedObject var context: RichEditorState
    
    private let fontSizes: [(title: String, size: Int)] = [
        ("Default", 17),
        ("Small", 14),
        ("Medium", 20),
        ("Large", 24),
        ("X-Large", 28),
        ("XX-Large", 32),
        ("XXX-Large", 40)
    ]
    
    public init(context: RichEditorState) {
        self._context = ObservedObject(wrappedValue: context)
    }
    
    public var body: some View {
        Menu {
            ForEach(0..<fontSizes.count, id: \.self) { index in
                Button {
                    let fontSize = fontSizes[index].size
                    context.updateStyle(style: .size(fontSize))
                } label: {
                    Text(fontSizes[index].title)
                        .font(.system(size: CGFloat(fontSizes[index].size)))
                }
            }
        } label: {
            Image(systemName: "textformat.size")
                .foregroundColor(context.fontSize != CGFloat(fontSizes[0].size) ? .accentColor : .primary)
                .frame(width: 20, height: 20)
                .contentShape(Rectangle())
        }
    }
}
#endif 
