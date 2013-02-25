# Rack SEO

Rack SEO takes a page, analyses the content and provides relevant meta tags based on the words in the page.
It's easy to configure (via a YAML file) so you can control all your SEO
meta tags from one place. Works for any 
existing Rack application (including Rails, Sinatra, Padrino etc.)

### Dear God, why?

Whilst this is never going to replace a fully-fledged SEO campaign, I
thought it would be good to have a drop in solution that provided better
defaults than the same title and meta for every page on the site. I also
like the idea that configuration all happens in one place, which means
SEO people or end users don't have to add 30,000 meta tags using a slow
CMS. SEO tags are a common client request and it seems like a lot of
time and effort is wasted on sub-par solutions.

If that still doesn't convince you, that's fine. My only other
reason was that my New Year's resolutions for 2013 included `write a gem` 
and `write some Rack Middleware` so here it is.

## Features

* Provides keyword relevant title, meta-description and meta-keyword tags for every page
* Use CSS selectors to pull any content into the title tag
* Use CSS selectors to specify where to look for the meta description and keyword content e.g. "#intro"
* Fully configurable for each path your app, with wildcard matching using regular expressions

## Installation

```bash
#Assuming Mac OSX and Homebrew 
brew update
brew install libxml2
brew install glib   

#Follow instructions to install the summarize gem
git clone https://github.com/ssoper/summarize.git
cd summarize
rake build
gem build summarize.gemspec
gem install summarize-1.0.4.gem

gem install rack-seo
```

## Usage

In your Gemfile:
```
gem 'rack-seo'
```

then run `bundle install`

and in your config.ru:
```
use Rack::RackSeo
```

or to specify your own config file
```
use Rack::RackSeo :config => "/path/to/config/rack_seo.yml"
```

## The config file

You can put the YAML config wherever you like but I would suggest
`config/rack_seo.yml` for convention. The format is as follows:

```yaml
---
# default is the fallback for any paths that you have not specified
# explicitly.
default: 
  # title_format is a ruby string which parses out anything between {{
  # and }} as a CSS selector (using Nokogiri)
  title_format: "{{h1}} - Acme Ltd"
  # meta_description_selector lets you specify where to pull the text
  # content from to extract the summary text. The default is #content,
  # falling back to the <body> tag if that isn't present. You can
  # specify your own below. It pulls out the inner text and should only
  # match one div or item.
  meta_description_selector: "#my_juicy_keyword_rich_summary_div"
  # Same as the description selector, but automatically generates a
  # comma separated list from the content provided
  meta_keywords_selector: "#my_tag_stuffed_p_tag"
# The custom key (optional) contains any paths you'd like to specify.
# These are tested against the current path, longest first to match the
# most specific by default.
custom:
  -
    matcher: '/blog'
    title_format: "The Acme Company Blog - {{#content h1}}"
    meta_description_selector: "#post_content"
    meta_keywords_selector: "#comments"
  -
    matcher: '/contact-us'
    # Plain old strings are fine too
    title_format: "How to contact us about faulty anvils"
    # You can skip the other selectors if you're happy with the
    # #content/<body> defaults
```  

## Caveats

* Processes on every request, so be sure to use caching in production
* Uses the `summarize` gem, which is a wrapper around ("The Open Text
  Summarizer")[http://libots.sourceforge.net/]. This has dependencies of
its own (see installation) so will probably not work out of the box on
Heroku.

## Credits

I originally did a proof of concept for this using the (Rack
Pagespeed)[http://rack-pagespeed.heroku.com/]
middleware so thanks to @julio_ody for his work on that.

The clever stuff (text summarization and keyword extraction) is all
handled by the summarize gem at the moment so credit to @ssoper and
LibOTS for their work. Other summarizers (maybe even in pure Ruby) are
a focus going forward.

## Contributing to Rack SEO

Contributors are very welcome! Use Github issues for feature requests and other suggestions/improvements.
This project uses RSpec for tests.

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Xavier Riley. See LICENSE.txt for
further details.

