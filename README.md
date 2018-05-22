# Career Manager
A set of tools and features to help Braven Fellows and Alumni manage their careers, especially in terms of getting their first job out of college.


## Docker Setup

Using docker, it's very easy to get the application up and running. We don't even need to worry about keeping database passwords out of the repo, because Docker will spin up a database that only this application has access to, on a private network.

First, we need to copy a couple of environment files in the app directory:

    cp .env.example .env
    cp .env.database.example .env.database

Again, you don't really need to change the database passwords in these files, so we're doing this mainly to conform to "best practices" for Rails apps in general. But if you do want to pick a different database password, make sure it matches in both files.

Now fire up and build the docker environment. This will create/launch the Rails app, as well as a PostgreSQL database server for the app to use:

    docker-compose up -d

This will take a while the first time, because Docker has to download a Ruby image and a PostgreSQL image and set them up. It will also install all the necessary Ruby gems that the app requires.

Now create the needed databases, and run any necessary migrations:

    docker-compose exec career-mgr rake db:create db:migrate

We've configured Docker to run our Rails app on port 3010, so go to http://localhost:3010 in your favorite browser. If everything's working correctly, you should see the greeting, "Yay! You're on Rails!"

To interact with the app in the console, run this:

    docker-compose exec career-mgr rails c

As you may have guessed, running the app through Docker does have the drawback of having to pre-pend "docker-compose exec career-mgr" to every rails/rake command. If you're in a unix-y environment (and Mac OS X counts) you can add this alias to your ~/.bash-profile file:

    alias career="docker-compose exec career-mgr"

Be sure to re-source this file in any open console windows to get it to work. Now you can issue rails/rake commands like so:

    # launch rails console
    career rails c
    
    # run database migrations
    career rake db:migrate

This README will be updated as the app gets fleshed out and more complicated. For now, enjoy the magic of an app that does nothing, but in a very sophisticated way - requiring no special drivers, libraries, or database servers, or versions of ruby to be installed on your system directly. Magic!