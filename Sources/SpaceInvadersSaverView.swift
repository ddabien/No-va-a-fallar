import ScreenSaver
import WebKit

public class SpaceInvadersSaverView: ScreenSaverView {
    private var webView: WKWebView!

    public override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = 1.0 / 30.0

        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.websiteDataStore = .nonPersistent()

        webView = WKWebView(frame: bounds, configuration: config)
        webView.autoresizingMask = [.width, .height]
        #if os(macOS)
        webView.setValue(false, forKey: "drawsBackground")
        #endif
        addSubview(webView)

        if let (url, base) = Self.indexURL() {
            _ = webView.loadFileURL(url, allowingReadAccessTo: base)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override var hasConfigureSheet: Bool { false }
    public override var configureSheet: NSWindow? { nil }

    private static func indexURL() -> (URL, URL)? {
        let bundle = Bundle(for: self)
        if let url = bundle.url(forResource: "index", withExtension: "html", subdirectory: "web") {
            return (url, url.deletingLastPathComponent())
        }
        return nil
    }
}
