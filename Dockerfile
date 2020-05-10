FROM strusfr/docker-ubuntu1604-slurmbase

#RUN add-apt-repository universe && apt-get update -y && apt-cache search prometheus
#RUN curl https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz | tar xzf - -C /usr/local --strip-components=1

# Set environment variables.
#ENV GOROOT /usr/local
#ENV GOPATH /usr/local/go
#ENV PATH $PATH:/usr/local/go/bin:/usr/local/bin

RUN add-apt-repository universe && apt-get update -y && apt-cache search golang-github
RUN apt-get install -y golang-github-prometheus-client-golang-dev git build-essential golang
RUN which go
# Copy all slurm commands in /usr/bin ... otherwise prometheus exprter won't work.
RUN cp /usr/local/bin/s* /usr/bin/.

RUN git clone https://github.com/vpenso/prometheus-slurm-exporter.git \
    && cd prometheus-slurm-exporter \
    && make build \
    && cp bin/prometheus-slurm-exporter /usr/bin/prometheus-slurm-exporter \
    && chmod 755 /usr/bin/prometheus-slurm-exporter

RUN mkdir -p /var/spool/slurmctld \
    && chmod 755 /var/spool/slurmctld

ADD scripts/start.sh /root/start.sh
RUN chmod +x /root/start.sh

ADD etc/supervisord.d/slurmctld.conf /etc/supervisor/conf.d/slurmctld.conf

CMD ["/bin/bash","/root/start.sh"]
