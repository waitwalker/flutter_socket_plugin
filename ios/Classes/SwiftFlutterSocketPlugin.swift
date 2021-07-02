import Flutter
import UIKit
import CocoaAsyncSocket 

// MARK: Flutter socket plugin
public class SwiftFlutterSocketPlugin: NSObject, FlutterPlugin {
    
    var registrar: FlutterPluginRegistrar
    
    /// init function
    ///
    /// - Parameter _registrar: FlutterPluginRegistrar
    init(_ _registrar: FlutterPluginRegistrar){
        registrar = _registrar
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_socket_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterSocketPlugin(registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
    FlutterSocket.sharedInstance.createChannel(registrar: registrar)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "create_socket" {
        if let arguments = call.arguments {
            let dic = arguments as! [String:Any]
            let host = dic["host"]
            let port = dic["port"]
            let timeout = dic["timeout"]
            if host == nil || port == nil {
                let str = EncoderTool.encodeWithDictionary(dictionary: ["error_message":"Host or port is required."])
                FlutterSocket.sharedInstance.invoke(methodName: "error", arguments: str)
            } else {
                FlutterSocket.sharedInstance.host = host as? String
                FlutterSocket.sharedInstance.port = UInt16(port as! Int)
                FlutterSocket.sharedInstance.timeout = timeout == nil ? 20 : (timeout as! TimeInterval)
                FlutterSocket.sharedInstance.createSocket()
            }
        } else {
            let str = EncoderTool.encodeWithDictionary(dictionary: ["error_message":"Host or port is required."])
            FlutterSocket.sharedInstance.invoke(methodName: "error", arguments: str)
        }
    } else if call.method == "try_connect" {
        
        FlutterSocket.sharedInstance.tryConnect(host: FlutterSocket.sharedInstance.host, port: FlutterSocket.sharedInstance.port, timeout: FlutterSocket.sharedInstance.timeout)
        
    } else if call.method == "send_message" {
        if let arguments = call.arguments {
            let dic = arguments as! [String:Any]
            let message = dic["message"]
            if message == nil {
                let str = EncoderTool.encodeWithDictionary(dictionary: ["error_message":"Sending content cannot be empty."])
                FlutterSocket.sharedInstance.invoke(methodName: "error", arguments: str)
            } else {
                FlutterSocket.sharedInstance.send(message: message as! String)
            }
        } else {
            let str = EncoderTool.encodeWithDictionary(dictionary: ["error_message":"Sending content cannot be empty."])
            FlutterSocket.sharedInstance.invoke(methodName: "error", arguments: str)
        }
    } else if call.method == "try_disconnect" {
        FlutterSocket.sharedInstance.tryDisconnect()
    }
  }
}

// MARK: Flutter socket class
class FlutterSocket:NSObject, GCDAsyncSocketDelegate {

    /// 单例
    static let sharedInstance = FlutterSocket()

    /// 是否连接
    var connected:Bool = false

    /// GCDAsyncSocket
    var socket:GCDAsyncSocket!
    
    /// heart 
    var heartTimer:Timer!

    /// method channel
    var methodChannel:FlutterMethodChannel!
    
    /// host
    var host:String!
    
    /// port
    var port:UInt16!
    
    /// timeout
    var timeout:TimeInterval = 30
    
    private override init() {}

    
    /// create method channel
    ///
    /// - Parameter registrar: FlutterPluginRegistrar
    public func createChannel(registrar: FlutterPluginRegistrar) -> Void {
        if methodChannel == nil {
            methodChannel = FlutterMethodChannel(name: "flutter_socket_plugin", binaryMessenger: registrar.messenger())
        }
    }
    
    
    /// create socket
    ///
    /// - Returns: create is successful
    public func createSocket() -> Void {
        if socket == nil {
            socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        }
    }

    /// try connect to socket 
    ///
    /// - Parameters:
    ///   - host: host,usually ip address or domain
    ///   - port: port type is UInt16
    ///   - timeout: timeout default 30s
    public func tryConnect(host:String,port:UInt16,timeout:TimeInterval) -> Void {
        if socket != nil {
            do {
                try socket.connect(toHost: host, onPort: port, viaInterface: nil, withTimeout: timeout)
            } catch (let error) {
                print(error)
                let str = EncoderTool.encodeWithDictionary(dictionary: ["error_message":error.localizedDescription])
                invoke(methodName: "error", arguments: str)
                connected = false
            }
        } else {
            connected = false
        }
    }

    /// try disconnect to socket
    public func tryDisconnect() -> Void {
        if socket != nil {
            socket.disconnect()
        } else {
            connected = false
        }
    }

    /// send message only support string type at this time
    ///
    /// - Parameter message: message
    public func send(message:String) -> Void {
        if connected {
            let fullMessage:String = message + "||";
            let contentData:Data = fullMessage.data(using: String.Encoding.utf8)!
            let value:Int = contentData.count
            
            var byteData:[UInt8] = []
            let byte_0:UInt8 = UInt8((value & 0xFF000000) >> 96)
            let byte_1:UInt8 = UInt8((value & 0xFF000000) >> 88)
            let byte_2:UInt8 = UInt8((value & 0xFF000000) >> 80)
            let byte_3:UInt8 = UInt8((value & 0xFF000000) >> 72)
            let byte_4:UInt8 = UInt8((value & 0xFF000000) >> 64)
            let byte_5:UInt8 = UInt8((value & 0xFF000000) >> 56)
            let byte_6:UInt8 = UInt8((value & 0xFF000000) >> 48)
            let byte_7:UInt8 = UInt8((value & 0xFF000000) >> 40)
            let byte_8:UInt8 = UInt8((value & 0xFF000000) >> 32)
            let byte_9:UInt8 = UInt8((value & 0xFF000000) >> 24)
            let byte_10:UInt8 = UInt8((value & 0xFF000000) >> 16)
            let byte_11:UInt8 = UInt8((value & 0xFF000000) >> 8)
            let byte_12:UInt8 = UInt8((value & 0xFF000000))
            byteData.append(byte_0)
            byteData.append(byte_1)
            byteData.append(byte_2)
            byteData.append(byte_3)
            byteData.append(byte_4)
            byteData.append(byte_5)
            byteData.append(byte_6)
            byteData.append(byte_7)
            byteData.append(byte_8)
            byteData.append(byte_9)
            byteData.append(byte_10)
            byteData.append(byte_11)
            byteData.append(byte_12)
            
            let headData = Data(byteData)
            let send_data = NSMutableData()
            send_data.append(headData)
            send_data.append(contentData)
            
            socket.write(send_data as Data, withTimeout: -1, tag: 0)
        }
    }
    
    /// ios invokes flutter method and transfers arguments
    ///
    /// - Parameters:
    ///   - methodName: methodName 
    ///   - arguments: arguments
    public func invoke(methodName:String,arguments:String) -> Void {
        methodChannel.invokeMethod(methodName, arguments: arguments)
    }
    
    /// add heart
    private func addHeartTimer() -> Void {
        heartTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(heartAction), userInfo: nil, repeats: true)
        RunLoop.current.add(heartTimer, forMode: RunLoop.Mode.common)
    }

    @objc func heartAction() -> Void {
        let heartString = "h**eart||hear**t||hear**t"
        let data:Data = heartString.data(using: String.Encoding.utf8)!
        socket.write(data, withTimeout: -1, tag: 0)
    }
    
    
    
    
    /// GCDAsyncSocket didConnect call back
    ///
    /// - Parameters:
    ///   - sock: GCDAsyncSocket
    ///   - host: host
    ///   - port: port
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        addHeartTimer()
        connected = true
        socket.readData(withTimeout: -1, tag: 0)
        methodChannel.invokeMethod("connected", arguments: "connected")
    }
    
    /// GCDAsyncSocket didRead call back
    ///
    /// - Parameters:
    ///   - sock: GCDAsyncSocket
    ///   - data: data
    ///   - tag: tag
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data, encoding: String.Encoding.utf8)
        if message != nil {
            methodChannel.invokeMethod("receive_message", arguments: message)
        }
        socket.readData(withTimeout: -1, tag: 0)
    }

    /// GCDAsyncSocket didDisconnect call back
    ///
    /// - Parameters:
    ///   - sock: GCDAsyncSocket
    ///   - err: error
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        socket.delegate = nil
        socket = nil
        connected = false
        if heartTimer != nil {
            heartTimer.invalidate()
        }
        methodChannel.invokeMethod("disconnect", arguments: "disconnected")
    }

}

// MARK: encoder dictionary to json string
class EncoderTool: NSObject {
    
    /// dictionary to json
    ///
    /// - Parameter dictionary: dictionary
    /// - Returns: json string
    static func encodeWithDictionary(dictionary:[String:Any]) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            return ""
        }
        if let jsonData = try? JSONSerialization.data(
            withJSONObject: dictionary, 
            options: []) {
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            if let str = jsonString {
                return str
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}
