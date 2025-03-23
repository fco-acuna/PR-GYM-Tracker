import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    var name: String
    var pr: Int
    var date: String
    var image: String
}

struct ContentView: View {
    @State private var exercises: [Exercise] = [
        Exercise(name: "Bench Press", pr: 195, date: "10 March, 2024", image: "gym_image"),
        Exercise(name: "Shoulder Press", pr: 80, date: "15 March, 2024", image: "gym_image"),
        Exercise(name: "Back Squat", pr: 225, date: "20 March, 2024", image: "gym_image")
    ]
    
    @State private var selectedExercise: Exercise?
    @State private var showEditSheet = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {

                // 💪 Branding y título
                VStack(spacing: 8) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)

                    Text("PR Gym Tracker")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Developed by Francisco Acuña")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top)

                // 📋 Lista de ejercicios
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(exercises.indices, id: \.self) { index in
                            ExerciseCard(
                                exercise: exercises[index],
                                onEdit: {
                                    selectedExercise = exercises[index]
                                    showEditSheet = true
                                }
                            )
                        }
                    }
                    .padding()
                }
            }

            // ➕ Botón flotante
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newExercise = Exercise(name: "New PR", pr: 0, date: "Today", image: "gym_image")
                        exercises.append(newExercise)
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $selectedExercise) { exercise in
            EditPRView(exercise: exercise) { updatedExercise in
                if let index = exercises.firstIndex(where: { $0.id == updatedExercise.id }) {
                    exercises[index] = updatedExercise
                }
            }
        }
    }
}

// 💾 Componente de cada ejercicio en la lista
struct ExerciseCard: View {
    let exercise: Exercise
    var onEdit: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Max \(exercise.pr)kg")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(exercise.name)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                
                Text(exercise.date)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // 🏋️‍♂️ Mostrar porcentajes
                VStack {
                    Text("90% = \(Int(Double(exercise.pr) * 0.9))kg")
                    Text("80% = \(Int(Double(exercise.pr) * 0.8))kg")
                    Text("70% = \(Int(Double(exercise.pr) * 0.7))kg")
                    Text("60% = \(Int(Double(exercise.pr) * 0.6))kg")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()

            Image("gym_image") // 🔍 Imagen de gym
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color(UIColor.darkGray))
        .cornerRadius(15)
    }
}

// ✏️ Pantalla de edición de PRs
struct EditPRView: View {
    @State var exercise: Exercise
    var onSave: (Exercise) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Editar PR")
                .font(.title)
                .foregroundColor(.white)

            TextField("Nombre del ejercicio", text: $exercise.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // TextField para ingresar PR manualmente
            TextField("Nuevo PR", value: $exercise.pr, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            // Stepper
            Stepper(value: $exercise.pr, in: 0...500, step: 5) {
                            Text("Nuevo PR: \(exercise.pr) kg")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red.opacity(0.5)) // Fondo rojo translúcido
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2) // Borde rojo
                        )

            // Botón para guardar cambios
            Button(action: {
                onSave(exercise)
                dismiss()
            }) {
                Text("Guardar")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Botón para cancelar
            Button(action: {
                dismiss()
            }) {
                Text("Cancelar")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView()
}

