Introduction
------------

In this analysis, I want to explore whether certain factors of an animal like age, sex, species etc. are related to its possibility to get adopted.

Usage
-----

You'll need Docker and the ability to run Docker as your current user.

You'll need to build the container:

    > docker build . --build-arg USER_ID=$(id -u) -t 611

This Docker container is based on rocker/verse. To run rstudio server:

    > docker run -d -e PASSWORD=yourpassword --rm -p 8787:8787 -v $(pwd):/home/rstudio -t 611
      
, and visit http://localhost:8787 in your browser. Log in with user rstudio and password yourpassword.


Makefile
--------

To build the report, go to the terminal inside of rstudio server and say:

    > make Report.html

