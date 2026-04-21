# Use a lightweight Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . .

# Expose the FastAPI port
EXPOSE 8003

# Run migrations before starting the server
CMD alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8003
