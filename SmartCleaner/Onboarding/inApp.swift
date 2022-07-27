//
//  inApp.swift
//  SmartCleaner
//
//  Created by Emre Karaoğlu on 1.06.2022.
//

import SwiftUI

struct inApp: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isWeeklySelected = false
    @State var isMonthlySelected = false
    @State var isAnnunalSelected = true
    
    @State var isMain = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
//                    self.presentationMode.wrappedValue.dismiss()
                    isMain.toggle()
                } label: {
                    Image("btn_cross")
                        .padding(10)
                }
                Spacer()
            }
            VStack{
                Image("img_inapp")
                    .padding(.top, -50)
                Spacer()
                Text("Open\nunlimited acess!")
                    .font(.custom("Poppins-Regular", size: 24))
                    .frame(width: 0.9 * screenWidth, height: 0.18 * screenWidth, alignment: .top)
                    .multilineTextAlignment(.center)
            }
            VStack {
                HStack {
                    Image("img_dot")
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.").font(.custom("Poppins-Regular", size: 16)).foregroundColor(Color(descriptionColor))
                }
                HStack {
                    Image("img_dot")
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(descriptionColor))
                }
                HStack {
                    Image("img_dot")
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.").font(.custom("Poppins-Regular", size: 16)).foregroundColor(Color(descriptionColor))
                }
            }
            VStack {
                Button {
                    print("weakly")
                    isWeeklySelected = true
                    isMonthlySelected = false
                    isAnnunalSelected = false
                    
                } label: {
                    VStack {
                        Text("€2.99")
                        Text("1 week Subscription")
                    }.foregroundColor(Color(descriptionColor))
                        .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                        .contentShape(Rectangle())
                        .background(Color.white)
                }.border(isWeeklySelected ? Color(purpleColor) : Color.white)
                Button {
                    print("Monthly")
                    isMonthlySelected = true
                    isWeeklySelected = false
                    isAnnunalSelected = false
                } label: {
                    VStack {
                        Text("€9.99")
                        Text("1 Month Subscription")
                    }.foregroundColor(Color(descriptionColor))
                        .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                        .contentShape(Rectangle())
                        .background(Color.white)
                }.border(isMonthlySelected ? Color(purpleColor) : Color.white)
                Button {
                    print("Annunal")
                    isAnnunalSelected = true
                    isWeeklySelected = false
                    isMonthlySelected = false
                } label: {
                    VStack{
                        Text("€89.99")
                        Text("1 Year Subscription")
                    }.foregroundColor(Color(descriptionColor))
                        .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                        .contentShape(Rectangle())
                        .background(Color.white)
                }.border(isAnnunalSelected ? Color(purpleColor) : Color.white)
            }
            Button {
                print("set free trial")
            } label: {
                Text("Start Free Trial")
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Medium", size: 16))
                    .frame(width: 0.9 * screenWidth, height: 0.15 * screenWidth, alignment: .center)
                    .contentShape(Rectangle())
            }.background(Color(purpleColor))
                .padding(.vertical)
            HStack{
                Button {
                    print("Terms & Conditions")
                } label: {
                    Text("Terms & Conditions")
                        .foregroundColor(Color(descriptionColor))
                        .underline()
                }.padding(.leading, 0.1 * screenWidth)
                Spacer()
                Button {
                    print("Restore")
                } label: {
                    Text("Restore Purchases")
                        .foregroundColor(Color(descriptionColor))
                        .underline()
                }.padding(.trailing, 0.1 * screenWidth)
            }
            
        }.background(LinearGradient(colors: [Color.white, Color(bgColor)], startPoint: .top, endPoint: .bottom))
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isMain, content: MainView.init)
    }
}

struct inApp_Previews: PreviewProvider {
    static var previews: some View {
        inApp()
    }
}
