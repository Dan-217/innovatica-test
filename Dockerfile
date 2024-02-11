FROM python:3.12.2-slim-bullseye AS backend
WORKDIR /app/backend
COPY requirements.txt ./
RUN python -m venv venv
RUN . venv/bin/activate
RUN pip install --no-cache-dir -r requirements.txt
COPY backend .
RUN python manage.py migrate
RUN echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell

FROM node:20-buster-slim AS frontend
WORKDIR /app/frontend
COPY backend/frontend/package.json .
RUN npm install
COPY backend/frontend .
RUN npm run build
WORKDIR /app/backend
FROM backend
COPY --from=frontend /app/frontend/build/ /app/backend/frontend/build/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]