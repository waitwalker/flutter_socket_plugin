import Flutter
import UIKit
import CocoaAsyncSocket 


public class SwiftFlutterSocketPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_socket_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSocketPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if call.method == "createSocket" {
        let isSuccess:Bool = FlutterSocket.sharedInstance.createSocket()
        result(isSuccess)
    }


  }
}


class FlutterSocket:NSObject, GCDAsyncSocketDelegate {

    /// 单例
    static let sharedInstance = FlutterSocket()

    /// 是否连接
    var connected:Bool = false

    var socket:GCDAsyncSocket!

    var heartTimer:Timer!


    private override init() {

    }

    // MARK: create socket
    func createSocket() -> Bool {
        if socket == nil {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
            return true
        }
        return false
    }

    // MARK: 尝试连接
    func tryConnect(host:String,port:UInt16,timeout:TimeInterval) -> Void {
        if socket != nil {
            do {
                try socket.connect(toHost: host, onPort: port, viaInterface: nil, withTimeout: timeout)
            } catch _ {
                connected = false
            }
        } else {
            connected = false
        }
    }

    // MARK: 尝试断开连接
    func tryDisconnect() -> Void {
        if socket != nil {
            socket.disconnect()
        } else {
            connected = false
        }
    }

    // MARK: 发消息
    func send(message:String) -> Void {
        if connected {
            let data:Data = message.data(using: String.Encoding.utf8)!
            socket.write(data, withTimeout: -1, tag: 0)
        }
    }

    // MARK: 添加心跳
    func addHeartTimer() -> Void {
        heartTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(heartAction), userInfo: nil, repeats: true)
        RunLoop.current.add(heartTimer, forMode: RunLoopMode.commonModes)
    }

    @objc func heartAction() -> Void {
        let heartString = "heart"
        let data:Data = heartString.data(using: String.Encoding.utf8)!
        socket.write(data, withTimeout: -1, tag: 0)
    }


    // MARK: socket delegate: client did connect to server
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        addHeartTimer()
        connected = true
    }

    // MARK: 读取数据
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message:String = String(data: data, encoding: String.Encoding.utf8) ?? ""
        print(message)
    }

    // MARK: 断开连接
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        socket.delegate = nil
        socket = nil
        connected = false
        if heartTimer != nil {
            heartTimer.invalidate()
        }
    }

}
