FROM postgres:latest
COPY ./DBScript /docker-entrypoint-initdb.d/
