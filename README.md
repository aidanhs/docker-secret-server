docker-secret-server
====================

A really simple (stupid) data server in Docker. Possibly useful for providing
secrets to containers during a `docker build`.


As of 1.8, names of containers are automatically inserted into /etc/hosts, so
if you run this container with

```
docker run -d -v /path/to/secrets:/srv/secrets --name dsecret aidanhs/secret-server
```

where /path/to/secrets is a directory with files containing some data, you can
have a Dockerfile like this

```
FROM myimage

ADD http://dsecret/getsecret /getsecret
RUN chmod +x /getsecret
ENV SECRET /getsecret dsecret:4444

RUN $SECRET adminpassword | hash_tool | add_password_to_db
RUN $SECRET ssh_key > id_rsa && chmod 600 id_rsa && \
    ssh -T -i id_rsa root@securebox ~/get_data_dump.sh | load_data && \
    rm id_rsa
```

This is great for temporarily using pieces of data during your build that you
don't want to be baked in the final image (SSH keys, signing keys, passwords),
particularly if you have a build machine with restricted access - security
people sign off code changes, the build is sent to the machine where restricted
operations can be performed, operations people take the build knowing there are
no secrets hidden in the build for anyone to stumble across.

The secret server exposes two ports:

 - port 80 is a http server with secret values available at `/secrets/$key`
   and a special `/getsecret` endpoint giving a static binary for use with...
 - port 4444, a plain tcp endpoint. You can hit this with the `getsecret`
   binary, `netcat` (`echo adminpassword | nc -q 10 dsecret 4444`, where `-q 10`
   is the required option on Ubuntu 14.04 to make `netcat` wait for a response)
   or even [`bash`](http://www.linuxjournal.com/content/more-using-bashs-built-devtcp-file-tcpip).

Security
--------

Tunning this gives anyone else on your machine access to your 'secrets'
directory.

