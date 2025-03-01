FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
    wget curl nano git neofetch \
    build-essential libssl-dev \
    supervisor

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

# Install Solana CLI
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)" && \
    echo "export PATH=\"/root/.local/share/solana/install/active_release/bin:\$PATH\"" >> /root/.bashrc

# Install Litecoin Core
RUN wget https://download.litecoin.org/litecoin-0.21.3/linux/litecoin-0.21.3-x86_64-linux-gnu.tar.gz && \
    tar -xzf litecoin-0.21.3-x86_64-linux-gnu.tar.gz && \
    mv litecoin-0.21.3/bin/* /usr/local/bin/ && \
    rm -rf litecoin-0.21.3*

# Create data directories
RUN mkdir -p /root/.bitcoin /root/.ethereum /root/.solana /root/.litecoin

# Copy configuration files (you'll need to add these to your project)
COPY bitcoin.conf /root/.bitcoin/
COPY geth-config.toml /root/.ethereum/
COPY solana-config.yml /root/.solana/
COPY litecoin.conf /root/.litecoin/

# Set up Supervisor to manage multiple processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose RPC ports
EXPOSE 8332 8545 8899 9332

# Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
