# Using CentOS 7 as base image to support rpmbuild (packages will be Dist el7)
FROM rockylinux:8

# Copying all contents of rpmbuild repo inside container
COPY . .

# Installing tools needed for rpmbuild ,
# depends on BuildRequires field in specfile, (TODO: take as input & install)
RUN yum install -y gcc make python2 git && \
    yum install -y yum-utils rpm-build rpmdevtools

# Setting up node to run our JS file
# Download Node Linux binary
RUN curl -O https://nodejs.org/download/release/v16.18.1/node-v16.18.1-linux-arm64.tar.xz

# Extract and install
RUN tar --strip-components 1 -xvf node-v* -C /usr/local

# Install dependecies and build main.js
RUN npm install --production \
&& npm run-script build

# All remaining logic goes inside main.js ,
# where we have access to both tools of this container and
# contents of git repo at /github/workspace
ENTRYPOINT ["node", "/lib/main.js"]
