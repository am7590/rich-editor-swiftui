#if os(iOS) || os(visionOS)
import UIKit
import UniformTypeIdentifiers

extension RichTextCoordinator: UITextPasteDelegate {
    
    public func textPasteConfigurationSupporting(
        _ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting,
        transform item: UITextPasteItem
    ) {
        // Let default paste behavior occur first
        item.setDefaultResult()
        
        // Process paste after a short delay to avoid update cycle conflicts
        if item.itemProvider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            // Add a small delay to avoid view update cycle conflicts
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                
                item.itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (data, error) in
                    guard let self = self else { return }
                    
                    var pastedText: String?
                    
                    // Handle text data in different formats
                    if let string = data as? String {
                        pastedText = string
                    } else if let textData = data as? Data, 
                              let string = String(data: textData, encoding: .utf8) {
                        pastedText = string
                    }
                    
                    if let text = pastedText {
                        // Always process on main thread, but with a slight delay
                        DispatchQueue.main.async {
                            self.detectAndFormatLinks(in: text)
                        }
                    }
                }
            }
        }
    }
    
    private func detectAndFormatLinks(in text: String) {
        // Use NSDataDetector to find links in the text
        let types = NSTextCheckingResult.CheckingType.link.rawValue
        let detector = try? NSDataDetector(types: types)
        
        guard let detector = detector else { return }
        
        let matches = detector.matches(
            in: text,
            options: [],
            range: NSRange(location: 0, length: text.utf16.count)
        )
        
        // Only proceed if we found at least one link
        guard !matches.isEmpty else { return }
        
        for match in matches {
            if let url = match.url {
                // Use a separate function to update the link state to avoid view update conflicts
                self.applyLinkFormatting(url: url)
                // We only handle the first URL for now
                break
            }
        }
    }
    
    // Separate function to update link state to better control timing
    private func applyLinkFormatting(url: URL) {
        // Add additional delay to ensure we're outside of any view update cycle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Apply link formatting to the detected URL
            self.context.actionPublisher.send(.setLink(url.absoluteString))
            
            // Update the editor's link state
            self.context.link = url.absoluteString
        }
    }
    
    // Setup method to be called during coordinator initialization
    public func setupPasteDetection() {
        if let textView = textView as? UITextView {
            textView.pasteDelegate = self
        }
    }
}
#endif 
