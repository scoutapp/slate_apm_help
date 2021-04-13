# Service Status

We're transparent about our uptime and service issues. If you appear to be experiencing issues with our service:

* [Check out status site](https://status.scoutapm.com). You can subscribe to service incidents.
* [Email us](mailto:support@scoutapm.com)

# Contacting Support

Don't hesitate to contact us at [support@scoutapm.com](mailto:support@scoutapm.com) with any issues. We typically respond in a couple of hours during the business day.

Or, join us on [Slack](http://slack.scoutapm.com/). We are often, but not always, in Slack.

# Reference

## How we collect metrics

Scout is engineered to monitor the performance of mission-critical production applications. Here's a short overview of how this happens:

* Our agent is added as an application dependency (ex: for Ruby apps, add our gem to your Gemfile).
* The agent instruments key libraries (database access, controllers, views, etc) automatically using low-overhead instrumentation.
* Every minute, the agent connects over HTTPS through a 256-bit secure, encrypted connection and sends metrics to our servers.

## Performance Overhead

Our agent is designed to run in production environments and is extensively benchmarked to ensure it performs on high-traffic applications.

Our most recent benchmarks (_lower is better_):

![overhead](overhead.png)

We've [open-sourced our benchmarks](https://scoutapm.com/blog/overhead-benchmarks-new-relic-vs-scout) so you can test on our own. If your results differ, [reach out to us at support@scoutapm.com](mailto:support@scoutapm.com).

### Call Aggregation

During a transaction, the Scout agent records each database call, each external HTTP request, each rendering of a view, and several other instrumented libraries. While each individual pieces of this overall trace has a tiny memory footprint, large transactions can sometimes build up thousands and thousands of them.  

To limit our agent's memory usage, we stop recording the details of every instrument after a relatively high limit. Detailed metrics and backtraces are collected for all calls up to the limit and aggregated metrics are collected for calls over the limit.

## Security

We take the security of your code metrics extremely seriously. Keeping your data secure is fundamental to our business. Scout is nearing a decade storing critical metrics and those same fundamentals are applied here:

* All data transmitted by our agent to our servers is sent as serialized JSON over SSL.
* Our UI is only served under SSL.
* When additional data is collected for slow calls (ex: SQL queries), query parameters are sanitized before sending these to our servers.
* Our infrastructure resides in an SOC2 compliant datacenter.

### Information sent to our servers

The following data is sent to our servers from the agent:

* Timing information collected from our instrumentation
* Gems used by your application
* Transaction traces, which include:
  * The URL, including query parameters, of the slow request. This can be modified to exclude query params via the <a href="#configuration-reference"><code>uri_reporting</code></a> configuration option.
  * IP Address of the client initiating the request
  * Sanitized SQL query statements
* Process memory and CPU usage
* Error counts

<h3 id="git-integration-security">Git Integration</h3>

Scout only needs read-only access to your repository, but unfortunately, Github doesn't currently allow this - they only offer read-write permissions through their OAuth API.

We have asked Github to offer read-only permissions, and they've said that the feature coming soon. In the mean time, we're limited to the permissions structure Github offers. Our current Git security practices:

* we don't clone your repository's code; we only pull the commit history
* the commit history is secured on our servers according to industry best practices
* authentication subsystems within our application ensure your commit history is never exposed to anyone outside your account.

All that said, we suggest the following:

* [Contact Github](https://github.com/contact) about allowing read-only access. This will ensure it stays top-of-mind.
* This is optional and you are able to view backtrace information w/o the integration. It's likely possible to even write a UserScript to open the code locally in your editor or on Github.

#### Workaround for read-only Github Access

With a few extra steps, you can grant Scout read-only access. Here's how:

* Create a team in your Github organization with read-only access to the respective application repositories.
* Create a new Github user and make them a member of that team.
* Authenticate with this user.

## AutoInstruments FAQ

### What files within a Rails app does AutoInstruments attempt to instrument?

AutoInstruments applies instrumentation to file names that match `RAILS_ROOT/app/controllers/*_controller.rb`.

### Why is Autoinstruments limited to controllers?

Adding instrumentation induces a small amount of overhead to each instrumented code expression. If we added instrumentation to every line of code within a Rails app, the overhead would be too significant on a production deployment. By limiting Autoinstruments to controllers, we're striking a balance between visibility and overhead.

### What are some examples of code expressions that are instrumented?

Below are some examples of how autoinstrumented spans appear in traces.

```ruby
# RAILS_ROOT/app/controllers/users_controller.rb
# This file will be instrumented as its name matches `app/controllers/*_controller.rb`.
class UsersController < ApplicationController

  def index
    fetch_users # <- Appears as `fetch_users` in traces.
    if rss? || xml? # <- This is broken into 2 spans within traces: (`rss?` and `xml?`)
      formatter = proc do |row| # <- The entire block will appear under "proc do |row|..."
        row.to_json
      end
      return render_xml # <- Appears as `return render_xml`
    end
  end

  private

  def fetch_users
    return unless authorized? # <- Appears as `return unless authorized?` in traces.
    source ||= params[:source].present? # <- Appears as `params[:source].present?`
    @users = User.all(limit: 10) # <- ActiveRecord queries are instrumented w/our AR instrumentation
  end
```

### Is every method call to an autoinstrumented code expression recorded?

Prior to storing a span, our agent checks if the span's total execution time is at least 5 ms. If the time spent is under this threshold, the span is thrown away and the time is allocated to the parent span. This decreases the amount of noise that appears in traces (spans consuming < 5ms are unlikely optimization candidates) and decreases the memory usage of the agent. Only autoinstrumented spans are thrown away - spans that are explicity instrumented are retained.

### What do charts look like when autoinstruments is enabled?

When autoinstruments is enabled, a large portion of controller time will shift to autoinstruments:

![autoinstruments before after](autoinstruments_before_after.png)

This is expected.

### How much overhead does autoinstruments add?

When When autoinstruments is enabled, you can estimate the additional overhead by inspecting your overview chart. Measure the mean `controller` time before the deploy then `controller` + `autoinstruments` after. The difference between these numbers is the additional overhead.

### How can the overhead of autoinstruments be reduced?

By default, the Scout agent adds autoinstruments to every controller in your Rails app. You can exclude controllers from instrumentation, which will reduce overhead via the [`autoinstruments_ignore`](#auto_instruments_ignore_config) option. To determine which controllers should be ignored:

1. Ensure you are running version 2.6.1 of `scout_apm` or later.
2. Adjust the Scout agent log level to `DEBUG`.
3. Restart your app.
4. After about 10 minutes run the following command inside your `RAILS_ROOT`:

```
grep -A20 "AutoInstrument Significant Layer Histograms" log/scout_apm.log
```

For each controller file, this will display the total number of spans recorded and the ratio of significant to total spans. Look for controllers that have a large `total` and a small percentage of `significant` spans. In the output below, it makes sense to ignore `application_controller` as only 10% of those spans are significant:

```
[09/23/19 07:27:52 -0600 Dereks-MacBook-Pro.local (87116)] DEBUG : AutoInstrument Significant Layer Histograms: {"/Users/dlite/projects/scout/apm/app/controllers/application_controller.rb"=>
  {:total=>545, :significant=>0.1},
 "/Users/dlite/projects/scout/apm/app/controllers/apps_controller.rb"=>
  {:total=>25, :significant=>0.56},
 "/Users/dlite/projects/scout/apm/app/controllers/checkin_controller.rb"=>
  {:total=>31, :significant=>0.39},
 "/Users/dlite/projects/scout/apm/app/controllers/status_pages_controller.rb"=>
  {:total=>2, :significant=>0.5},
 "/Users/dlite/projects/scout/apm/app/controllers/errors_controller.rb"=>
  {:total=>2, :significant=>1.0},
 "/Users/dlite/projects/scout/apm/app/controllers/insights_controller.rb"=>
  {:total=>2, :significant=>1.0}}
```

Add the following to the `common: &defaults` section of the `config/scout_apm.yml` file to avoid instrumenting `application_controller.rb`:

```yaml
common: &defaults
  auto_instruments_ignore: ['application_controller']
```

## ScoutProf FAQ

### Does ScoutProf work with Stackprof?

[ScoutProf](#scoutprof) and StackProf are not guaranteed to operate at the same time.  If you wish to use Stackprof, temporarily disable profiling in your config file (`profile: false`) or via environment variables (`SCOUT_PROFILE=false`). See the agent's [configuration options](#ruby-configuration-options).

### How is ScoutProf different than Stackprof?

Stackprof was the inspiration for ScoutProf.  Although little original Stackprof code remains, we started with Stackprof's core approach, and integrated it with our APM agent gem, changed it heavily to work with threaded applications, and implemented an easy to understand UI on our trace view.

### What do sample counts mean ?

ScoutProf attempts to sample your application every millisecond, capturing a snapshot backtrace of what is running in each thread.  For each successful backtrace captured, that is a sample.  Later, when we process the raw backtraces, identical traces get combined and the sample count is how many of each unique backtrace were seen.

### Why do sample counts vary?

Samples will be paused automatically for a few different reasons:

* If Ruby is in the middle of a GC run, samples won't be taken.
* If the previous sampling hasn't been run, a new sampling request won't be added.

The specifics of exactly how often these scenarios happen depend on how and in what order your ruby code runs. Different sample counts can be expected, even for the same endpoint.

### What are the ScoutProf requirements?

* A Linux-based operating system
* Ruby 2.1+

### What's supported during BETA?

During our BETA period, ScoutProf has a few limitations:

* ScoutProf only runs on Linux. Support for additional distros will be added.
* ScoutProf only breaks down time spent in ActionController, not ActionView and not Sidekiq. Support for other areas will be added.

The ScoutProf-enabled version of `scout_apm` can be safely installed on all environments our agent supports: the limitations above only prevent ScoutProf from running.

### Can ScoutProf be enabled for ActionController::API and ActionController::Metal actions?

Yes. Add the following to your controller:

```ruby
def enable_scoutprof?; true; end
```

## Billing

### Free Trial

We offer a no risk, fully featured, free trial. Enter a credit or debit card anytime to continue using Scout APM after the end of your trial.

### Billing Date

Your first bill is 30 days after your signup date.

### Subscriptions

We offer both monthly and anual subscriptions with varying transaction levels and capabilities. Contact [support@scoutapm.com](mailto:support@scoutapm.com) for pricing options.

## Replacing New Relic

Scout is an attractive <a href="https://scoutapm.com/newrelic-alternative" target="_blank">alternative to New Relic</a> for modern dev teams. We provide a laser-focus on getting to slow custom application code fast vs. wide breadth as debugging slow custom application code is typically the most time-intensive performance optimization work.

In many cases, Scout is able to replace New Relic as-is. However, there are cases where your app has specific needs we currently don't provide. Don't fret - here's some of the more common scenarios and our suggestions for building a monitoring stack you'll love:

* __Exception Monitoring__ - Scout doesn't provide exception monitoring, but we do integrate with ([Rollbar](#rollbar) and [Sentry](#sentry)) to provide a side-by-side view of your performance metrics and errors within the Scout UI.

* __Browser Monitoring (Real User Monitoring)__ - there are a number of dedicated tools for both Real User Monitoring (RUM) and synthetic monitoring. We've [reviewed Raygun Pulse](https://scoutapm.com/blog/real-user-monitoring-with-raygun), an attractive RUM product. You can also continue to use New Relic for browser monitoring and use Scout for application monitoring.

## Our Monitoring Stack

Curious about what a company that lives-and-breathes monitoring (us!) uses to monitor our apps? [We shared our complete monitoring stack on our blog](https://scoutapm.com/blog/rails-monitoring-stack-2016).

### Talk to us about your monitoring stack

Don't hesitate to [email us](mailto:support@scoutapm.com) if you need to talk through your monitoring stack. Monitoring is something we know and love.
