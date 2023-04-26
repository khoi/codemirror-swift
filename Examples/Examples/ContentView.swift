import CodeMirror
import SwiftUI

struct ContentView: View {

    private var viewModel = CodeMirrorViewModel(
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

    var body: some View {
        CodeMirrorView(
            viewModel
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
