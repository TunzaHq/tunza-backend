# Tunza - Backend Server

## Description

This is the backend server for Tunza. It is built using Dart on Zero framework.

## Getting Started

### Prerequisites

- [Dart](https://dart.dev/get-dart)
- [Zero Framework](https://zero.vercel.app)
- [PostgreSQL](https://www.postgresql.org/)

### Installation

1. Clone the repo

   ```sh
   git clone https://github.com/tunzahq/tunza-backend.git
   ```

2. Install dependencies

   ```sh
   dart pub get
   ```

3. Create a `.env` file in the root directory

   ```sh
    cp .env.example .env
    ```
4. Import the [Tunza.sql](./tunza.sql) file into your PostgreSQL instance

5. Run the server

   ```sh
   zero run
   ```

### Usage

 Import the [Tunza Postman collection](./tunza.json) to test the API endpoints.
