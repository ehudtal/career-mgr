# Career Manager
A set of tools and features to help Braven Fellows and Alumni manage their careers, especially in terms of getting their first job out of college.


## Setup

### Docker (preferred)

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

If you'd like to start out with some basic seed data to better see how the system works, run this:

    docker-compose exec career-mgr rake db:seed

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

### Non-Docker (untested)

First, we need to copy a couple of environment files in the app directory:

    cp .env.example .env
    cp .env.database.example .env.database

Change the POSTGRES_PASSWORD in `.env` and `.env.database`, and make sure you use the same password for both.

Now install nodejs and ruby 2.4:

    apt-get install nodejs ruby=2.4

You may have to pre-pend "sudo" to installation commands if you're not running as root. Now install the bundler gem:

    gem install bundler

Now you can let the Rails app install all the needed Ruby gems for you:

    bundle install

Note, bundler will complain (but still work) if you try to do this as root - you don't need to, unless you're in a VM (or docker) where there is ONLY a root user.

You'll need to also setup PostgreSQL server, which is out of the scope of this README. Be sure to setup the `postgres` user with the password you picked above. Then run:

    rake db:create db:migrate

Now you should be able to run the app using the following command. We're specifying the same non-standard 3010 port so this rails app doesn't conflict with any others you may be running:

    rails s -p 3010

Go to http://localhost:3010 in your favorite browser. If everything's working correctly, you should see the greeting, "Yay! You're on Rails!"

## Post-Setup

At least once, you should load the database with valid zip codes and metro areas. The import files are not in the repo, they're too large. They're located in Google Drive:

* `postal-codes.csv`: https://drive.google.com/open?id=1vfwSF3bwX2GnM7fLq3iktgR7CDIhaPsI
* `msa.txt`: https://drive.google.com/open?id=16oM_ZJXogOBtz9U6MDEaZXzW6fn4AMog

Copy them to the `tmp`, then:

    docker-compose exec career-mgr rake postal:load

This will allow the app to calculate distances between fellows and opportunities, and will generate all the needed metro areas for fellow/opp matching.

## Continuing Development

Whenever you pull in changes from upstream, you should run these commands in the root directory of the app:

    docker-compose build career-mgr
    docker-compose stop career-mgr
    docker-compose up -d --force-recreate career-mgr
    
    docker-compose exec career-mgr rake db:migrate
    
    docker-compose exec career-mgr rspec

If you make updates to `Gemfile` on your own, run the first group of commands above. If you create migrations of your own, run the `rake db:migrate` command to update the database.

Periodically, run rspec to ensure that you haven't broken any existing tests with your code changes. And you should be adding your own tests, right? ;) Definitely run rspec before creating a pull request.

If you'd like to reset the database to the original seed data (with example employers, industries, and interests), you can re-run this command at any time:

    docker-compose exec career-mgr rake db:seed

## Testing

You can run the test suite like so:

    docker-compose exec career-mgr rspec

You can open a dedicated terminal window and have tests run automatically as you code:

    docker-compose exec career-mgr guard


## Conclusion

This README will be updated as the app gets fleshed out and more complicated. For now, enjoy the magic of an app that does nothing, but in a very sophisticated way - requiring no special drivers, libraries, or database servers, or versions of ruby to be installed on your system directly. Magic!