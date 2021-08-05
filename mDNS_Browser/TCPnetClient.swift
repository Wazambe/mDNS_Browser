//
//  TCPnetClient.swift
//  mDNS_Browser
//
//  Created by Mark Robberts on 2021/08/05.
//

import Foundation
import Network



class TCPnetClient: NSObject, ObservableObject {
    
    @Published var connectState: String = ""

private var netConnect: NWConnection?
    
//MARK: - This is settimng up a new connection once the service is identified/selected
   ///Now we just have to receive incoming data
func bonjourToTCP(called: String, serviceTCPName: String, serviceDomain: String) {
   guard !called.isEmpty else { return }
    
   self.netConnect = NWConnection(to: .service(name: called, type: serviceTCPName, domain: serviceDomain, interface: nil), using: .tcp)
   self.netConnect?.stateUpdateHandler = { (newState) in
       print("bonjourToTCP: Connection details: \(String(describing: self.netConnect?.debugDescription))")
     switch (newState) {
     case .ready:
        self.connectState = "Connection state: Ready"
       print("bonjourToTCP: new TCP connection ready ")
     default:
       break
     }
   }
   self.netConnect?.start(queue: .main)
 }

}
