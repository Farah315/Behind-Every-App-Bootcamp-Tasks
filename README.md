# Products Page — Flutter Bootcamp Final Project

A Flutter Products Page with **pagination**, **search** (debounced), and
**category filtering**, built on the DummyJSON Products API.

## Architecture

Clean Architecture in 3 layers, **without a use-case layer** — the BLoC
talks to the repository interface directly. This keeps the project small
while still separating concerns and keeping the domain layer independent
of Flutter/Dio/JSON.

```
lib/
├── core/
│   ├── constants/api_constants.dart      # DummyJSON endpoints & keys
│   ├── network/dio_client.dart           # Thin Dio wrapper
│   └── error/failures.dart               # Failure types (Network/Server/Unknown)
│
└── features/products/
    ├── domain/                           # Pure Dart, no Flutter/Dio imports
    │   ├── entities/
    │   │   ├── product_entity.dart
    │   │   ├── category_entity.dart
    │   │   └── paginated_products_entity.dart
    │   └── repositories/
    │       └── product_repository.dart   # Abstract contract
    │
    ├── data/                             # Talks to the API, maps JSON -> entities
    │   ├── models/
    │   │   ├── product_model.dart
    │   │   ├── category_model.dart
    │   │   └── paginated_products_model.dart
    │   ├── datasources/
    │   │   └── product_remote_data_source.dart
    │   └── repositories/
    │       └── product_repository_impl.dart
    │
    └── presentation/                     # Flutter + flutter_bloc
        ├── bloc/
        │   ├── products_event.dart
        │   ├── products_state.dart
        │   └── products_bloc.dart
        ├── pages/
        │   └── products_page.dart
        └── widgets/
            ├── products_search_bar.dart
            ├── category_chips_row.dart
            ├── product_card.dart
            └── pagination_bar.dart
```

**Dependency rule:** `presentation → domain ← data`. The domain layer
(entities + repository interface) has zero knowledge of Dio, JSON, or
Flutter widgets — it can be unit-tested in isolation and swapped without
touching the UI.

## Features implemented

- **Product grid** — image, title, brand, category, rating, price with
  discount badge, matching the reference design (dark theme, amber accent).
- **Pagination** — via `limit` / `skip` query params, with prev/next
  controls and a `current / total` page indicator.
- **Search** — hits `/products/search?q=` and updates the grid live.
- **Category filter** — chips row populated from `/products/categories`,
  tapping a chip calls `/products/category/{slug}`.
- **Bonus — debounced search**: search events are debounced 400ms using
  `stream_transform`'s `debounce().switchMap()` transformer on the BLoC's
  event stream, so the API is only called once typing pauses.

## State management

`flutter_bloc`. A single `ProductsBloc` + one flat `ProductsState` drive
the whole page — search, category, and pagination all resolve to the same
`_fetchPage()` funnel, so there's one source of truth for "what should be
fetched right now."

## Setup

```bash
flutter pub get
flutter run
```

## Notes

- Grocery items (which DummyJSON returns without a `brand` field) fall
  back to showing the category name instead, to avoid a blank line on
  the card.
- Error states (no internet / server error) show a retry button instead
  of a blank screen.
