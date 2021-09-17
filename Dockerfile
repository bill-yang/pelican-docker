FROM python:3.9-slim-buster

RUN apt-get update
RUN apt-get install -y git make

# prevent writing .pyc files
ENV PYTHONDONTWRITEBYTECODE 1

# prepare workdir
RUN mkdir /website && chmod 777 /website && \
	mkdir /website/output && chmod 777 /website/output

# install pip and pip packages
WORKDIR /website
COPY requirements.txt ./
RUN pip install --upgrade pip && \
	pip install -r requirements.txt

# only download the pelican-boostrap3 theme 
WORKDIR /website
RUN mkdir themes \
	&& cd themes \
	&& git init \
	&& git remote add origin -f https://github.com/getpelican/pelican-themes.git \
	&& git config core.sparseCheckout true \
	&& echo "/pelican-bootstrap3/" >> .git/info/sparse-checkout \
	&& git pull origin master 

# only download the i18n_subsites plugin
WORKDIR /website
RUN mkdir plugins \
	&& cd plugins \
	&& git init \
	&& git remote add origin -f https://github.com/getpelican/pelican-plugins \
	&& git config core.sparseCheckout true \
	&& echo "/i18n_subsites/" >> .git/info/sparse-checkout \
	&& git pull origin master
