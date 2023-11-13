import Foundation
import GameKit

extension ViewModel: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData:") {
            let message = content.replacing("strData:", with: "")
            receivedString(message)
        } else {
            do {
                print("data: \(data)")
                // TODO: Setup lastReceivedData to be updated with user choice instead of hardcoding
                try lastReceivedData = .rock
            } catch {
                print(error)
            }
        }
    }
    
    func sendString(_ message: String) {
        print("sending string \(message)")
        guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
        sendData(encoded, mode: .reliable)
                
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try match?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print(error)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        print("Player exited")
        DispatchQueue.main.async {
            self.inGame = false
            self.isShowingAlert = true
        }
    }
}
