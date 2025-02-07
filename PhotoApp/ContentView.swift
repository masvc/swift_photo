import SwiftUI
import PhotosUI

struct ContentView: View {
  @State var selectedPhotoItem: PhotosPickerItem? = nil
  @State var image: Image? = nil

  var body: some View {
    VStack {
      imageView

      HStack {
        Button("削除") {
          image = nil
        }
        .modifier(ButtonModifier(backgroundColor: .red))

        PhotosPicker(selection: $selectedPhotoItem, matching: .images) { // 画像を選びたいので.images
          Text("写真を選択する") // ButtonをTextに変更
            .modifier(ButtonModifier(backgroundColor: .green))
        }
      }
    }
    .padding()
    .onChange(of: selectedPhotoItem){
      Task{
        do{
          image = try await selectedPhotoItem?.loadTransferable(type: Image.self)
        }
        catch{
          print(error.localizedDescription)
        }

      }

    }
  }
}

extension ContentView {
  var imageView: some View {
    if let image {
      image
        .resizable()
        .frame(width: 300, height: 300)
    } else {
      Image("noimage")
        .resizable()
        .frame(width: 300, height: 300)
    }
  }
}

struct ButtonModifier: ViewModifier {
  let backgroundColor: Color
  func body(content: Content) -> some View {
    content
      .padding()
      .frame(minHeight: 50)
      .background(backgroundColor)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

#Preview {
  ContentView()
}

