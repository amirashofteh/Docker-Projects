const { createClient } = require("redis");
const express = require("express");
const { Pool } = require("pg");

const app = express();
const PORT = 3000;

const pool = new Pool({
    host: "postgres",
    port: 5432,
    user: "appuser",
    password: "apppassword",
    database: "appdb"
});

const redisClient = createClient({
    url: "redis://redis:6379"
});

redisClient.on("error", (err) => {
    console.error("Redis Client Error", err);
});

redisClient.connect();

app.get("/", (req, res) => {
    res.json({
        message: "Node.js application is running"
    });
});

app.get("/health", (req, res) => {
    res.json({
        status: "healthy"
    });
});

app.get("/db", async (req, res) => {
    try {
        const result = await pool.query("SELECT NOW()");
        res.json({
            database: "connected",
            time: result.rows[0].now
        });
    } catch (error) {
        res.status(500).json({
            database: "disconnected",
            error: error.message
        });
    }
});
app.get("/cache", async (req, res) => {
    try {
        await redisClient.set("message", "Hello from Redis!");

        const value = await redisClient.get("message");

        res.json({
            cache: "connected",
            value: value
        });
    } catch (error) {
        res.status(500).json({
            cache: "disconnected",
            error: error.message
        });
    }
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on port ${PORT}`);
});
