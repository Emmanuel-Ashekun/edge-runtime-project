# docker/inference.py

from flask import Flask, request
import logging
from logging.handlers import RotatingFileHandler
import os

app = Flask(__name__)

# Create log directory
LOG_DIR = "/var/log/edge-apps"
os.makedirs(LOG_DIR, exist_ok=True)

# Configure logger
log_path = os.path.join(LOG_DIR, "app.log")
handler = RotatingFileHandler(log_path, maxBytes=1024*1024, backupCount=5)
handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s')
handler.setFormatter(formatter)

# Add both file and console logging
app.logger.addHandler(handler)
app.logger.setLevel(logging.INFO)
app.logger.propagate = True

@app.route('/')
def hello():
    app.logger.info("Root endpoint hit from %s", request.remote_addr)
    return "Hello from the edge inference container!"

if __name__ == '__main__':
    app.logger.info("Starting Edge Inference App...")
    app.run(host='0.0.0.0', port=8080)
