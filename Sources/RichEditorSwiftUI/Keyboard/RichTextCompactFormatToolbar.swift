//
//  RichTextCompactFormatToolbar.swift
//  RichEditorSwiftUI
//
//  Created on 2024-12-13.
//

#if os(iOS) || os(visionOS)
import SwiftUI

/// This compact toolbar sits above the keyboard and provides
/// essential text formatting options in a scrollable row.
public struct RichTextCompactFormatToolbar: View {
    
    /// Create a rich text compact format toolbar.
    ///
    /// - Parameters:
    ///   - context: The context to affect.
    public init(context: RichEditorState) {
        self._context = ObservedObject(wrappedValue: context)
    }
    
    @ObservedObject
    private var context: RichEditorState
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(RichTextStyle.basicSet2, id: \.self) { style in
                        styleButton(for: style)
                    }
                    
                    divider
                    
                    undoButton
                    redoButton
                    
                    divider
                    
                    dismissKeyboardButton
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
            }
            .background(toolbarBackground)
        }
        .frame(height: 44)
        .overlay(Divider(), alignment: .top)
    }
    
    // MARK: - Views
    
    private var divider: some View {
        Divider()
            .frame(height: 25)
    }
    
    private func styleButton(for style: RichTextStyle) -> some View {
        Button {
            context.toggleStyle(style)
        } label: {
            Image(systemName: style.imageName2)
                .foregroundColor(context.hasStyle(style) ? .accentColor : .primary)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
    }
    
    private var undoButton: some View {
        Button {
            context.actionPublisher.send(.undo)
        } label: {
            Image(systemName: "arrow.uturn.backward")
                .foregroundColor(context.canUndoLatestChange ? .primary : .gray)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
        .disabled(!context.canUndoLatestChange)
    }
    
    private var redoButton: some View {
        Button {
            context.actionPublisher.send(.redo)
        } label: {
            Image(systemName: "arrow.uturn.forward")
                .foregroundColor(context.canRedoLatestChange ? .primary : .gray)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
        .disabled(!context.canRedoLatestChange)
    }
    
    private var dismissKeyboardButton: some View {
        Button {
            #if os(iOS) || os(visionOS)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        } label: {
            Image(systemName: "keyboard.chevron.compact.down")
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
    }
    
    private var toolbarBackground: some View {
        colorScheme == .dark ?
            Color.black.opacity(0.8) :
            Color.white.opacity(0.95)
    }
}

extension RichTextStyle {
    static var basicSet2: [RichTextStyle] = [.bold, .italic, .underline, .strikethrough]
}

extension RichTextStyle {
    var imageName2: String {
        switch self {
        case .bold: return "bold"
        case .italic: return "italic"
        case .underline: return "underline"
        case .strikethrough: return "strikethrough"
        }
    }
}
#endif 
