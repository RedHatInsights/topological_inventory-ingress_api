FROM manageiq/ruby:latest

RUN yum -y install --setopt=tsflags=nodocs \
                   # To compile native gem extensions
                   gcc-c++ \
                   # For git based gems
                   git \
                   # For checking service status
                   nmap-ncat \
                   && \
    yum clean all

ENV WORKDIR /opt/insights-topological_inventory-ingress_api/
WORKDIR $WORKDIR

COPY Gemfile $WORKDIR
RUN echo "gem: --no-document" > ~/.gemrc && \
    gem install bundler --conservative --without development:test && \
    bundle install --jobs 8 --retry 3 && \
    find ${RUBY_GEMS_ROOT}/gems/ | grep "\.s\?o$" | xargs rm -rvf && \
    rm -rvf ${RUBY_GEMS_ROOT}/cache/* && \
    rm -rvf /root/.bundle/cache

COPY . $WORKDIR

RUN chgrp -R 0 $WORKDIR && \
    chmod -R g=u $WORKDIR

EXPOSE 4567

ENTRYPOINT ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "4567", "config.ru"]
