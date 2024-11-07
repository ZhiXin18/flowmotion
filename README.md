# FlowMotion

**FlowMotion** helps Singaporean drivers plan their commutes efficiently by providing real-time traffic congestion insights and routes to their destination. The app analyzes live images from traffic cameras across Singapore to assess congestion levels, and presents data in easy-to-read graphs to keep users updated on current conditions and traffic patterns.

---

## Features

### 1)Register Screen
- First-time users can register with their email, which is verified via a one-time password.
- Strong password creation adhering to security guidelines.
- Input of postal codes, labels, and street names for bookmarked destinations, with street name verification against postal codes.
- Users can enable notifications and consent to data storage and location privacy.

### Login Screen
- Returning users login using their registered credentials.
- Password reset link is sent via email if required.
- Access to the home screen upon successful login.

### Profile Screen
- Displays username and a list of saved addresses.
- Swipe to remove addresses and a save button to verify postal codes.

### Home Screen
- Mini Map view with a "View Full Map" button.
- Section for saved places.

### Full Map View
- All 90 traffic camera congestion markers.
- Detailed congestion pop-ups for each camera location.
- Last 10 hours and last 5 days congestion ratings.
- Congestion details for saved places.

### Map Features
- Optimized and non-optimized routes.
- User current location and destination markers.
- Full list of congestion points and route instructions.
- Detailed congestion sections and historical data visualization.

---

## Our System Design

### Tech Stack
- **Mobile**: Flutter
- **Backend**: Express.js
- **Database**: Firestore
- **IDP**: Firebase Authentication
- **Pipeline**: GitHub Actions / Python
- **Model**: YOLOv8 / PyTorch

### External APIs
- **Traffic Data**: data.gov.sg Traffic Images API
- **Routing**: OSRM API (non-congestion weighted routes)

### Infrastructure
- **Google Cloud**: Firebase & Cloud Run (auto-scaling)
- **Docker**: Streamlines deployment by encapsulating dependencies.

### Design Patterns
- **CQRS**: Separation of pipeline writes to DB from backend reads.
- **Caching DB**: Satisfies latency requirements.
- **Event Sourcing**: Congestion ratings stored append-only for historical data analysis.

---

## Routing and Traffic Analysis

### Use Case UC-4: Display Recommendations Based on Route
1. Model infers congestion rating from traffic images.
2. Pipeline matches congestion points to roads.
3. OSRM configures a congestion-weighted routing profile.
4. Mobile app requests routing data.
5. Backend geocodes and forwards route instructions.
6. Mobile app displays route and data.

## Machine Learning Model

### Custom Model Development
- Data augmented YOLOv8n for vehicle detection and semantic segmentation of road areas.
- Traffic image data downloaded from data.gov.sg.
- Confusion matrices and testing shows ensure high precision.

### Congestion Rating Calculation
- Real-time vehicle detection and congestion scoring.
- Integration with OSRM for route recommendations.

---

## Performance Metrics

1. **Image Processing Time**: Average of 123.6 ms per image.
2. **YOLOv8n Detection Accuracy**: mAP of 61.1% for overall detection, but 80% for cars.
3. **Routing Precision**: Benchmarked against Google Maps for a given start and end points.
4. **Latency**: Worst-case scenario, the route prediction uses images captured 332 seconds ago, this has been optimized for urban traffic conditions.

---

## Development Practices

### Test-Driven Development (TDD)
- Unit tests alongside code development.
- Increased test coverage using `pytest`.

### Continuous Integration/Continuous Deployment (CI/CD)
- Automated builds and tests using GitHub Actions.
- Deployment with Docker containers to Google Cloud Run.

### Agile Scrum Framework
- Sprints of 5-7 days, with weekly stand-ups and retrospectives.

### Key Learnings
- Improved data storage and aggregation strategies.
- Use of OpenAPI for backend-mobile synchronization.
- Vectorization for performance optimizations.
- Collaboration and best practices in team environments.



## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
