FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y wget curl nano git neofetch software-properties-common supervisor nginx ttyd

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

# Configure Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY dashboard.html /var/www/html/index.html

# Expose all required ports
EXPOSE 8332 8333 8545 8546 8899 9933 19500 19501 10332 10333 7681

# Start Supervisor + Nginx
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
