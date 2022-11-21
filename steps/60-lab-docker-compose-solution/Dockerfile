FROM python:3.8-alpine

LABEL maintainer="Sophie FONFEC"
LABEL version=1.0.0

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY app.py /app

EXPOSE 9090
ENV FLASK_APP=app.py

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]