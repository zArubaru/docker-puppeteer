FROM node:8.12.0-slim
# FROM node:10.13.0-slim@sha256:fefd53d3e2bceeac151d1bb65b4e45238aca5a19bc5cfade099038f7c2449fc1

RUN  apt-get update \
     # See https://crbug.com/795759
     && apt-get install -yq libgconf-2-4 \
     # Install latest chrome dev package, which installs the necessary libs to
     # make the bundled version of Chromium that Puppeteer installs work.
     && apt-get install -y wget --no-install-recommends \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-unstable --no-install-recommends \
     && apt-get install -y git \
     && rm -rf /var/lib/apt/lists/* \
     && curl https://cli-assets.heroku.com/install.sh | sh 

# Install Puppeteer under /node_modules so it's available system-wide
ADD package.json package-lock.json /
RUN npm i && npm i -g yarn
