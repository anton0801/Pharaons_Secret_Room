import SwiftUI

struct RecordItem: Identifiable, Equatable {
    let id: String
    let level: String
    let record: Int
}

struct RecordsOfGamesView: View {
    
    @Environment(\.presentationMode) var preMo
    
    @State var recordsList: [RecordItem] = []
    
    func secsToMS(s seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("RECORDS")
                .font(.custom("RammettoOne-Regular", size: 42))
                .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
            Spacer()
            ScrollView {
                VStack {
                    ForEach(recordsList, id: \.id) { record in
                        Text("\(record.level.replacingOccurrences(of: "_", with: " ")) - \(secsToMS(s: record.record))")
                            .font(.custom("RammettoOne-Regular", size: 28))
                            .foregroundColor(Color.init(red: 245/255, green: 203/255, blue: 82/255))
                            .shadow(color: Color.init(red: 111/255, green: 46/255, blue: 7/255), radius: 2)
                            .padding()
                    }
                }
            }
            .frame(height: 450)
            Spacer()
            Button {
                preMo.wrappedValue.dismiss()
            } label: {
                Image("back_btn")
                    .resizable()
                    .frame(width: 200, height: 70)
            }
            Spacer().frame(height: 24)
        }
        .onAppear {
            self.setUpRecordsList()
        }
        .background(
            Image("main_content_bg_2")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 30)
        )
    }
    
    private func setUpRecordsList() {
        for level in levels {
            recordsList.append(RecordItem(id: "\(level)_record_id", level: level, record: UserDefaults.standard.integer(forKey: "\(level)_record")))
        }
    }
    
}

#Preview {
    RecordsOfGamesView()
}
