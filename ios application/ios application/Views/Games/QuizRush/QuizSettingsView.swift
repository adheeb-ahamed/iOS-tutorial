import SwiftUI

struct QuizSettingsView: View {

    @State private var settings = QuizSettings()
    @State private var startQuiz = false

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.8),
                        Color.cyan.opacity(0.35),
                        Color.black.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()


                ScrollView {

                    VStack(spacing: 22) {

                        header


                        settingCard(
                            title: "Questions",
                            icon: "questionmark.circle.fill"
                        ) {

                            optionPicker {
                                
                                Picker(
                                    "",
                                    selection: $settings.amount
                                ) {

                                    Text("5").tag(5)
                                    Text("10").tag(10)
                                    Text("15").tag(15)
                                    Text("20").tag(20)
                                }
                                .pickerStyle(.segmented)
                            }
                        }



                        settingCard(
                            title: "Difficulty",
                            icon: "chart.bar.fill"
                        ) {

                            Picker(
                                "",
                                selection: $settings.difficulty
                            ) {

                                ForEach(Difficulty.allCases) { difficulty in

                                    Text(difficulty.title)
                                        .tag(difficulty)
                                }
                            }
                            .pickerStyle(.segmented)
                        }



                        settingCard(
                            title: "Category",
                            icon: "books.vertical.fill"
                        ) {

                            Picker(
                                "",
                                selection: $settings.category
                            ) {

                                ForEach(QuizCategory.allCases) { category in

                                    Text(category.title)
                                        .tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                        }



                        settingCard(
                            title: "Time Limit",
                            icon: "timer"
                        ) {

                            Picker(
                                "",
                                selection: $settings.timeLimit
                            ) {

                                Text("30s").tag(30)
                                Text("60s").tag(60)
                                Text("90s").tag(90)
                                Text("120s").tag(120)
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: .infinity)
                        }
                        



                        Button {

                            startQuiz = true

                        } label: {

                            HStack {

                                Image(systemName: "bolt.fill")

                                Text("Start Quiz")
                                    .fontWeight(.bold)

                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                .blue,
                                                .cyan
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundColor(.white)
                            .shadow(
                                color: .cyan.opacity(0.5),
                                radius: 10
                            )
                        }
                        .padding(.top)



                    }
                    .padding()
                }
            }

            .navigationTitle("Quiz Setup")
            .navigationBarTitleDisplayMode(.inline)


            .navigationDestination(isPresented: $startQuiz) {

                QuizView(
                    settings: settings,
                    showGame: .constant(true)
                )
            }
        }
    }
}

extension QuizSettingsView {


    private var header: some View {

        VStack(spacing: 10) {

            Image(systemName: "brain.head.profile")
                .font(.system(size: 65))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan,.blue],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )


            Text("Quiz Rush")
                .font(
                    .system(
                        size: 34,
                        design: .rounded
                    )
                )
                .fontWeight(.black)


            Text("Configure your challenge")
                .foregroundColor(.secondary)
        }
        .padding(.top,20)
    }



    private func settingCard<Content: View>(
        title:String,
        icon:String,
        @ViewBuilder content: () -> Content
    ) -> some View {


        VStack(
            alignment:.leading,
            spacing:15
        ){

            HStack {

                Image(systemName: icon)
                    .frame(
                        width:35,
                        height:35
                    )
                    .background(
                        Circle()
                            .fill(
                                Color.blue.opacity(0.15)
                            )
                    )

                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)

            }


            content()
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(
                cornerRadius:22
            )
            .fill(.ultraThinMaterial)
        )
    }



    private func optionPicker<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {

        content()
    }
}
#Preview {
    QuizSettingsView()
}
