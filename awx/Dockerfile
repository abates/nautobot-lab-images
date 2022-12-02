ARG VERSION
FROM local/ansible-awx:${VERSION}

USER root
RUN yum -y update && \
    yum install -y procps && \
    dnf install -y podman && \
    rpm --restore shadow-utils

ADD --chown=501 https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/containers.conf /etc/containers/containers.conf
ADD --chown=501 https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/podman-containers.conf /var/lib/awx/.config/containers/containers.conf

ADD rootfs /
COPY --from=quay.io/ansible/receptor:v1.2.3 /usr/bin/receptor /usr/bin/receptor

ENV VIRTUAL_ENV="/var/lib/awx/venv/awx"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install ansible

RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf

RUN mkdir -p /var/lib/shared
#RUN chown -R 501 /etc/receptor
#RUN chown -R 501 /var/lib/awx

USER root
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/launch_awx.sh"]

