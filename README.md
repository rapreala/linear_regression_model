# Lodge Room Price Optimizer

**Mission:** Help a lodge in Kigali optimize its nightly room pricing by predicting market-competitive rates based on property characteristics, location, and guest experience data from the Boston Airbnb market.

**Problem:** A lodge owner lacks data-driven insight into how factors like room type, neighbourhood, capacity, and review scores affect pricing — leading to under- or over-pricing relative to the market.

**Dataset:** [Boston Airbnb Open Data — Kaggle](https://www.kaggle.com/datasets/airbnb/boston) | 9,048 listings · 95 features · Target: `price` (USD/night)

**Best Model:** Random Forest Regressor — saved at `summative/linear_regression/models/best_model.pkl`

---

## Repo Structure

```text
linear_regression_model/
│
├── summative/
│   ├── linear_regression/
│   │   ├── multivariate.ipynb      ← Full analysis notebook (Task 1)
│   │   ├── data/
│   │   │   ├── listings.csv
│   │   │   ├── calendar.csv
│   │   │   └── reviews.csv
│   │   └── models/
│   │       ├── best_model.pkl
│   │       ├── scaler.pkl
│   │       └── feature_columns.pkl
│   ├── API/
│   │   ├── prediction.py           ← FastAPI app (Task 2)
│   │   └── requirements.txt
│   └── FlutterApp/                 ← Flutter mobile app (Task 3)
└── README.md
```

---

## Task 1 — Run the Notebook

```bash
cd summative/linear_regression
pip install pandas numpy matplotlib seaborn scikit-learn joblib
jupyter notebook multivariate.ipynb
```

## API Endpoint (Task 2)

**Live API:** [https://kigali-room-price-predictor.onrender.com](https://kigali-room-price-predictor.onrender.com)

**Swagger UI:** [https://kigali-room-price-predictor.onrender.com/docs](https://kigali-room-price-predictor.onrender.com/docs)

| Endpoint | Method | Description |
| --- | --- | --- |
| `/predict` | POST | Predict nightly rate from GPS + room profile |
| `/retrain` | POST | Upload new CSV data to retrain the model |
| `/districts` | GET | List all 16 Kigali districts with tiers |
| `/health` | GET | Service health check |

### Run locally

```bash
cd summative/API
pip install -r requirements.txt
uvicorn prediction:app --reload --port 8001
# Swagger UI → http://localhost:8001/docs
```

## Flutter App (Task 3)

**App:** Kigali Lodge Manager — a business PMS dashboard focused on room management with live AI price prediction.

> **Video demo:** [Google Drive — watch here](https://drive.google.com/drive/folders/1kjQ4Kk2VQpUBu1MV6BMi7e9n2xXvZU3l?usp=sharing)

### Architecture

The app follows **Clean Architecture** with **BLoC state management**, mirroring the Brewmaster project structure:

```text
FlutterApp/
└── lib/
    ├── config/theme/          # AppTheme (teal + lodge-gold palette)
    ├── core/constants/        # API base URL, Kigali district data
    ├── data/
    │   ├── models/            # PredictionRequestModel, PredictionResponseModel
    │   ├── services/          # PredictionService (http POST /predict)
    │   └── repositories/      # PredictionRepositoryImpl
    ├── domain/
    │   ├── entities/          # PredictionResult
    │   └── repositories/      # PredictionRepository (abstract)
    └── presentation/
        ├── blocs/prediction/  # PredictionBloc, Event, State
        └── screens/
            ├── dashboard/     # DashboardScreen — PMS module only
            └── rooms/         # ManageRoomsScreen, AddRoomScreen
```

### Why only the PMS rooms module?

The entire summative is about **lodge room price prediction** — keeping only the Room Management module keeps the app focused, on-brand, and directly demonstrates the ML pipeline end-to-end (room profile → API → predicted nightly rate).

### Key screens

| Screen | Purpose |
| --- | --- |
| **Dashboard** | Business entry point — single PMS card ("Manage Your Rooms") |
| **Manage Rooms** | Lists rooms with AI-predicted prices per night |
| **Add Room** | 20-field form matching all model features + "Predict Optimal Room Price" button |

### Input fields (matches `/predict` API exactly)

All 20 model features are exposed as validated `TextField` or `DropdownButtonFormField` inputs:

| Field | Type | Range |
| --- | --- | --- |
| District (→ lat/lon) | Dropdown | 16 Kigali districts |
| Room type | Dropdown | 0–3 |
| Accommodates | Int | 1–16 |
| Bedrooms | Int | 0–10 |
| Bathrooms | Float | 0–8 |
| Beds | Int | 1–20 |
| Guests included | Int | 1–16 |
| Min nights | Int | 1–365 |
| Availability (days/yr) | Int | 0–365 |
| Instant bookable | Toggle | 0/1 |
| Review score | Float | 20–100 |
| No. of reviews | Int | 0–1000 |
| Reviews/month | Float | 0–30 |
| Superhost | Toggle | 0/1 |
| Host listings count | Int | 1–300 |
| Host response time | Dropdown | 0–4 |
| Property type | Dropdown | 0–9 |
| Bed type | Dropdown | 0–4 |
| Cancellation policy | Dropdown | 0–4 |

### Run the app

```bash
cd summative/FlutterApp
flutter pub get
flutter run
```

The app calls `https://kigali-room-price-predictor.onrender.com/predict` (no local setup needed).
