//
//  Detailview.swift
//  Parking
//
//  Created by Patel Chintan on 2023-03-29.
//

import SwiftUI

struct Detailview: View {
    var selectedplace:ParkingSlot
    @State private var slots = ""
    //let selectedindex:Int
    @State private var showErrorAlert : Bool = false
    @State private var alertMessage : String = ""
    @State private var alertTitle : String = ""
    
    @State private var result : String = ""
    let pattern = "^[a-zA-Z][0-9]{13}$"
    let pattern2 = "^[A-Za-z]{4}\\d{3}$"
    @State private var errorMessage = ""
    @State private var signout : Int? = nil
    let times = ["30 Minutes","1 Hour","3 Hours","12 Hours", "Whole-Day"]
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    @State private var name : String = ""
    @State private var hours : String = "30 Minutes"
    @State private var license : String = ""
    @State private var plate : String = ""
    @State private var address : String = ""
    @State private var selection : Int? = nil
    @State private var date : Date = Date()
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    
    var body: some View {
        Text("Park-IN: TORONTO ")
            .foregroundColor(.blue)
            .font(.title)
            .fontWeight(.bold)
            .padding(5)
        Text("Address: \(selectedplace.address)")
            .fontWeight(.semibold)
            .multilineTextAlignment(.leading)
        Text("Rate: \(selectedplace.rate)")
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        
        VStack(){
            
            Form{
                
                TextField("Enter Legal Name", text: self.$name)
                    .disableAutocorrection(true)
                    .autocapitalization(.words)
                
                TextField("Enter Driving License Number", text: self.$license)
                    .disableAutocorrection(true)
                
                TextField("Enter Car Plate No.", text: self.$plate)
                    .disableAutocorrection(true)
                
                
                Section(header: Text("Date & Time")) {
                    DatePicker("", selection: $date)
                    Picker("Booking Length", selection: $hours) {
                        ForEach(times, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
            }//Form inside VStack ends
            
            Button(action: {
                self.addNewParking()
                
            })
            {
                
                HStack {
                    Image(systemName: "plus")
                        .font(.subheadline)
                    Text("Add Details")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(20)
            }
            .frame(maxWidth: .infinity)
            .alert(isPresented: self.$showErrorAlert){
                Alert(
                    title: Text(self.alertTitle),
                    message: Text(self.alertMessage)
                )
       
            }

           
        }//VStack ends
    }

    
    private func addNewParking(){
        
        if (self.name.isEmpty || self.plate.isEmpty || self.license.isEmpty){
            //show error
            self.alertMessage = "Fields cannot be empty"
            self.alertTitle = "Error"
            self.showErrorAlert = true
        }
        else if (self.name.count == 1 ){
            self.alertMessage = "Name Must be more than one character"
            self.alertTitle = "Error"
            self.showErrorAlert = true
        }
        else if ((self.license.range(of: pattern, options:.regularExpression))==nil){
            self.alertMessage = "License plate number must be of correct format!"
            self.alertTitle = "Error"
            self.showErrorAlert = true
        }
        else if ((self.plate.range(of: pattern2, options:.regularExpression))==nil){
            self.alertMessage = "Plate no. must be correct format"
            self.alertTitle = "Error"
            self.showErrorAlert = true
        }
        
        else{
            
            let newParking = Parking(name: self.name, hours : self.hours, license : self.license, plate: self.plate, date: self.date, address: self.selectedplace.address)
            self.fireDBHelper.insertParking(newParking: newParking)
            self.alertTitle = "Success"
            self.alertMessage = "Parking Added!"
            self.showErrorAlert = true
            dismiss()
        }
        
    }
    
    
}
