FROM lambci/lambda:build-python3.6
ARG RUBY_VERSION=2.5.1
ARG GEM_INSTALLED=inspec
ARG INSPEC_VERSION=2.2.64

RUN yum -y install zlib-devel gcc zip

RUN curl -sL https://cache.ruby-lang.org/pub/ruby/2.5/ruby-$RUBY_VERSION.tar.gz | tar -zxv

WORKDIR ruby-$RUBY_VERSION

RUN ./configure --prefix=/var/task/customruby --disable-werror --disable-largefile --disable-install-doc --disable-install-rdoc --disable-install-capi --without-gmp --without-valgrind
RUN make
RUN make install
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN /var/task/customruby/bin/gem install inspec -v $INSPEC_VERSION --no-ri --no-doc

COPY lambda.py /var/task
WORKDIR /var/task

# Create a lambda deployment package
RUN zip -r lambda.zip customruby/ lambda.py
