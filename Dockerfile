FROM python:3.11-slim

WORKDIR /app

# Prevent python buffer issues in logs
ENV PYTHONUNBUFFERED=1

# Install dependencies first (better caching)
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Flask default port
EXPOSE 5000
FROM python:3.11-slim

<<<<<<< HEAD
# Run app
=======
WORKDIR /app

# Prevent python buffer issues in logs
ENV PYTHONUNBUFFERED=1

# Install dependencies first (better caching)
COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Flask default port
EXPOSE 5000

# Run app
CMD ["python", "app.py"]
>>>>>>> 89a2d36 (docker-file-commit)
CMD ["python", "app.py"]
