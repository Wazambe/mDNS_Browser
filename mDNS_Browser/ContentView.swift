//
//  ContentView.swift
//  mDNS_Browser
//
//  Created by Mark Robberts on 2021/07/21.

//  Check out: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/NetServices/Articles/NetServicesArchitecture.html

//Check out: https://developer.apple.com/news/?id=0oi77447

//Add to Info.plist: Privacy -> Local Network Usage Description
//Add to Info.plist: Bonjour services Item 0 ->    _mytype._tcp
//  (obviously the actual service type that one would be using)

import SwiftUI

struct ContentView: View {

    @ObservedObject var bonBrowser = mCastBrowser()
    
    @State private var serviceType   = "_mytype._tcp"
    @State private var netDomain = "local."
    @State private var isSelected = false
    @State private var deviceName: String = ""
    
    @ObservedObject var tcpNetServer = TCPnetServer()
    @State var stopStr = false
    @State var startSvr = false
    
    @ObservedObject var tcpNetClient = TCPnetClient()
    @State var searchSvr = false
    @State var connectSvr = false
    
    
    
    var body: some View {
//        Probably best to run on 2 seperate devices.
//        Ensure that Domain and Service name match.
        VStack {

            VStack {
                Text("Browser")
                    .font(.callout)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text("Scan the local network, and list all devices of given type")
                    .font(.caption)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)

                
                Button(action: {
                    self.bonBrowser.scan(typeOf: serviceType, domain: netDomain)
                }, label: {
                    Text("Search devices")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                })
                .padding( 12)
                .colorInvert()
                .background(Capsule())
                
                List {
                  ForEach(bonBrowser.devices, id: \.self) { each in
                          Text(each.device)
                          .onTapGesture {
                            self.deviceName = each.device
                            self.isSelected.toggle()
                    }
                      }
                  .listRowBackground(isSelected ? Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)): Color.clear)
                  }
                
                Button(action: {
                    self.connectSvr = true
                    self.tcpNetClient.bonjourToTCP(called: self.deviceName, serviceTCPName: serviceType, serviceDomain: netDomain)
                }, label: {
                    Text("Connect to device")
                        .foregroundColor(.white)
                })
                .padding(12)
                .background(Capsule().fill(Color.green) )
                .padding(.bottom, 8)
                
                Text(tcpNetClient.connectState)
                    .padding(.bottom)
                
            }
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 16).stroke())
            
 // Service and domain details
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    Text("Service Type ")
                    Text("Domain ")
                        .padding(.top, 2)
                }
                .foregroundColor(.gray)
                VStack(alignment: .center) {
                    ///Service type in the format - underscore name dot underscore protocol -
                    ///should one want to scan all, then it seems that special entitlment needs to be obtained from Apple
                    ///For testing one can use a Bonjour browser tool, and use service type from one of the availables e.g. _rdlink._tcp
                    TextField("Service Type", text: $serviceType)
                        .border(Color.gray)
                    ///Almost always just local.
                    ///Going ouside of the local is a whole other story
                    TextField("Domain", text: $netDomain)
                        .border(Color.gray)
                }
            }
//  The Broadcaster part, making itself available as service with unique device name
            VStack{
                Text("Broadcast - Listener")
                    .font(.callout)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text("announce the service on the selected network, \n and then listen for incoming connections.")
                    .font(.caption)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                
                Button(action: {
//                  self.bonBrowser.scan(typeOf: serviceType, domain: netDomain)
                    self.tcpNetServer.bonjourTCPListener(called: UIDevice.current.name, serviceTCPName: serviceType, serviceDomain: netDomain)
                }, label: {
                    Text("Start server")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                })
                .padding( 12)
                .colorInvert()
                .background(Capsule())
                .padding(.bottom, 8)
                
                Text(tcpNetServer.listenerState)
                    .padding(.bottom)
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(RoundedRectangle(cornerRadius: 16).stroke())
//            .padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
