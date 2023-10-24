Hi, welcome to my project. 

To run my code, first build a docker container with this line in the terminal:

```{bash}
docker build . --build-arg USER_ID=$(id -u) -t 611
````
Then start an RStudio server with this:

```
docker run -d -e PASSWORD=yourpassword --rm -p 8787:8787 -v $(pwd):/home/rstudio/project -t 611
```

And visit http://localhost:8787 in your browser. Log in with user `rstudio` and password `yourpassword`.

Now go into the terminal inside of the RStudio server, use `cd project` to go to my project folder.

And run these to produce two pie charts showing top 5 intake reasons of the shelter animals and top 5 species 
other than cats and dogs of the shelter animals.
```
make figures/tops_reasons.png
make figures/top5_species.png
```
