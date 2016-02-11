# Freelancer
## Built with Ruby on Rails

### Authors
[Toni Rib](http://github.com/tonirib), [Dan Winter](https://github.com/danjwinter), [Joe Perry](https://github.com/jwperry)

This project was created as a part of the curriculum for the [Turing School of Software & Design](http://turing.io) to complete the "Pivot" project.

The original version of this project, from which this version was pivoted, can be found at: [https://github.com/martensonbj/little_shop](https://github.com/martensonbj/little_shop)

### Overview

This Rails application is a marketplace for posting jobs to hire freelance contractors. A user can sign up as a job lister to post jobs that they would like others to complete. Contractors can then bid on the job until the bidding expires. Once bidding has expired, the job lister selects a contractor to complete the job. All contractors who placed a bid are notified via email of the decision. Once the job is completed, the job lister and the contractor who completed the job are able to give feedback to each other.

### Live Version

You can find a live version of this application on Heroku at: [https://freelancer-for-you.herokuapp.com/](https://freelancer-for-you.herokuapp.com/)

### Setup

To set up a local copy of this project, perform the following:

  1. Clone the repository: `git clone https://github.com/jwperry/the_pivot.git`
  2. `cd` into the project's directory
  3. Run `bundle install`
  4. Run `rake db:create db:migrate db:seed` to set up the postgres database and seed it with users, jobs, bids, and comments.
    - If you would like to create your own users, jobs, bids, and comments do not run `db:seed`
    - The seed file does not include any setup for a platform administrator, so those must be created manually by running `rails c` and adding a user to the database with role = 2
  5. Run the application in the dev environment by running `rails s`

### App Features

The app is designed for both the mobile and desktop experience. Some of the main features of the app include:

#### Contractors

Registered contractors can browse jobs by category and place bids on any job. They are only allowed to place a single bid on a job, but they can update or delete they bid. Contractors do not have a public view of the other bids placed on a job, but they can see the total number of bids and the bid price range. Contractors are not allowed to create job listings, but they can upgrade their account to a job lister if desired. Contractors can give feedback to listers if they complete a job.

#### Job Listers

Registered job listers can post jobs to the site. They can select both a bidding close date/time and a "must complete by" date for each job. Contractors can view all of the bids for their own job, but not for another lister's job. They are not able to select a bid until the bidding expiration date and time have past. Once the bidding is closed, the lister selects a the bid they want to accept which moves the job state to "in progress". Once the job has been completed, they can move the job to "complete" on their dashboard. This prompts them to leave feedback for the contractor. Once the lister has left feedback for the contractor, the contractor is notified via email and their dashboard to leave a comment for the lister.

#### Platform Admins

Admins are the 'master user' of the site. An admin is the only user who can delete a job or create a new category. Additionally, admins have all the functionality of a job lister and a contractor. They are also able to see the current bids on any job for any lister.

#### Other Features

The app uses Amazon Web Services S3 to store and host any image uploads. It also utilizes the jQuery library for live filtering of content and jQuery UI for the accordion effect for bidding and feedback notifications. It uses oauth to connect to LinkedIn in case a user wants to import some of their information like name, email, and image when creating an account. It can also authenticate users logging in via LinkedIn. Additionally, it uses the Heroku Scheduler Add-On to check for jobs that have expired bidding every 10 minutes, and moves those jobs from a status of "Bidding Open" to "Bidding Closed." The project utilizes Sass for organization of CSS.

### Test Suite

The test suite tests the application on multiple levels. To run all of the tests, run `rake test` from the terminal in the main directory of the project. The feature tests (integration tests) rely mainly on the [capybara gem](https://github.com/jnicklas/capybara) for navigating the various application views.

The project also utilizes the [simplecov gem](https://github.com/colszowka/simplecov) for quick statistics on code coverage.

### Dependencies

This application depends on many ruby gems, all of which are found in the `Gemfile` and can be installed by running `bundle install` from the terminal in the main directory of the project.
