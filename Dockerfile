FROM ubuntu:16.04

MAINTAINER sven.eisenschmidt@gmail.com

RUN PACKAGES="\
        build-essential \
        libssl-dev \
        libffi-dev \
        libmysqlclient-dev \
        libpq-dev \
        python-dev \
        python-pip \
    " && \
    apt-get update && \
    apt-get install -y $PACKAGES && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN PACKAGES="\
        mysqlclient  \
        psycopg2 \
        pyhive \
        sqlalchemy-redshift \
        caravel \
    " && \
    pip install --upgrade pip && \
    PYTHONWARNINGS="ignore:DEPRECATION" pip install $PACKAGES

# @see https://github.com/airbnb/caravel/issues/603
RUN fabmanager create-admin --app caravel && \
    caravel db upgrade && \
    caravel init

#RUN PACKAGES="\
#        build-essential \
#        libssl-dev \
#        libffi-dev \
#        libmysqlclient-dev \
#        libpq-dev \
#        python-dev \
#    " && \
#    apt-get remove --purge -y $PACKAGES && \
#    apt-get autoremove --purge -y && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



EXPOSE 8088

CMD ['caravel', 'runserver', '-d']
