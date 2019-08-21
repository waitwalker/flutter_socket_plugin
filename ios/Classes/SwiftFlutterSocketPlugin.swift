import Flutter
import UIKit
import CocoaAsyncSocket 


public class SwiftFlutterSocketPlugin: NSObject, FlutterPlugin {
    
    var registrar: FlutterPluginRegistrar
    
    init(_ _registrar: FlutterPluginRegistrar){
        registrar = _registrar
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_socket_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSocketPlugin(registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    FlutterSocket.sharedInstance.createChannel(registrar: registrar)
    if call.method == "create_socket" {
        let isSuccess:Bool = FlutterSocket.sharedInstance.createSocket()
        result(isSuccess)
    } else if call.method == "try_connect" {
        
        if let arguments = call.arguments {
            print("Flutter发给原生的参数:\(arguments)")
            let dic = arguments as! [String:Any]
            let host = dic["host"]
            let port = dic["port"]
            let timeout = dic["timeout"]
            if host == nil || port == nil {
                /// 调用错误invoke
                FlutterSocket.sharedInstance.invoke(methodName: "connect_error", arguments: "Host or port is required.")
            } else {
                FlutterSocket.sharedInstance.tryConnect(host: host as! String, port: UInt16(port as! Int), timeout: timeout as! TimeInterval)
            }
        } else {
            /// 调用错误invoke
            FlutterSocket.sharedInstance.invoke(methodName: "connect_error", arguments: "Host or port is required.")
        }
        
    } else if call.method == "send_message" {
        if let arguments = call.arguments {
            print("Flutter发给原生的参数:\(arguments)")
            let dic = arguments as! [String:Any]
            let message = dic["message"]
            if message == nil {
                /// 调用错误invoke
                FlutterSocket.sharedInstance.invoke(methodName: "send_error", arguments: "Sending content cannot be empty.")
            } else {
                FlutterSocket.sharedInstance.send(message: message as! String)
            }
        } else {
            /// 调用错误invoke
            FlutterSocket.sharedInstance.invoke(methodName: "send_error", arguments: "Sending content cannot be empty.")
        }
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

    var methodChannel:FlutterMethodChannel!
    
    private override init() {
        
    }

    func createChannel(registrar: FlutterPluginRegistrar) -> Void {
        if methodChannel == nil {
            methodChannel = FlutterMethodChannel(name: "flutter_socket_plugin", binaryMessenger: registrar.messenger())
        }
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
            } catch (let error) {
                print(error)
                invoke(methodName: "connect_error", arguments: error.localizedDescription)
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
    
    func invoke(methodName:String,arguments:String) -> Void {
        methodChannel.invokeMethod(methodName, arguments: arguments)
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
        methodChannel.invokeMethod("connected", arguments: "connected")
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
