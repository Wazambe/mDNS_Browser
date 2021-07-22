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
    
    @State private var serviceType   = "_mytype._tcp"
    @State private var netDomain = "local."
    @State private var isSelected = false
    @ObservedObject var bonBrowser = mCastBrowser()
       
    
    var body: some View {
        VStack {
            Text("Scan the local network, and list all devices of given type")
                .font(.caption)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
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
            .padding()
            
            Button(action: {
                self.bonBrowser.scan(typeOf: serviceType, domain: netDomain)
//                self.doTCP.resetTCPLink()
            }, label: {
                Text("Search devices")
            })
            .padding(.bottom, 32)
            .colorInvert()
            
            List {
              ForEach(bonBrowser.devices, id: \.self) { each in
                      Text(each.device)
                      .onTapGesture {
//                        self.name = each.device
                        self.isSelected.toggle()
                }
                  }
      //            .font(Fonts.avenirNextCondensedBold(size: 16))
              .listRowBackground(isSelected ? Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)): Color.clear)
              }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
