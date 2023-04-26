//
//  ContentView.swift
//  Examples
//
//  Created by khoi on 4/26/23.
//

import SwiftUI
import CodeMirror

struct ContentView: View {
    @State private var content: String = "Hello World!"
    
    var body: some View {
        CodeMirrorView(
            content: $content,
            onLoadSuccess: {
                print("@@@ \(#function)")
            },
            onLoadFailed: { error in
                print("@@@ \(#function) \(error)")
            },
            onContentChange: { content in
//                print("@@@ \(#function) \(content)")
            }
        )
          .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
