# 🌍 Continental Quiz App

**A Neon-Themed, Time-Based Quiz Experience Built with SwiftUI**

What started as a simple side project evolved into a sleek, feature-rich quiz app designed with bold visuals and smart logic. The **Continental Quiz App** offers a fun, time-pressured experience that tests users' geography knowledge.

---

## 🚀 Features

- ⏰ **Scheduled Quiz Mode**  
  Set a custom quiz start time — perfect for group or event-based challenges.

- 🕒 **Timed Questions**  
  Each question appears for 30 seconds, followed by a 10-second interval for transition.

- ❗ **Auto Evaluation**  
  If the timer runs out, unanswered questions are automatically marked **WRONG** with clear feedback.

- 🔄 **Smart Resume Logic**  
  If the app is closed or sent to the background, it resumes from the correct question and remaining time. Currently implemented using `UserDefaults`, with a transition to `Core Data` underway.

- 🧾 **Score Summary**  
  At the end of each quiz, the app displays a simple results screen:  
  **"Quiz Over" → "SCORE: XX/15"**

- 🎨 **Neon-Themed UI**  
  A futuristic and immersive interface using bright accents and high contrast.

- 📊 **Crash Analytics with Firebase**  
  Integrated Firebase Crashlytics to capture and fix real-world issues.

---

## 🧰 Tech Stack

- **SwiftUI** – Declarative UI framework by Apple  
- **MVVM Architecture** – Clear separation of logic and UI  
- **UserDefaults** – For persistent state (migrating to Core Data)  
- **Firebase Crashlytics** – For crash reporting and analytics  
- **Timer & State-Driven Views** – Core to the app's flow and responsiveness  

---

## 🛠 Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/continental-quiz.git
