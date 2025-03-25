//
//  RichTextLinkButton.swift
//  RichEditorSwiftUI
//
//  Created by Alek Michelson on 3/3/25.
//

import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS) || os(tvOS)
public struct RichTextLinkButton: View {
    @ObservedObject var context: RichEditorState
    
    public init(context: RichEditorState) {
        self._context = ObservedObject(wrappedValue: context)
    }
    
    public var body: some View {
        Button {
            context.insertLink(value: true)
        } label: {
            Image(systemName: "link")
                .foregroundColor(context.link != nil ? .accentColor : .primary)
                .frame(width: 20, height: 20)
                .contentShape(Rectangle())
        }
    }
}
#endif 
