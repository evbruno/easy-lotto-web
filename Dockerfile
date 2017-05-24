FROM ubuntu:trusty

ENV PG_VERSION=9.6
ENV RUBY_VERSION=2.4.1
ENV RAILS_VERSION=5.1.1
ENV PG_GEM_VERSION=0.20

RUN apt-get update && apt-get install -y curl git vim nodejs wget
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
RUN apt-get update
RUN apt-get install -y "postgresql-$PG_VERSION"

# ruby/rails

RUN apt-get update && apt-get install -y curl git libpq-dev vim nodejs wget
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN /bin/bash -l -c "curl -sSL https://get.rvm.io | bash -s stable"
RUN /bin/bash -l -c "rvm install $RUBY_VERSION"
RUN /bin/bash -l -c "rvm use $RUBY_VERSION --default"
RUN /bin/bash -l -c "ruby -v"
RUN /bin/bash -l -c "gem install bundler"
RUN /bin/bash -l -c "gem install rails -v $RAILS_VERSION"
RUN /bin/bash -l -c "gem install pg -v $PG_GEM_VERSION"
RUN echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc

# PG dev only
RUN cd /etc/postgresql/9.6/main && \
    cp postgresql.conf postgresql.conf.orig && \
    sed -i.bak "s/ssl.*=.*on/#ssl=off/g" postgresql.conf && \
    sed -i.bak "s/#listen_addresses.*=.*'.*'/listen_addresses='*'/g" postgresql.conf && \
    cp pg_hba.conf pg_hba.conf.orig && \
    echo 'host  all all 0.0.0.0/0 trust' > pg_hba.conf && \
    echo 'host  all all ::1/128   trust' >> pg_hba.conf && \
    echo 'local all all           trust' >> pg_hba.conf

ENTRYPOINT /etc/init.d/postgresql restart && \
    tail -10f /var/log/postgresql/postgresql-9.6-main.log

