import UIKit

class ViewController: UIViewController {
    let feeField = UITextField()
    let distField = UITextField()
    let toggle = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "小龙生自动抢单"
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        // 金额设置
        let feeLabel = UILabel()
        feeLabel.text = "最低金额 (元):"
        feeField.text = "7"
        feeField.borderStyle = .roundedRect
        feeField.keyboardType = .numberPad
        
        // 距离设置
        let distLabel = UILabel()
        distLabel.text = "最大距离 (公里):"
        distField.text = "5"
        distField.borderStyle = .roundedRect
        distField.keyboardType = .numberPad
        
        // 开关
        let toggleLabel = UILabel()
        toggleLabel.text = "启用自动抢单:"
        toggle.isOn = true
        
        // 保存按钮
        let saveBtn = UIButton(type: .system)
        saveBtn.setTitle("保存设置", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveSettings), for: .touchUpInside)
        
        stack.addArrangedSubview(feeLabel)
        stack.addArrangedSubview(feeField)
        stack.addArrangedSubview(distLabel)
        stack.addArrangedSubview(distField)
        stack.addArrangedSubview(toggleLabel)
        stack.addArrangedSubview(toggle)
        stack.addArrangedSubview(saveBtn)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        loadSettings()
    }
    
    @objc func saveSettings() {
        let path = "/var/mobile/Library/Preferences/com.xiaolong.grab.plist"
        let dict: [String: Any] = [
            "minFee": Int(feeField.text ?? "7") ?? 7,
            "maxDist": Int(distField.text ?? "5") ?? 5,
            "enabled": toggle.isOn
        ]
        let url = URL(fileURLWithPath: path)
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        (dict as NSDictionary).write(toFile: path, atomically: true)
        
        let alert = UIAlertController(title: "提示", message: "设置已保存，下次抢单生效！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好", style: .default))
        present(alert, animated: true)
    }
    
    func loadSettings() {
        let path = "/var/mobile/Library/Preferences/com.xiaolong.grab.plist"
        if let dict = NSDictionary(contentsOfFile: path) {
            feeField.text = "\(dict["minFee"] ?? 7)"
            distField.text = "\(dict["maxDist"] ?? 5)"
            toggle.isOn = dict["enabled"] as? Bool ?? true
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
