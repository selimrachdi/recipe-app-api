FROM python:3.9-alpine3.13
LABEL maintainer="selim"

# Prevents Python from buffering stdout and stderr (useful for logs)
ENV PYTHONUNBUFFERED 1

# Copy requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy application files
COPY ./app /app
WORKDIR /app

# Expose application port
EXPOSE 8000

# Define a build argument for development mode
ARG DEV=false

# Install dependencies and create a virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Set the PATH environment variable to use the virtual environment by default
ENV PATH="/py/bin:$PATH"

# Set the user to a non-root user for better security
USER django-user
