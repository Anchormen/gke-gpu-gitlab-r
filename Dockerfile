# For example tensorflow/tensorflow:1.10.0-py3 for cpu or nvcr.io/nvidia/tensorflow:18.10-py3 for gpu
FROM IMAGE_NAME

MAINTAINER a.sevilla@anchormen.nl

ENV R_BASE_VERSION 3.5.1
# Install libraries required for R or for other uses
RUN apt-get -y update \
	&& apt-get install -y --no-install-recommends \
		apt-transport-https \
		ca-certificates \
		ed \
		file \
		fonts-texgyre \
		git \
		less \
		libapparmor1 \
		libcurl4-openssl-dev \
		libedit2 \
		libssh2-1 \
		libssh2-1-dev \
		libssl-dev \
		locales \
		lsb-release \
		nano \
		openssh-client \
		psmisc \
		software-properties-common \
        sudo \
		vim-tiny \
		wget \
	&& rm -rf /var/lib/apt/lists/*  

# Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8
	
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Keras Installation
RUN pip install keras

# R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/' \
	&& apt-get update -y \
	&& apt-get install -y --no-install-recommends \
		r-base=${R_BASE_VERSION}* \
		r-base-dev=${R_BASE_VERSION}* \
		r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/* \
	&& R -e "install.packages('devtools')"

## Install tensorflow and keras libraries from https://keras.rstudio.com/
RUN R -e "devtools::install_github('rstudio/tensorflow')"
RUN R -e "devtools::install_github('rstudio/keras')"
