FROM registry.access.redhat.com/ubi8/ubi

RUN dnf -y --disableplugin=subscription-manager module enable ruby:2.5 && \
    dnf -y --disableplugin=subscription-manager --setopt=tsflags=nodocs install \
      ruby-devel \
      # To compile native gem extensions
      gcc-c++ \
      # For git based gems
      git make redhat-rpm-config \
      # Libraries
      postgresql-devel libxml2-devel \
      && \
    dnf --disableplugin=subscription-manager clean all

ENV WORKDIR /opt/topological_inventory-ingress_api/
ENV RAILS_ROOT $WORKDIR
WORKDIR $WORKDIR

COPY Gemfile $WORKDIR
RUN echo "gem: --no-document" > ~/.gemrc && \
    gem install bundler --conservative --without development:test && \
    bundle install --jobs 8 --retry 3 && \
    find $(gem env gemdir)/gems/ | grep "\.s\?o$" | xargs rm -rvf && \
    rm -rvf $(gem env gemdir)/cache/* && \
    rm -rvf /root/.bundle/cache

COPY . $WORKDIR

RUN chgrp -R 0 $WORKDIR && \
    chmod -R g=u $WORKDIR

EXPOSE 3000

ENV RAILS_ENV production
# Set a value even if we don't use it so active record doesn't blow up
ENV DATABASE_URL postgresql://localhost:5432/postgres

ENTRYPOINT ["bundle", "exec", "rails", "server"]
