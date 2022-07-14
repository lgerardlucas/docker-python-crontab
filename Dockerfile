FROM python:3.9

RUN apt-get update \ 
    && apt-get -y install cron vim \
    && python -m pip install --upgrade pip

WORKDIR /opt/oracle

RUN apt-get update \
    && apt-get install -y libaio1 wget unzip \
    && wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip \
    && unzip instantclient-basiclite-linuxx64.zip \
    && rm -f instantclient-basiclite-linuxx64.zip \
    && cd /opt/oracle/instantclient* \
    && rm -f *jdbc* *occi* *mysql* *README *jar uidrvci genezi adrci \
    && echo /opt/oracle/instantclient* > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

RUN apt-get update
RUN apt-get install -y locales locales-all
ENV LC_ALL pt_BR.UTF8
ENV LANG pt_BR.UTF8
ENV LANGUAGE pt_BR.UTF8

WORKDIR /app

COPY test.py /app
COPY requirements.txt /app  

RUN pip install -r requirements.txt

COPY crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab \
    && /usr/bin/crontab /etc/cron.d/crontab

CMD ["cron", "-f"] 
