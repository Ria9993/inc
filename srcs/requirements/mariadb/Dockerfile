FROM alpine:3.18.6

WORKDIR /
# COPY ./config/my.cnf /etc/.
COPY ./tools/entry.sh /tmp/.

RUN apk update\
&& apk upgrade\
&& apk add --no-cache mariadb mariadb-client\
&& wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64\
&& chmod +x /usr/local/bin/dumb-init\
&& mariadb-install-db --datadir=/var/lib/mysql/data --auth-root-authentication-method=normal\
\
&& chmod 755 /tmp/entry.sh\
\
&& mkdir -p /run/mysqld/\
&& mkdir -p /var/lib/mysql/data/\
\
&& chmod 755 -R /var/lib/mysql\
\
&& touch /run/mysqld/mysqld.sock\
&& chmod 755 /run/mysqld/mysqld.sock\
&& chown root:mysql /run/mysqld/mysqld.sock\
\
&& touch /var/log/mysqld.log\
&& chmod 660 /var/log/mysqld.log\
&& chown root:mysql /var/log/mysqld.log\
\
&& chown -R root:mysql /run/mysqld\
&& chown -R root:mysql /var/lib/mysql\
\
&& rm -f /etc/my.cnf.d/mariadb-server.cnf

COPY ./config/mariadb-server.cnf /etc/my.cnf.d/.
# In your WordPress database, there must be two users, one of them being the administrator.
# The administrator’s username can’t contain admin/Admin or administrator/Administrator
# (e.g., admin, administrator, Administrator, admin-123, and so forth).

# ENTRYPOINT ["sh"]
STOPSIGNAL SIGQUIT

ENTRYPOINT	[ "/usr/local/bin/dumb-init", "--" ]
CMD			[ "sh", "-c", "/tmp/entry.sh" ]
