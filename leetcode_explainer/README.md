# LeetCode Explainer

An AI-powered code explainer app built with **Flutter** (frontend) and **FastAPI** (backend), using **Gemini** (Google) to analyze code and provide detailed explanations.

## Features

- **Code Explanation** — plain English walkthrough of any code snippet
- **ELI5 Mode** — "Explain Like I'm 5" with real-world analogies
- **Complexity Analysis** — time and space complexity with reasoning
- **Dry Run** — step-by-step execution trace with variable states
- **Key Insight** — core algorithmic idea in one sentence

## Project Structure

```
leetcode_explainer/
├── backend/
│   ├── main.py            # FastAPI server with /explain endpoint
│   ├── ai_service.py      # Gemini API integration
│   └── requirements.txt   # Python dependencies
└── frontend/
    └── flutter_app/       # Flutter cross-platform app
        ├── lib/
        │   ├── main.dart
        │   ├── models/
        │   ├── services/
        │   ├── providers/
        │   ├── screens/
        │   └── widgets/
        └── pubspec.yaml
```

## Setup Instructions

### 1. Backend Setup

```bash
cd backend
pip install -r requirements.txt
```

### 2. Set Gemini API Key

### Prerequisites
  Create a `.env` file in `leetcode_explainer/backend/` and add your Groq API key:
**Linux / macOS:**
```bash
export GEMINI_API_KEY=your_key
```

**Windows (PowerShell):**
```powershell
$env:GEMINI_API_KEY = "your_key"
```

### 3. Run the Backend Server

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`. API docs at `http://localhost:8000/docs`.

### 4. Run the Flutter App

```bash
cd frontend/flutter_app
flutter pub get
flutter run
```

> **Note:** The Flutter app is configured to connect to `http://10.0.2.2:8000` for Android emulator (which maps to the host machine's localhost). For iOS simulator, change the base URL to `http://localhost:8000` in `lib/services/ai_service.dart`. For a physical device, use your machine's local IP address.

## Tech Stack

| Layer    | Technology                  |
|----------|-----------------------------|
| Frontend | Flutter (Dart)              |
| Backend  | FastAPI (Python)            |
| AI       | Google Gemini               |
| State    | Riverpod (StateNotifier)    |

## API Endpoint

### POST `/explain`

**Request:**
```json
{
  "code": "def two_sum(nums, target): ...",
  "mode": "normal"
}
```

**Response:**
```json
{
  "explanation": "...",
  "eli5": "...",
  "complexity": { "time": "O(n)", "space": "O(n)" },
  "dry_run": [{ "step": 1, "line": "...", "state": "...", "note": "..." }],
  "key_insight": "..."
}
```
