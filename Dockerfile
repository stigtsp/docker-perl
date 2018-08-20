FROM alpine:3.8
MAINTAINER stig@stig.io

WORKDIR /usr/src/perl
RUN apk update && apk upgrade && apk add curl tar make gcc build-base wget gnupg xz
RUN curl -SLO https://cpan.metacpan.org/authors/id/X/XS/XSAWYERX/perl-5.28.0.tar.xz  \
    && echo '059b3cb69970d8c8c5964caced0335b4af34ac990c8e61f7e3f90cd1c2d11e49 *perl-5.28.0.tar.xz' | sha256sum -c - \
    && tar --strip-components=1 -xf perl-5.28.0.tar.xz -C /usr/src/perl \
    && rm perl-5.28.0.tar.xz \
    && ./Configure -des \
        -Duse64bitall \
        -Dcccdlflags='-fPIC' \
        -Dcccdlflags='-fPIC' \
        -Dccdlflags='-rdynamic' \
        -Dlocincpth=' ' \
        -Duselargefiles \
        -Dusethreads \
        -Duseshrplib \
        -Dd_semctl_semun \
        -Dusenm \
    && make libperl.so \
    && make -j$(nproc) \
    && TEST_JOBS=$(nproc) true make test_harness \
    && make install \
    && curl -LO http://www.cpan.org/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7044.tar.gz \
    && echo '9b60767fe40752ef7a9d3f13f19060a63389a5c23acc3e9827e19b75500f81f3 *App-cpanminus-1.7044.tar.gz' | sha256sum -c - \
    && tar -xzf App-cpanminus-1.7044.tar.gz && cd App-cpanminus-1.7044 && perl bin/cpanm . && cd / \
    && rm -rf /usr/src/perl

WORKDIR /
