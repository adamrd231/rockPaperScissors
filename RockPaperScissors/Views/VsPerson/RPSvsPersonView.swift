import SwiftUI

struct RPSvsPersonView: View {
    @ObservedObject var vsPersonViewModel: VsPersonViewModel
    
    var body: some View {
        VStack {
    
            Text("Currently playing")

            
        }
    }
}

struct RPSvsPersonView_Previews: PreviewProvider {
    static var previews: some View {
        RPSvsPersonView(vsPersonViewModel: VsPersonViewModel())
    }
}
