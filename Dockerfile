FROM python:3.9

RUN apt-get update \ 
    && apt-get -y install cron vim \
    && python -m pip install --upgrade pip

WORKDIR /app

COPY test.py /app
COPY requirements.txt /app  

RUN pip install -r requirements.txt

COPY crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab \
    && /usr/bin/crontab /etc/cron.d/crontab

CMD ["cron", "-f"] 