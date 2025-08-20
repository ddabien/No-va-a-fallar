import ScreenSaver
import WebKit

@objc(SpaceInvadersSaverView) // <-- fuerza el nombre ObjC que busca Info.plist
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
        } else {
            let html = """
            <!doctype html><meta charset="utf-8">
            <title>Falta index.html</title>
            <style>html,body{height:100%;margin:0;background:#000;color:#fff;display:grid;place-items:center;font-family:-apple-system,Helvetica,Arial}</style>
            <div>Falta <code>Resources/web/index.html</code> en el bundle.</div>
            """
            webView.loadHTMLString(html, baseURL: nil)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override var hasConfigureSheet: Bool { false }
    public override var configureSheet: NSWindow? { nil }

    private static func indexURL() -> (URL, URL)? {
        let bundle = Bundle(for: self)
        // Primero intenta Resources/web/index.html
        if let url = bundle.url(forResource: "index", withExtension: "html", subdirectory: "web") {
            return (url, url.deletingLastPathComponent())
        }
        // Fallback: busca cualquier index.html en el bundle
        if let urls = bundle.urls(forResourcesWithExtension: "html", subdirectory: nil) {
            if let idx = urls.first(where: { $0.lastPathComponent.lowercased() == "index.html" }) {
                return (idx, idx.deletingLastPathComponent())
            }
        }
        return nil
    }
}
