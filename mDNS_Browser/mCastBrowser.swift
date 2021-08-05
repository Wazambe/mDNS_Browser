//
//  mCastBrowser.swift
//  mDNS_Browser
//
//  Created by Mark Robberts on 2021/07/22.
//

import UIKit
import Combine
import Network

class mCastBrowser: NSObject, ObservableObject, Identifiable {
  
  struct objectOf:Hashable {
     var id:UUID? = UUID()
     var device:String = ""
     var IsIndexed:Int = 0
  }
  
  @Published var devices: [objectOf] = [] {
    willSet {
      objectWillChange.send()
    }
  }
  
  var browser: NWBrowser!
      
  func scan(typeOf: String, domain: String) {
    ///Primarily use the Network Browser with the Bonjour descriptor
    let bonjourTCP = NWBrowser.Descriptor.bonjour(type: typeOf , domain: domain)
    
    let bonjourParms = NWParameters.init()
        bonjourParms.allowLocalEndpointReuse = true
        bonjourParms.acceptLocalOnly = true
        bonjourParms.allowFastOpen = true
    
    browser = NWBrowser(for: bonjourTCP, using: bonjourParms)
    browser.stateUpdateHandler = {newState in
      switch newState {
      case .failed(let error):
        print("NW Browser: now in Error state: \(error)")
        self.browser.cancel()
      case .ready:
        print("NW Browser: new bonjour discovery - ready")
      case .setup:
        print("NW Browser: ooh, apparently in SETUP state")
      default:
        break
      }
    }
    browser.browseResultsChangedHandler = { ( results, changes ) in
        print("NW Browser: Scan results found:")
      for result in results {
        print(result.endpoint.debugDescription)
        }
      for change in changes {
//        print(change.hashValue)
        if case .added(let added) = change {
            print("NW Browser: Added")
//            case service(name: String, type: String, domain: String, interface: NWInterface?)
///         This is the interesting part - the service has 4 parts - almost matching endpoint
///         because the endpoint has name Type, Domain, but then also metadata, and the last match with the service; interface
//          if case .service(let name, let type, let domain, let interface) = added.endpoint {
///         The real question should be, why not just create an array of endpoints, and keep that as reference?
///         But that  we can do when connecting with endpoint name, because then it is best to refresh
            if case .service(let name, _, _, _) = added.endpoint {
//            let device = objectOf(device: service.name, IsIndexed: self.devices.count)
                let device = objectOf(device: name, IsIndexed: self.devices.count)
//            self.devices.removeAll()
            self.devices.append(device)
          }
            
          if case .removed(let removed) = change {
            print("NW Browser: Removed")
            if case .service(let name, _, _, _) = removed.endpoint {
              let index = self.devices.firstIndex(where:{$0.device == name })
              self.devices.remove(at: index!)
            }
          }
        }
      }
    }
    self.browser.start(queue: DispatchQueue.main)
  }
    
    
    
    
}


