# Lodge Room Price Optimizer

**Mission:** Help a lodge optimize its nightly room pricing by predicting market-competitive rates based on property characteristics, location, and guest experience data from the Boston Airbnb market.

**Problem:** A lodge owner lacks data-driven insight into how factors like room type, neighbourhood, capacity, and review scores affect pricing — leading to under- or over-pricing relative to the market.

**Dataset:** [Boston Airbnb Open Data — Kaggle](https://www.kaggle.com/datasets/airbnb/boston) | 9,048 listings · 95 features · Target: `price` (USD/night)

**Best Model:** Random Forest Regressor — saved at `summative/linear_regression/models/best_model.pkl`

---

## Repo Structure

```
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

> Coming soon — will be deployed to Render

## Flutter App (Task 3)

> Coming soon
