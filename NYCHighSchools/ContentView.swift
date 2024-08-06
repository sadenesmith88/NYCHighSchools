//
//  ContentView.swift
//  NYCHighSchools
//
//  Created by sade on 8/6/24.
//

import SwiftUI

let url = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"


//Model
struct Model: Decodable, Hashable {

  let school_name: String

//
//  enum CodingKey: String {
//    case schoolName = "school_name"
//
//  }
}

//ViewModel
class ViewModel: ObservableObject {
  @Published var items = [Model]()

  func loadData() {
    guard let urlTask = URL(string: url) else { return }

    URLSession.shared.dataTask(with: urlTask) { (data, res, err) in

      do {

        if let data = data {

          let result = try JSONDecoder().decode([Model].self, from: data)

          DispatchQueue.main.async {
            self.items = result
          }

        } else {
          print("No data")
        }
      } catch (let error) {
        print(error)
      }
    }.resume()
  }
}


struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  var body: some View {
    NavigationView {
      VStack {
        List(viewModel.items, id: \.self) { item in
          Text(item.school_name)
        }
      }
      .navigationBarTitle("NYC School Names")
      }

    .onAppear( perform: {
        viewModel.loadData()
      })


    }


  }


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
