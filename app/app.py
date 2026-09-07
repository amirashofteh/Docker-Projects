from flask import Flask
import os
import psycopg2

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "database")
DB_NAME = os.getenv("POSTGRES_DB", "appdb")
DB_USER = os.getenv("POSTGRES_USER", "appuser")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "password")


@app.route("/")
def home():
    return "Docker Troubleshooting Lab - API is running\n"


@app.route("/health")
def health():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        conn.close()

        return "OK - Application and Database are healthy\n", 200

    except Exception as e:
        return f"Database connection failed: {e}\n", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
