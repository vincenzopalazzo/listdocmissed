FROM ubuntu:latest as builder
MAINTAINER Christian Decker <decker@blockstream.com>

ARG LIGHTNINGD_VERSION=master
ENV DEBIAN_FRONTEND=noninteractiv

RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
	git build-essential autoconf automake build-essential git libtool libgmp-dev \
	libsqlite3-dev python3 python3-mako net-tools zlib1g-dev libsodium-dev \
	gettext apt-transport-https ca-certificates

RUN git clone --recursive https://github.com/ElementsProject/lightning.git /tmp/lightning
WORKDIR /tmp/lightning
RUN git checkout $LIGHTNINGD_VERSION
RUN ./configure --prefix=/tmp/lightning_install --enable-developer --disable-valgrind --enable-experimental-features
RUN make install

FROM ubuntu:latest as final

COPY --from=builder /tmp/lightning_install/ /usr/local/

RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
	libsqlite3-dev \
	zlib1g-dev \
	libsodium-dev \
	libgmp-dev \
	python3 \
	python3-pip \
	wget \
	&& rm -rf /var/lib/apt/lists/*

ARG BITCOIN_VERSION=0.18.1
ENV BITCOIN_TARBALL bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz
ENV BITCOIN_URL https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/$BITCOIN_TARBALL
ENV BITCOIN_ASC_URL https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc

RUN cd /tmp \
	&& wget -qO $BITCOIN_TARBALL "$BITCOIN_URL" \
	&& wget -qO bitcoin.asc "$BITCOIN_ASC_URL" \
	&& grep $BITCOIN_TARBALL bitcoin.asc | tee SHA256SUMS.asc \
	&& sha256sum -c SHA256SUMS.asc \
	&& BD=bitcoin-$BITCOIN_VERSION/bin \
	&& tar -xzvf $BITCOIN_TARBALL $BD/bitcoin-cli $BD/bitcoind --strip-components=1 \
	&& cp bin/bitcoind bin/bitcoin-cli /usr/bin/ \
	&& rm -rf $BITCOIN_TARBALL bin

# Make the debug logs available during testing
ENV TEST_DEBUG 1

# Speed up testing by shortening all timeouts
ENV DEVELOPER 1

WORKDIR /build
ADD requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

CMD ["pytest", "-vvv", "--timeout=600", "-n=4"]
