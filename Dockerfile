FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y wget curl nano git neofetch software-properties-common supervisor nginx ttyd

# Create data directories
RUN mkdir -p /data/{bitcoin,ethereum,solana,litecoin}

# Install Blockchain Clients
# Bitcoin Core
RUN wget https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-x86_64-linux-gnu.tar.gz && \
    tar xzf bitcoin-25.0-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-25.0/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-25.0*

# Geth (Ethereum)
RUN add-apt-repository -y ppa:ethereum/ethereum && \
    apt update && apt install -y geth

# Solana
RUN sh -c "$(curl -sSfL https://release.solana.com/stable/install)" && \
    solana config set --url localhost

# Litecoin Core
RUN wget https://download.litecoin.org/litecoin-0.21.2.2/linux/litecoin-0.21.2.2-x86_64-linux-gnu.tar.gz && \
    tar xzf litecoin-0.21.2.2-x86_64-linux-gnu.tar.gz && \
    mv litecoin-0.21.2.2/bin/* /usr/local/bin/ && \
    rm -rf litecoin-0.21.2.2*

# Copy configurations
COPY configs/* /root/.bitcoin/
COPY configs/* /root/.ethereum/
COPY configs/* /root/.solana/
COPY configs/* /root/.litecoin/

# Setup dashboard
COPY dashboard/ /var/www/html/
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 8332 8545 8899 10332 7681
CMD ["/start.sh"]
