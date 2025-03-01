FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
    wget curl nano git build-essential libssl-dev supervisor

# Install Bitcoin Core
RUN wget https://bitcoincore.org/bin/bitcoin-core-26.0/bitcoin-26.0-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-26.0-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-26.0/bin/* /usr/local/bin/ && \
    rm -rf bitcoin-26.0*

# Install Ethereum (Geth)
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.11-1f23e315.tar.gz && \
    tar -xzf geth-linux-amd64-1.13.11-1f23e315.tar.gz && \
    mv geth-linux-amd64-1.13.11-1f23e315/geth /usr/local/bin/ && \
    rm -rf geth-linux-amd64-1.13.11-1f23e315*

# Install Solana CLI (full validator node)
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)" && \
    echo "export PATH=\"/root/.local/share/solana/install/active_release/bin:\$PATH\"" >> /root/.bashrc

# Install Litecoin Core
RUN wget https://download.litecoin.org/litecoin-0.21.3/linux/litecoin-0.21.3-x86_64-linux-gnu.tar.gz && \
    tar -xzf litecoin-0.21.3-x86_64-linux-gnu.tar.gz && \
    mv litecoin-0.21.3/bin/* /usr/local/bin/ && \
    rm -rf litecoin-0.21.3*

# Create data directories
RUN mkdir -p /data/bitcoin /data/ethereum /data/solana /data/litecoin

# Copy configuration files
COPY bitcoin.conf /data/bitcoin/
COPY geth-config.toml /data/ethereum/
COPY solana-config.yml /data/solana/
COPY litecoin.conf /data/litecoin/

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose RPC ports
EXPOSE 8332 8545 8899 9332

# Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
