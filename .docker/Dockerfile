FROM python:3.11

LABEL maintainer="corentin deret"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /srv
COPY ./requirements.txt /srv

# create user
RUN groupadd -r app_user && \
    useradd -r -g app_user -u 1000 -s /sbin/nologin -d /srv -c "Docker image user" app_user

# give user permission to workdir
RUN chown -R app_user:app_user /srv /opt

ENV TZ 'Europe/Paris'
RUN echo $TZ > /etc/timezone && apt-get -o Acquire::ForceIPv4=true update && apt-get -o Acquire::ForceIPv4=true upgrade -y && \
    apt-get -o Acquire::ForceIPv4=true install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

USER app_user

# venv
ENV VIRTUAL_ENV=/opt/.venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# install python dependencies
RUN $VIRTUAL_ENV/bin/pip install --upgrade pip
RUN $VIRTUAL_ENV/bin/pip install --no-cache-dir -r requirements.txt

# venv
ENV VIRTUAL_ENV=/opt/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --chown=app_user:app_user . .
