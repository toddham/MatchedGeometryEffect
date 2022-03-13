//
//  ContentView.swift
//  MatchedGeometryEffect
//
//  Created by Todd Hamilton on 3/13/22.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace var ns
    @State var expand: Bool = false
    @State var opacity: CGFloat = 0.0
    @State var shimOpacity: CGFloat = 0.0
    @State var dragOffset = CGSize.zero
    
    var body: some View {
        ZStack{
            Image("wallpaper")
                .resizable()
                .ignoresSafeArea()
                .overlay(
                    Color.black
                        .opacity(expand ? getShimOpacity() : 0.0)
                )
            
            VStack {
                if expand {
                    VStack(spacing:16) {
                        ZStack(alignment:.top){
                            Image(systemName:"xmark")
                                .padding(8)
                                .foregroundColor(.primary)
                                .background(Color.black.opacity(0.15))
                                .clipShape(Capsule())
                                .frame(maxWidth:.infinity, alignment:.topTrailing)
                                .offset(x:16, y:-16)
                                .opacity(opacity)
                                .onAppear(perform: {
                                    withAnimation(.easeInOut.delay(0.3)){
                                        opacity = 1.0
                                    }
                                })
                                .onTapGesture {
                                    opacity = 0
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.775, blendDuration: 0.15)) {
                                        expand.toggle()
                                    }
                                }
                            Image("profile0")
                                .resizable()
                                .clipShape(Capsule())
                                .overlay(Ellipse().stroke(Color.white, lineWidth: 2))
                                .matchedGeometryEffect(id: "Profile", in: ns, properties: .frame)
                                .frame(width:80, height:80)
                                
                                
                        }
                        VStack {
                            Text("Todd Hamilton")
                                .font(Font.body.weight(.bold))
                                .foregroundColor(.primary)
                                .matchedGeometryEffect(id: "Title1", in: ns)
                            Text("1K Followers")
                                .font(Font.subheadline)
                                .foregroundColor(.secondary)
                                .matchedGeometryEffect(id: "Title2", in: ns)
                        }
                        HStack{
                            
                            Button(action:{
                                print("Twitter")
                            }){
                                Text("Follow")
                                    .fontWeight(.semibold)
                            }.buttonStyle(ProfileButton())
                            
                            Button(action:{
                                print("Message")
                            }){
                                Text("Message")
                                    .fontWeight(.semibold)
                            }.buttonStyle(ProfileButton())

                        }
                        .opacity(opacity)
                        .onAppear(perform: {
                            withAnimation(.easeInOut.delay(0.1)){
                                opacity = 1.0
                            }
                        })
                        Text("Product Designer [@Meta](http://google.com). Building Swift Package Exporter [https://figmatoswift.com](https://figmatoswift.com)")
                            .foregroundColor(.secondary)
                            .opacity(opacity)
                        
                    }
                    .padding(32)
                    .frame(maxWidth:.infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.clear)
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius:16).stroke(Color.black.opacity(0.1)))
                            .shadow(color:.black.opacity(0.5), radius: 8, x: 0, y: 3)
                            .matchedGeometryEffect(id: "BG", in: ns)
                    )
                    
                    Spacer()

                } else {
                    HStack(spacing:12) {
                        Image("profile0")
                            .resizable()
                            .clipShape(Capsule())
                            .overlay(Ellipse().stroke(Color.white, lineWidth: 2))
                            .matchedGeometryEffect(id: "Profile", in: ns, properties: .frame)
                            .frame(width:32, height:32)
                            
                        VStack (alignment:.leading){
                            Text("Todd Hamilton")
                                .font(Font.body.weight(.bold))
                                .foregroundColor(.primary)
                                .matchedGeometryEffect(id: "Title1", in: ns)
                            Text("1K Followers")
                                .font(Font.subheadline)
                                .foregroundColor(.secondary)
                                .matchedGeometryEffect(id: "Title2", in: ns)
                        }
                        
                    }
                    .padding()
                    .frame(alignment:.top)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.clear)
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius:16).stroke(Color.black.opacity(0.1)))
                            .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 3)
                            .matchedGeometryEffect(id: "BG", in: ns)
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.775, blendDuration: 0.15)) {
                            expand.toggle()
                            shimOpacity = 0.4
                        }
                    }
                }
            }
            .padding()
            .offset(dragOffset)
            .scaleEffect(getScaleAmount())
            .gesture(DragGesture()
                .onChanged{value in
                    if expand {
                        dragOffset = value.translation
                    }
                }
                .onEnded{value in
                    opacity = 0
                    shimOpacity = 0
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75, blendDuration: 0.1)){
                        if dragOffset.height > 100.0 {
                            dragOffset = .zero
                            expand = false
                            shimOpacity = 0
                        } else {
                            opacity = 1.0
                            dragOffset = .zero
                            shimOpacity = 0.4
                        }
                    }
                }
            )
        }
    }
    func getShimOpacity() -> CGFloat {
        let max = UIScreen.main.bounds.height
        let currentAmount = dragOffset.height
        let percentage = max / currentAmount
        return min(abs(percentage * 0.01), 0.4)
    }
    
    func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 2
        let currentAmount = dragOffset.height
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.4) * 0.5
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
            
    }
}

struct ProfileButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical,8)
            .padding(.horizontal,12)
            .background(.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

