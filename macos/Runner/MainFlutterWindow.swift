import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // 화면의 전체 가용 높이(100%)를 가져와서 창 크기 설정
    if let screen = NSScreen.main {
        let screenRect = screen.visibleFrame // 도크 등을 제외한 실제 가용 영역
        let windowHeight = screenRect.height // 가용 높이 100% 사용
        let windowWidth = windowHeight * (9.0 / 16.0) // 9:16 모바일 비율 유지
        
        let newFrame = NSRect(
            x: screenRect.midX - (windowWidth / 2),
            y: screenRect.origin.y, // 바닥부터 시작
            width: windowWidth,
            height: windowHeight
        )
        
        self.setFrame(newFrame, display: true)
        
        // 창을 화면 맨 앞으로 가져오고 타이틀바를 깔끔하게 처리 (선택 사항)
        self.title = "Divine Defense"
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
