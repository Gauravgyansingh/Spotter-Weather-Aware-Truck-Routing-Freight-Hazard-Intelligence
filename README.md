# SPOTTER — 3D Weather-Aware Truck Routing & Risk Intelligence Platform

**SPOTTER** is a full-stack, production-style geospatial intelligence platform designed for commercial freight dispatchers, fleet analysts, and long-haul transportation operators. It combines 3D road topography, high-resolution hourly meteorological forecasts, vehicle-weight dynamics, and explainable lexicographic decision algorithms to recommend the safest possible highway transit corridors.

---

## 1. Problem Statement

Long-haul trucking accounts for over 70% of overland freight tonnage in North America. Severe weather—especially high crosswinds, freezing rain, blizzard snowfall, and torrential storms—causes tens of thousands of heavy truck rollovers, jackknife collisions, and supply chain delays annually. 

Traditional navigation platforms (such as Google Maps or standard OSRM) calculate routes solely based on travel distance or traffic congestion, completely ignoring weather exposure. Spotter solves this critical safety gap by:
1. Interpolating exact road routes into progressive spatial checkpoints.
2. Sampling localized, hourly weather forecasts at the precise estimated arrival time (ETA) for each segment.
3. Classifying wind, precipitation, and snowfall against gross vehicle weight thresholds.
4. Lexicographically ranking candidate corridors by minimizing Severe-risk and High-risk miles before considering travel duration.

---

## 2. Core Features

- **3D Geospatial Visualization**:
  - Interactive tilted 3D map powered by MapLibre GL JS and OpenStreetMap standard tile layers (zero API key required).
  - Multi-tier route corridors with hazard-colored segments (Emerald Low, Amber Moderate, Orange High, Crimson Severe, Burgundy No Travel).
  - Tilted 3D perspective controls, North orientation reset, and full-screen examination mode.

- **Animated 3D Truck Simulation**:
  - High-precision tractor-trailer model moving along actual road geometry coordinates (never straight-line interpolation).
  - Dynamic road heading orientation matching true compass bearings.
  - Interactive playback controls: Play/Pause, 1x/2x/5x/10x simulation speeds, scrubbable progress bar, and Camera Follow tracking.

- **Dynamic Weather Intelligence**:
  - Direct integration with Open-Meteo hourly weather APIs.
  - Live extraction of temperature (°F), sustained wind speed (mph), wind gusts, rainfall rate (in/hr), snowfall rate (in/hr), and WMO sky conditions.

- **Explainable Multi-Factor Risk Engine**:
  - Independent wind, rain, and snow hazard classification.
  - Vehicle cargo weight escalation rules:
    - Wind $\ge$ 55 mph: Immediate *No Travel* advisory for all freight classes.
    - Wind 45–54 mph + Gross Load &gt; 30,000 lbs: Escalated to *No Travel* (rollover hazard).
    - Wind 35–44 mph + Gross Load &gt; 40,000 lbs: Escalated to *Severe*.

- **Strict Lexicographic Recommendation Engine**:
  - Corridors are ranked using deterministic safety-first criteria:
    1. Fewest combined Severe-risk and No-Travel miles.
    2. Fewest High-risk miles.
    3. Lowest mile-weighted average risk score.
    4. Shortest travel time.
  - Generates clear, human-readable dispatch explanations.

- **Corridor Risk & Weather Heatmap**:
  - Interactive timeline showing checkpoint progression, elevation profile, wind velocity, precipitation type, and temperature changes.

- **Verified Sample Corridor Fallback**:
  - Built-in Chicago to Denver multi-hazard winter corridor fixture (`fixtures/sample_trip.json`).
  - Transparent data attribution: clearly tags live vs. sample data.

---

## 3. Technology Stack

### Frontend
- **Framework**: React 18 with TypeScript
- **Build Tool**: Vite
- **Styling**: Tailwind CSS with custom midnight navy dark theme
- **Geospatial & 3D**: MapLibre GL JS, Three.js, React Three Fiber, Lucide React
- **Data Fetching**: TanStack React Query
- **Testing**: Vitest, React Testing Library, ESLint

### Backend
- **Framework**: Python 3.12, Django 5.1, Django REST Framework
- **HTTP Client**: HTTPX with connection pooling and timeouts
- **CORS**: `django-cors-headers`
- **Caching**: Django LocMemCache for external API query deduplication
- **Testing**: pytest, pytest-django, hypothesis, respx, ruff

### Geospatial & Meteorological Providers
- **OSRM (Open Source Routing Machine)**: Highway route geometry and alternatives.
- **Open-Meteo API**: Hourly meteorological forecasts.
- **OpenStreetMap Nominatim**: Geocoding and location autocomplete.

---

## 4. Exact Folder Structure

```
spotter/
├── README.md
├── .gitignore
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── backend/
│   ├── manage.py
│   ├── requirements.txt
│   ├── requirements-dev.txt
│   ├── pytest.ini
│   ├── build.sh
│   ├── .env.example
│   │
│   ├── config/
│   │   ├── __init__.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   │
│   └── routing/
│       ├── __init__.py
│       ├── apps.py
│       ├── urls.py
│       ├── views.py
│       ├── serializers.py
│       ├── errors.py
│       ├── routing_service.py
│       ├── geocoding.py
│       ├── weather.py
│       ├── ratelimit.py
│       ├── rules.py
│       ├── risk.py
│       ├── geometry.py
│       ├── sampling.py
│       ├── segments.py
│       ├── recommend.py
│       ├── analyze.py
│       ├── fixtures/
│       │   └── sample_trip.json
│       └── tests/
│           ├── __init__.py
│           ├── test_risk.py
│           ├── test_sampling.py
│           ├── test_segments.py
│           ├── test_recommend.py
│           └── test_api.py
│
└── frontend/
    ├── package.json
    ├── package-lock.json
    ├── index.html
    ├── .env.example
    ├── tsconfig.json
    ├── tsconfig.app.json
    ├── tsconfig.node.json
    ├── vite.config.ts
    ├── eslint.config.js
    │
    └── src/
        ├── main.tsx
        ├── App.tsx
        ├── index.css
        ├── vite-env.d.ts
        ├── types.ts
        ├── api.ts
        ├── riskColors.ts
        │
        ├── hooks/
        │   └── useAnalyze.ts
        │
        └── components/
            ├── TripForm.tsx
            ├── RecommendationBanner.tsx
            ├── RouteCards.tsx
            ├── MapView.tsx
            ├── Heatmap.tsx
            ├── TimeSlider.tsx
            ├── CheckpointPopup.tsx
            ├── Legend.tsx
            ├── StatusMessage.tsx
            └── Footer.tsx
```

---

## 5. Risk Methodology & Thresholds

| Hazard Level | Wind Speed (mph) | Rain Rate (in/hr) | Snow Rate (in/hr) | Actionable Advisory |
| :--- | :--- | :--- | :--- | :--- |
| **Low** | &lt; 25 mph | &lt; 0.10 in/hr | &lt; 0.50 in/hr | Normal highway operations. |
| **Moderate** | 25 – 34 mph | 0.10 – 0.25 in/hr | 0.50 – 1.00 in/hr | Exercise caution; slight speed reduction recommended. |
| **High** | 35 – 44 mph | 0.25 – 0.50 in/hr | 1.00 – 2.00 in/hr | Reduced speeds; high rollover risk on light/unladen trailers. |
| **Severe** | 45 – 54 mph | 0.50 – 1.00 in/hr | 2.00 – 3.00 in/hr | High wind/hydroplaning danger. Critical freight safety alert. |
| **No Travel** | $\ge$ 55 mph | &gt; 1.00 in/hr | &gt; 3.00 in/hr | Road impassable / dangerous. Commercial dispatch halt. |

### Freight Weight Escalation
- **Tier 1 (45–54 mph Wind + Load &gt; 30,000 lbs)**: Escalated to **No Travel**.
- **Tier 2 (35–44 mph Wind + Load &gt; 40,000 lbs)**: Escalated to **Severe**.

---

## 6. Installation & Setup

### Prerequisites
- Python 3.12+
- Node.js 20+ & npm

### Backend Setup
```bash
# Navigate to backend directory
cd backend

# Create virtual environment (optional but recommended)
python -m venv venv
# On Windows:
venv\Scripts\activate
# On Linux/macOS:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Run migrations
python manage.py migrate

# (Optional) Verify backend tests
pytest
```

### Frontend Setup
```bash
# Navigate to frontend directory
cd frontend

# Install npm dependencies
npm install
```

---

## 7. Execution Commands

### Quick Start (One-Click Launchers on Windows)
You can launch both the backend API and frontend dev server simultaneously:

- **Using Command Prompt / File Explorer**:
  Double-click `run.bat` or in terminal run:
  ```cmd
  run.bat
  ```
- **Using PowerShell**:
  ```powershell
  .\run.ps1
  ```

This will automatically start both servers in dedicated terminal windows and open the application in your browser at `http://localhost:5173`.

---

### Manual Terminal Execution

#### Terminal 1 — Backend API (Django)
```bash
python backend/manage.py runserver 127.0.0.1:8000
```
The Django REST API will be accessible at `http://localhost:8000/api/` (Health check: `http://localhost:8000/api/health`).

#### Terminal 2 — Frontend UI (Vite + React)
```bash
cd frontend
npm run dev
```
The application interface will be live at `http://localhost:5173/`.

---

## 8. Testing & Quality Verification

### Run Backend Unit & Integration Tests
```bash
cd backend
pytest
```
*Executes all 22 test cases covering wind/rain/snow boundaries, load escalations, haversine geometry, ETA interpolation, segment reconciliation, lexicographic ranking, and REST endpoints.*

### Run Backend Ruff Linter
```bash
cd backend
ruff check .
```

### Run Frontend Typecheck & Linter
```bash
cd frontend
npm run typecheck
npm run lint
```

### Run Frontend Production Build
```bash
cd frontend
npm run build
```

---

## 9. API Documentation

### `GET /api/health`
Returns system status, version, provider inventory, and academic disclaimer.

### `GET /api/geocode?q={query}&limit=5`
Provides Nominatim address autocomplete and coordinate lookup.

### `POST /api/analyze`
Executes end-to-end route extraction, weather sampling, hazard assessment, and ranking.

**Request Payload:**
```json
{
  "origin": "Chicago, IL",
  "destination": "Denver, CO",
  "departure_time": "2026-11-05T08:00:00Z",
  "load_weight_lbs": 42000,
  "checkpoint_interval_miles": 25.0,
  "use_sample_data": false
}
```

---

## 10. Attributions & Limitations

### Required Provider Attributions
- **Road Geometry & Map Tiles**: &copy; [OpenStreetMap](https://www.openstreetmap.org/copyright) contributors.
- **Routing Engine**: [OSRM (Open Source Routing Machine)](https://project-osrm.org/).
- **Weather Forecasts**: [Open-Meteo](https://open-meteo.com/).
- **Geocoding**: [Nominatim](https://nominatim.org/).

### Academic Project Disclaimer
*SPOTTER is an academic capstone demonstration. Road routing data from OSRM is modeled on general highway networks and does not replace certified commercial truck routing solutions. Commercial motor carriers must separately verify bridge vertical clearances, seasonal frost laws, HAZMAT routing restrictions, and state-specific gross axle weight limits.*

