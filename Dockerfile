ARG version=latest
FROM lavasoftware/lava-server:${version}

ARG extra_packages=""
RUN apt -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install ${extra_packages}

COPY ./scripts/add_admin.sh /root/add_admin.sh
COPY ./scripts/populate_devices.sh /root/populate_devices.sh
COPY ./scripts/entrypoint_custom.sh /root/entrypoint_custom.sh

# Add super user
ARG admin_username=root
ARG admin_password=password
ARG admin_email=$admin_password@localhost.com
RUN /root/add_admin.sh $admin_username $admin_password $admin_email

ARG workers=
ENV WORKERS=$workers

ENTRYPOINT ["/root/entrypoint_custom.sh"]
