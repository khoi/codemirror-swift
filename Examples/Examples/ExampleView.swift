import CodeMirror
import SwiftUI

struct ExampleView: View {

    @ObservedObject private var viewModel = CodeMirrorViewModel(
        onLoadSuccess: {
            print("@@@ \(#function)")
        },
        onLoadFailed: { error in
            print("@@@ \(#function) \(error)")
        },
        onContentChange: {
            //            print("@@@ Content Did Change")
        }
    )

    var body: some View {
        CodeMirrorView(
            viewModel
        )
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.setContent("YOLO")
                } label: {
                    Text("SET")
                }

            }
            ToolbarItem {

                Button {
                    Task {
                        let content = try? await viewModel.getContent()
                        print(content ?? "")
                    }
                } label: {
                    Text("GET")
                }
            }
        }
        .navigationTitle("Example")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
