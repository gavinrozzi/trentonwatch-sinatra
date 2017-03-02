[![Travis Status](https://travis-ci.org/theyworkforyou/shineyoureye-sinatra.svg?branch=master)](https://travis-ci.org/theyworkforyou/shineyoureye-sinatra.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/github/theyworkforyou/shineyoureye-sinatra/badge.svg)](https://coveralls.io/github/theyworkforyou/shineyoureye-sinatra)

# Shine Your Eye (Sinatra)

This project is a proof of concept that aims to make it easy to produce
lightweight parliamentary monitoring sites. It uses EveryPolitician data,
user-editable data (through [prose.io](http://prose.io/)), and CSV data.
It doesn't use a database.

It is meant to be an exemplar. A generic core could be extracted from it,
leaving ShineYourEye specifics out, so that a parliament-monitoring site can be
implemented for other countries as well, using this approach.

## Approach

The approach of this project is similar to
[`viewer-sinatra`](https://github.com/everypolitician/viewer-sinatra):

* This is a Sinatra application that uses content produced by
[prose.io](http://prose.io/) that is saved in
[`shineyoureye-prose`](https://github.com/theyworkforyou/shineyoureye-prose).
* A script pulls this content, runs the app and scrapes it.
* Then pushes the scraped pages to the `gh-pages` branch of another repo,
[`shineyoureye-static`](https://github.com/theyworkforyou/shineyoureye-static).

Non-technical users can use [prose.io](http://prose.io/) to add content to the
prose repo. Then, whenever there is a change in that repo, the script runs,
producing an updated version of the site in the static repo.

Running a static site vs a dynamic one has several advantages. Also, we benefit
from GitHub's free hosting.


## Data sources

This project uses data from several different sources:

* The basic details of current Senators and members of the House
  of Representatives are from EveryPolitician. This
  EveryPolitician data is acceessed using the
  [everypolitician gem](https://github.com/everypolitician/everypolitician-ruby). The
  data on Nigeria is sourced from:
    * The National Assembly website http://www.nass.gov.ng/
    * The old Pombola-based ShineYourEye website's Popolo
      JSON dumps, via
      https://morph.io/everypolitician-scrapers/nigeria-shineyoureye
    * Wikidata
* Boundaries and geographical area information are from a MapIt instance:
  http://nigeria.mapit.mysociety.org/
     * Mappings between Federal Constituencies and Sentorial
       Districts and their parent states are stored in the
       responsitory. (n.b. these could be set in MapIt instead;
       in fact, the senatorial districts already have
       `parent_area` set to the appropriate state):
         * `mapit/sen_to_sta_area_ids_mapping.csv`
         * `mapit/fed_to_sta_area_ids_mapping.csv`
     * Mappings between EveryPolitician area IDs and MapIt area
       IDs are stored in the repository:
         * `mapit/mapit_to_ep_area_ids_mapping_FED.csv`
         * `mapit/mapit_to_ep_area_ids_mapping_SEN.csv`
     * Mappings between the slugs used for places in the old
       Pombola-based ShineYourEye website and MapIt IDs are
       stored in the repository:
         * `mapit/pombola_place_slugs_to_mapit.csv`
* Details of local governors are from a scraper hosted on Morph
  https://morph.io/everypolitician-scrapers/nigeria-state-governors
     * That gets data from:
         * http://www.nigeriaembassyusa.org/
         * The old Pombola-based ShineYourEye website's Popolo
           JSON dumps
* The images of politicians referenced by the site are served
  from GitHub pages:
     * https://github.com/theyworkforyou/shineyoureye-images
     * That repository caches, at various sizes, the images from
       EveryPolitician. The cache is generated by the
       `multiple-thumbnail-sizes` branch of `image_cache`:
       `https://github.com/everypolitician/image_cache/tree/multiple-thumbnail-sizes`

## Development


### How to use this project

This is a Ruby project.
You will need to tell your favourite Ruby version manager to set your local Ruby
 version to the one specified in the `Gemfile` file.

For example, if you are using
[rbenv](https://cbednarski.com/articles/installing-ruby/):

1. Install the right Ruby version. That would be the version specified at the
beginning of the Gemfile. For example, if it was `ruby '2.3.1'`, you would type:
```bash
rbenv install 2.3.1
rbenv rehash
```
2. Then you would move to the root directory of this project and type:
```bash
rbenv local 2.3.1
ruby -v
```

You will also need to install the `bundler` gem, which will allow you to install
 the rest of the dependencies listed in the `Gemfile` file of this project.

```bash
gem install bundler
rbenv rehash
```


### Folder structure

* `bin `: scripts, like deploy scripts, etc.
* `lib `: the codebase
* `lib/document`: code to parse [prose.io](http://prose.io/) files (markdown
  with frontmatter)
* `lib/ep`: code to parse EveryPolitician data
* `lib/helpers`: mostly site-specific stuff
* `lib/mapit`: code to parse Mapit data
* `lib/page`: presenters to extract all logic out of the views
* `mapit`: CSV files that map MapIt Area IDs to other IDs
* `prose`: where the `shineyoureye-prose` repository will be cloned. Contains
user introduced content, like blog posts, events, etc.
* `public`: static assets
* `public/stylesheets/sass`: sass files automatically compiled into css
* `tests`: all the tests
* `views`: the erb templates to build the site


## Running the app

### Initialise the project

```bash
bundle install
```

### Prepare data for the app

```
bin/prepare-data
```

This will copy the user-editable contents of the site (the blog posts
and static pages generated using [prose.io](http://prose.io/)) into a
`prose` directory.

### Run the app

```bash
bundle exec rackup
```

And go to <http://localhost:9292/>


## Tests

(Assuming you have installed the fixtures with `bin/prepare-data`, as above.)

### Run the tests

```bash
bundle exec rake test
```

### Run one test file

```bash
bundle exec rake test TEST='path/to/test/file'
```
