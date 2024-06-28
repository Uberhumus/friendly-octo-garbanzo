# Use a lightweight base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy all required files
COPY code/ .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user and switch to it
RUN useradd -m python-user
USER python-user

# Expose the port the app runs on
EXPOSE 5001

# Define environment variables
ENV FLASK_APP=main.py

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:5000/ || exit 1

CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:5001 main:app --access-logfile /app/logs/gunicorn.log --error-logfile /app/logs/gunicorn.log"]
# Run the application with Gunicorn, redirecting stdout and stderr to log files
