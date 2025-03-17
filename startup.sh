#!/bin/bash

# Install dependencies
pip install -r requirements.txt

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate

# Create superuser (will only create if it doesn't exist)
echo "Creating superuser if it doesn't exist..."
python manage.py createsuperuser --noinput || echo "Superuser already exists"

# Start Gunicorn
echo "Starting Gunicorn..."
gunicorn questionpaper.wsgi:application --bind=0.0.0.0:8000 