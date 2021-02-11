//
//  SocketIOHelper.swift
//  Pods-SocketIOClient_Example
//
//  Created by Rz Rasel on 2021-02-11
//

import Foundation
import SocketIO

public class SocketIOHelper {
    private var socketManager: SocketManager!
    public var socket: SocketIOClient!
    public var resetAckEmitter: SocketAckEmitter?
    private var httpURL = ""
    private var isLog = false
    private var connectParams: [String: Any] = [String: Any]()
//    static let sharedInstance = SocketIOManager()
    public var isConnected = false
    var onListenerSocketIO: ((String, Any, SocketAckEmitter) -> Void)!
//    public var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)!
    //
    public init(isLog argIsLog: Bool) {
        isConnected = false
        isLog = argIsLog
        connectParams.removeAll()
    }
    public func params(key argKey: String, value argValue: Any) -> SocketIOHelper {
        connectParams[argKey] = argValue
        return self
    }
    public func with(url argURL: String) -> SocketIOHelper {
        httpURL = argURL
        return self
    }
    public func prepareConnection() {
        prepare()
    }
    public func prepare() {
        guard let url = URL(string: httpURL) else {
            debugLog(message: "Error: url can't parse \(httpURL)")
            return
        }
//        debugLog(message: "Socket manager url: \(httpURL)")
        print("DEBUG_SOCKET_IO_MANAGER: connection URL" + " \(self.httpURL) File: \(#file) Line: \(#line)")
        print("DEBUG_SOCKET_IO_MANAGER: connection params" + " File: \(#file) Line: \(#line)")
        print(connectParams)
//        print("DEBUG_SOCKET_IO_MANAGER: " + " \(self.httpURL) File: \(#file) Line: \(#line)")
        socketManager = SocketManager(socketURL:  url, config: [.log(isLog), .reconnectWait(6000), .connectParams(connectParams), .forceWebsockets(true), .compress])
        socket = socketManager.defaultSocket
//        self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
    }
    //
    public func connect(handler: @escaping (Any, SocketAckEmitter?) -> Void) {
        socket.on(clientEvent: .connect) {data, ack in
            print("DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid) File: \(#file) Line: \(#line)")
            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(SocketClientEvent.connect) \(self.httpURL) File: \(#file) Line: \(#line)")
//            handler(data, ack)
//            onEventSocketIO!(data, ack)
        }
    }
    //
//    @available(*, deprecated, message: "Try to don't use it")
//    public func socketOn(name: String, params: SocketData!, handler: @escaping (Any, SocketAckEmitter) -> Void) {
    public func socketOn(name: String, handler: @escaping (String, Any, SocketAckEmitter) -> Void) {
//        debugLog(message: "SOCKET_NAME: \(name)")
//        prepareConnection()
        socket.on(clientEvent: .connect) {data, ack in
//            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid)")
            print("DEBUG_SOCKET_IO_MANAGER: SOCKET_ID or sid: \(self.socket.sid) File: \(#file) Line: \(#line)")
            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(SocketClientEvent.connect) \(self.httpURL) File: \(#file) Line: \(#line)")
//            self.socket.emit(name, emitParam!)
        }
//        self.socket.emit(name, params)
        socket.on(name) {data, ack in
//            self.debugLog(message: "DEBUG_SOCKET_IO_MANAGER: Socket on \(name) \(data) : \(self.httpURL)")
            print("DEBUG_SOCKET_IO_MANAGER: socket name: \(name) File: \(#file) Line: \(#line)")
            handler(name, data, ack)
            onEventSocketIO(name, data, ack)
        }
        if (self.socket?.status == .disconnected || self.socket?.status == .notConnected ) {
            socketManager.connect()
            socket.connect()
        }
    }
    public func emit(name: String, params: SocketData) {
        self.socket.emit(name, params)
//        print("\(name) \(params)")
    }
    public func disconnect() {
        close()
        
    }
    public func close() {
        if socket == nil {
            return
        }
        isConnected = false
        socket.disconnect()
        socket = nil
        debugLog(message: "close")
    }
    public func getSocket() -> SocketIOClient {
        return socket
    }
    public func getStatus() -> SocketIOStatus? {
        guard let status = self.socket?.status else{ return nil }
        return status
    }
    public func debugLog(message: String) {
        print("DEBUG_SOCKET_IO_MANAGER: \(message) \(self.httpURL) File: \(#file) Line: \(#line)")
    }
}
public var onEventSocketIO: ((String, Any, SocketAckEmitter) -> Void)!
