//
//  ContentView.swift
//  Examples
//
//  Created by khoi on 4/26/23.
//

import SwiftUI
import CodeMirror

struct ContentView: View {    
    var body: some View {
        CodeMirrorView(
            onLoadSuccess: {
                print("@@@ \(#function)")
            },
            onLoadFailed: { error in
                print("@@@ \(#function) \(error)")
            },
            onContentChange: {
                print("@@@ Content Did Change")
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
