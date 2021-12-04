FROM rocker/r-ver:4.1.1
RUN apt-get update && apt-get install -y  gdal-bin git-core libcurl4-openssl-dev libgdal-dev libgeos-dev libgeos++-dev libgit2-dev libglpk-dev libgmp-dev libicu-dev libmpfr-dev libpng-dev libproj-dev libssl-dev libudunits2-dev libxml2-dev make pandoc pandoc-citeproc && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("magrittr",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.1.4")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.0.7")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.5")'
RUN Rscript -e 'remotes::install_version("scales",upgrade="never", version = "1.1.1")'
RUN Rscript -e 'remotes::install_version("sf",upgrade="never", version = "1.0-4")'
RUN Rscript -e 'remotes::install_version("leaflet",upgrade="never", version = "2.0.4.1")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.2")'
RUN Rscript -e 'remotes::install_version("pkgload",upgrade="never", version = "1.2.3")'
RUN Rscript -e 'remotes::install_version("attempt",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("broom",upgrade="never", version = "0.7.10")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.7.1")'
RUN Rscript -e 'remotes::install_version("recipes",upgrade="never", version = "0.1.17")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("tmap",upgrade="never", version = "3.3-2")'
RUN Rscript -e 'remotes::install_version("textrecipes",upgrade="never", version = "0.4.1")'
RUN Rscript -e 'remotes::install_version("styler",upgrade="never", version = "1.6.2")'
RUN Rscript -e 'remotes::install_version("stopwords",upgrade="never", version = "2.3")'
RUN Rscript -e 'remotes::install_version("shinyFeedback",upgrade="never", version = "0.4.0")'
RUN Rscript -e 'remotes::install_version("shinycssloaders",upgrade="never", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("readr",upgrade="never", version = "2.1.0")'
RUN Rscript -e 'remotes::install_version("rcartocolor",upgrade="never", version = "2.0.0")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("glmnet",upgrade="never", version = "4.1-3")'
RUN Rscript -e 'remotes::install_version("ggstatsplot",upgrade="never", version = "0.9.0")'
RUN Rscript -e 'remotes::install_version("ggside",upgrade="never", version = "0.1.3")'
RUN Rscript -e 'remotes::install_version("echarts4r",upgrade="never", version = "0.4.2")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.20")'
RUN Rscript -e 'remotes::install_version("colourvalues",upgrade="never", version = "0.3.7")'
RUN Rscript -e 'remotes::install_github("JohnCoene/waiter@c5dd934f9fb35368a335701402e6e79d40c94267")'
RUN Rscript -e 'remotes::install_github("mfherman/nycgeo@4fee55c1c1d201744f7ea65acf355fded1886105")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');library(nyclodging);run_app()"
