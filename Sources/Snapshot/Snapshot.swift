import SwiftUI

struct Snapshot: View {
    
    var takenView: some View {
        Text("Snapshot")
            .font(.largeTitle)
            .frame(width: 200, height: 200)
            .padding(6)
            .background(
                Rectangle()
                    .foregroundColor(.red)
                    .cornerRadius(6)
            )
    }
    
    @State private var snapImage: UIImage = UIImage.make(withColor: .gray)
    @State private var hideSnapImage: Bool = true
    @State private var isTakingShot: Bool = false
    @State private var animate = false

    var body: some View {
        VStack(spacing: 10) {
            takenView
            Spacer()
            snapshotFloatImage()
            screenshotBtn()
        }
    }
    
    @ViewBuilder
    func snapshotFloatImage() -> some View {
        HStack {
            Image(uiImage: snapImage)
                .resizable()
                .scaledToFill()
                .frame(width: animate ? 120 : 360, height: animate ? 60 : 180)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(.black, lineWidth: 3)
                )
                .animation(.easeOut, value: animate)
                .padding(4)
            Spacer()
        }
        .opacity(hideSnapImage ? 0 : 1)
    }
    
    @ViewBuilder
    func screenshotBtn() -> some View {
        Button {
            takingScreenshot()
        } label: {
            Image(systemName: "photo.circle.fill")
                .font(.largeTitle)
        }
    }

    private func takingScreenshot() {
        isTakingShot = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            snapImage = takenView.snapshot()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                withAnimation {
                    isTakingShot = false
                    hideSnapImage = false
                    self.animate.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation {
                        hideSnapImage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.animate = false
                    })
                })
            })
        })
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Snapshot()
    }
}


