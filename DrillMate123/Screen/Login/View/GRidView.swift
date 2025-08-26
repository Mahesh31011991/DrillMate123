//
//  GRidView.swift
//  DrillMate
//
//  Created by Mahesh Behere on 31/07/25.
//

import SwiftUI

import SwiftUI

struct ParentView: View {
    @State private var counter = 0
    
    var body: some View {
        print("🔄 ParentView body recomputed")
        
        return VStack(spacing: 20) {
            Text("Counter: \(counter)")
                .font(.largeTitle)
            
            Button("Increment") {
                counter += 1
            }
            
            StaticChildView()
            DynamicChildView(value: counter)
        }
        .padding()
    }
}

struct StaticChildView: View {
    @ViewBuilder var body: some View {
        print("✅ StaticChildView body recomputed")
        
        return Text("I'm static")
            .foregroundColor(.gray)
    }
}

struct DynamicChildView: View {
    let value: Int
    
    var body: some View {
        print("🔁 DynamicChildView body recomputed with value: \(value)")
        
        return Text("Value is \(value)")
            .foregroundColor(.blue)
    }
}


struct GridItemDemo: View {
    let rows = [
        GridItem(.fixed(30), spacing: 10),
        GridItem(.fixed(30), spacing: 10),
        GridItem(.fixed(30), spacing: 10),
        GridItem(.fixed(30), spacing: 10)
    ]
    
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 15) {
                ForEach(0...300, id: \.self) { _ in
                    Color.red.frame(width: 30)
                    Color.green.frame(width: 30)
                    Color.blue.frame(width: 30)
                    Color.yellow.frame(width: 30)
                }
            }
        }
    }
}

struct DemoView:View{
    
    var body:some View{
        
        Card {
            Text("Card")
            Text("Details")
        }
        greetingView(showName: false)
        Image(systemName: "plus")
    }
}

@ViewBuilder
func greetingView(showName: Bool) -> some View {
    Text("Hello")
        .borderCaption()
    if showName {
        Text("Alice")
    }
}

struct Card<Content: View>: View{
    var content:Content
    
    init(@ViewBuilder content:() -> Content){
        self.content = content()
    }
    
    var body:some View{
        VStack{
            content
        }
        .font(.caption)
        .padding()
        .background(Color.gray.opacity(0.5))
        .cornerRadius(8)
    }
}


struct BorderedCaption:ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 1)
            )
            .foregroundStyle(Color.blue)
    }
}

extension View{
    @ViewBuilder
    func borderCaption() -> some View{
        modifier(BorderedCaption())
    }
}



struct ChildView123: View {
    @Binding var name: String
   
//    static func == (lhs: ChildView123, rhs: ChildView123) -> Bool{
//        lhs.name == rhs.name
//    }
    
    var body: some View {
        print("ChildView recomputed times") // Logs when rebuilt
        return VStack{
            Text(name)
           
        }
        
    }
}

struct ParentView123: View {
    @State private var counter = 0
    @State var childName : String = "Alice"
    var body: some View {
        VStack {
            ChildView123(name: $childName)
            Button("Increment") {
                counter += 1
               
            }
        }
    }
}
#Preview {
    ParentView123()
}

