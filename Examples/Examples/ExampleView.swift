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
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .toolbar {
            ToolbarItem {
                Toggle(isOn: $viewModel.darkMode, label: { Text("🌖") })
                    .toggleStyle(.checkbox)
            }

            ToolbarItem {
                Toggle(isOn: $viewModel.lineWrapping, label: { Text("Line Wrapping") })
                    .toggleStyle(.checkbox)
            }

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
            ToolbarItem {
                Toggle(isOn: $viewModel.readOnly, label: { Text("READONLY") })
                    .toggleStyle(.checkbox)

            }
            ToolbarItem {
                Picker("Lang", selection: $viewModel.language) {
                    ForEach(Language.allCases, id: \.rawValue) {
                        Text($0.rawValue).tag($0)
                    }
                }
            }
        }
        .onAppear {
            viewModel.setContent(jsonString)
        }
        .navigationTitle("Example")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}

private let jsonString = """
    {
      "header": {
        "alg": "EdDSA",
        "kid": "2023-02-22",
        "typ": "JWT"
      },
      "payload": {
        "aud": [
          "plan"
        ],
        "exp": 1682484288,
        "iat": 1682480688,
        "iss": "https://accounts.toggl.space",
        "jti": "3810df07c7cb738fcab6caad9e3f78ba",
        "nbf": 1682480688,
        "sub": "QpTmkjFk6acasstoN50vp0wf0xL2"
      },
      "signature": "EIPCgh2O7IO1HmWfSHtKgSqsFPgPlRiYfiUrwyenEf5AV4rtZc1Na1Vi0T6smCYj7SR0vmz1VO35B6HVsMnKBw"
    }
    """
