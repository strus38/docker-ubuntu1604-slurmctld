FROM strusfr/docker-ubuntu1604-slurmbase

RUN add-apt-repository universe && apt-get update -y && apt serach prometheus
RUN apt-get install -y git golang-bin golang-github-prometheus-client-golang-dev

RUN git clone https://github.com/vpenso/prometheus-slurm-exporter.git \
    && cd prometheus-slurm-exporter \
    && export GOPATH=$(pwd):/usr/share/gocode \
    && make build \
    && cp prometheus-slurm-exporter /usr/local/bin/prometheus-slurm-exporter \
    && chmod 755 /usr/local/bin/prometheus-slurm-exporter

RUN mkdir -p /var/spool/slurmctld \
    && chmod 755 /var/spool/slurmctld

ADD scripts/start.sh /root/start.sh
RUN chmod +x /root/start.sh

ADD etc/supervisord.d/slurmctld.conf /etc/supervisor/conf.d/slurmctld.conf

CMD ["/bin/bash","/root/start.sh"]
