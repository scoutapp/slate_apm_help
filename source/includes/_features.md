# Features

Scout is Application Monitoring built for modern development teams. It's built to provide the fastest path to a slow line-of-code. [Signup for a trial](https://scoutapm.com/users/sign_up).

## App Performance Overview

The overview page provides an at-a-glance, auto-refreshing view of your app's performance and resource usage (mean response time by category, 95th percentile response time, throughput, error rate, and more). You can quickly dive into endpoint activity via click-and-drag (or pinch-and-expand with a mobile device) on the overview chart.

![overview](app_show.gif)

Additionally, you can compare metrics in the overview chart and see how your app's performance compares to different time periods.

## Endpoint Details

You can view metrics for specific controller-action and background job workers. There is a similar chart interaction to the App Performance Overview page, with one difference: your selection will render an updated list of transaction traces that correspond to the selected time period:
![stream](endpoint_show.gif)

You can sort traces by response time, object allocations, date, and more.

## Transaction Traces

Scout collects detailed transactions across your web endpoints and background jobs automatically. The transaction traces provide a number of visual queues to direct you to hotspots. Dig into bottlenecks - down to the line-of-code, author, commit date, and deploy time - from this view.

![transaction traces](trace_timeline.png)

### SQL Queries

Scout captures a sanitized version of SQL queries. Click the "SQL" button next to a call to view details.

![stream show sql](stream_show_sql_annotated.png)

#### Don't see an SQL button next to a database query?

Scout collects a sanitized version of SQL queries and displays these in transaction traces. To limit agent overhead sanitizing queries, we do not collect query statements with more than 16k characters.

This limit was raised to 16k characters from 4k characters in version 2.3.3 of the Ruby agent after determining the higher threshold was safe for production environments. If you have an older version of `scout_apm`, [update to the latest](#updating-to-the-newest-version).

### Code Backtraces

You'll see "CODE" buttons next to method calls that are >= 500 ms. [If you've enabled the GitHub integration](#github), you can see the line-of-code, associated SQL or HTTP endpoint (if applicable), author, commit date, and deploy time for the relevant slow code.

![stream show git](stream_slow_git_annotated.png)

If you don't enable the GitHub integration, you'll see a backtrace.

### Trace Views

There are two displays for showing the details of a transaction trace:

* __Summary View__ - Method calls are aggregated together and ordered from most to least expensive.
* __Timeline View__ - Shows the execution order of calls as they occur during the transaction.

#### Summary View

Method calls are aggregated together and listed from most expensive to least expensive. The time displayed is the total time across all calls (not the time per-call).

![stream show breakdown](stream_show_call_breakdown.png)

#### Timeline View

See the execution order of your code.

![trace timeline](trace_timeline_annotated.png)

The timeline view is especially helpful for:

* understanding the distribution of `Controller` time across a request. Is there a lot of time spent in your custom code at the beginning of a request? Is it spread out? Is it at the end of a request?
* understanding the timing of distinct SQL queries. Is one instance of many nearly identical queries slow or all of them?
* getting the complete picture of parent and children method calls. How many SQL calls are being triggered by the same view partial?

##### Upgrading to the timeline view

If you see a message in the UI prompting you to upgrade, [follow our Ruby agent upgrade instructions](#updating-to-the-newest-version) to update to the latest agent, which supports sending the timeline trace format.

##### Timeline view limitations

* No ScoutProf support
* No Background job support
* No DevTrace support

## Trace Explorer

What was the slowest request yesterday? How has the app performed for `user@domain.com`? Which endpoints are generating the bulk of slow requests? Trace Explorer lets you quickly filter the transaction traces collected by Scout, giving you answers to your unique questions.

![crossfilter](https://s3-us-west-1.amazonaws.com/scout-blog/s_vs_nr/crossfilter.gif)

Trace Explorer is accessed via the "Traces" navigation link when viewing an app.

### How to use Trace Explorer

There are two main areas of Trace Explorer:

* __Dimension Histograms__ - the top portion of the page generates a histogram representation for a number of trace dimensions (the response time distribution, count of traces by endpoints, and a display for each piece of [custom context](#context)). Selecting a specific area of a chart filters the transactions to just the selected data.
* __List of transaction traces__ - the bottom portion of the page lists the [individual traces](#transaction-traces). The traces are updated to reflect those that match any filtered dimensions. You can increase the height of this pane by clicking and dragging the top portion of the pane. Clicking on a trace URI opens the transaction trace in a new browser tab.

## AutoInstruments

<aside class="notice">AutoInstruments is in our BETA program.</aside>

In many apps, more than 30% of the time spent in a transaction is within custom code written by your development team. In traces, this shows up as time spent in "Controller" or "Job". AutoInstruments helps break down the time spent in your custom code without the need to add custom instrumentation on your own.

AutoInstruments instruments code expressions in Ruby on Rails controllers by instrumenting Ruby’s Abstract Syntax Tree ([AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree)) as code is loaded. These code expressions then appear in traces, just like the many libraries Scout already instruments:

![auto instruments trace](auto_instrument_trace.png)

In the screenshot of a trace above, 68% of the time would be allocated to the `Controller` without enabling AutoInstruments. With AutoInstruments enabled, `Controller` time is just 3% of the request and we can clearly see that most of the time is spent inside two method calls.

AutoInstruments is currently available for Ruby on Rails applications.

### Enabling AutoInstruments

AutoInstruments is a BETA feature and available to apps using Ruby 2.3.1+. To enable:

<table class="help install">
  <tbody>
    <tr>
      <td><span class="step">1</span></td>
      <td><p>Within your Rails app's directory, run:</p><pre>bundle update scout_apm</pre>
<p>AutoInstruments was released in <code>scout_apm</code> version 2.6.0.</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">2</span></td>
      <td><p>Set the <code>auto_instruments</code> <a href="auto_instruments_config">config option</a> to <code>true</code>.</p>

      If you are using a config file:
<pre>
# config/scout_apm.yml
production:
  auto_instruments: true</pre>

        If you are using environment variables:
<pre>
SCOUT_AUTO_INSTRUMENTS=true</pre>
      </td>


    </tr>

      <tr>
      <td><span class="step">3</span></td>
      <td><p>Deploy</p></td>
    </tr>
  </tbody>
</table>

A [detailed AutoInstruments FAQ](#autoinstruments-faq) is available in our reference area.

## Error Monitoring

<aside class="notice">Error Monitoring is in our BETA program.</aside>

Monitoring for your site just got easier. With our powerful error monitoring service backed by our class leading APM solution, let your developers get back to what really matters.

When the error monitoring service is enabled, you will gain access to the context in which errors occur on your application. With our high fidelity overview charts as well as our detailed error tracing, you will gain insights into your app's error trends as well as how these issues arose.

![error monitoring overview page](error_monitoring_service.png)

### Enabling Error Monitoring

Error Monitoring is a BETA feature and available to apps using Ruby 2.1+. To enable:

<table class="help install">
  <tbody>
    <tr>
      <td><span class="step">1</span></td>
      <td><p>Within your Rails app's directory, run:</p><pre>bundle update scout_apm</pre>
<p>Error Monitoring was released in <code>scout_apm</code> version 4.0.0.</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">2</span></td>
      <td><p>Set the <code>errors_enabled</code> <a href="#errors_enabled">config option</a> to <code>true</code>.</p>

      If you are using a config file:
<pre>
# config/scout_apm.yml
production:
  errors_enabled: true</pre>

        If you are using environment variables:
<pre>
SCOUT_ERRORS_ENABLED=true</pre>
      </td>


    </tr>

      <tr>
      <td><span class="step">3</span></td>
      <td><p>Deploy</p></td>
    </tr>
    <tr>
      <td><span class="step">4</span></td>
      <td><p>Reach out to <a href="mailto:support@scoutapm.com">support@scoutapm.com</a> to have us enable the service</p></td>
    </tr>
  </tbody>
</table>

## ScoutProf

<aside class="notice">ScoutProf will be deprecated and succeeded by <a href="#autoinstruments">AutoInstruments</a>.</aside>

Every millisecond, ScoutProf captures a backtrace of what each thread in your application is currently running.  Over many backtraces, when you combine them, it tells a story of what code paths are taking up the most time in your application.

Compared with our more traditional instrumentation of libraries like `ActiveRecord`, `Net::HTTP` and similar, ScoutProf works with your custom code.  Now, when your application spends time processing your data in custom application code, or in libraries that Scout doesn't yet instrument, instead of only being able to assign that to a large bucket of `ActionController` time, the time can be broken down to exactly what is taking up the most time.

Notice how the time in `ActionController` is broken down:

<a href="/images/scoutprof.png" target="_blank">![scoutprof](scoutprof.png)</a>

We still employ our traditional instrumentation, because it can give us deeper insights into common libraries, capturing the SQL being run, or the URL being fetched.

### Enabling ScoutProf

ScoutProf is a BETA feature. To enable:

<table class="help install">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td>
        <p>Modify your <code>Gemfile</code> entry for <code>scout_apm</code>, changing it to: <code>gem 'scout_apm', '~> 3.0.x'</code></p>
      </td>
    </tr>
    <tr>
      <td><span class="step">2</span></td>
      <td><p><code>bundle update scout_apm</code></p></td>
    </tr>
      <tr>
      <td><span class="step">3</span></td>
      <td><p>Deploy</p></td>
    </tr>
  </tbody>
</table>

A [detailed ScoutProf FAQ](#scoutprof-faq) is available in our reference area.

## Database Monitoring

When the database monitoring addon is enabled, you'll gain access to both a high-level overview of your database query performance and detailed information on specific queries. Together, these pieces make it easier to get to the source of slow query performance.

### Database Queries Overview

The high-level view helps you identify where to start:

<a href="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/overview.png"><img alt="overview" src="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/overview.png"/></a>

The chart at the top shows your app's most time-consuming queries over time. Beneath the chart, you'll find a sortable list of queries grouped by a label (for Rails apps, this is the ActiveRecord model and operation) and the caller (a web endpoint or a background job):

This high-level view is engineered to reduce the investigation time required to:

* __identify slow queries__: it's easy for queries to become more inefficient over time as the size of your data grows. Sorting queries by "95th percentile response time" and "mean response time" makes it easy to identify your slowest queries.
* __solve capacity issues__: an overloaded database can have a dramatic impact on your app's performance. Sorting the list of queries by "% time consumed" shows you which queries are consuming the most time in your database.

#### Zooming

__If there is a spike in time consumed or throughput, you can easily see what changed during that period__. Click and drag over the area of interest on the chart:

<a href="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/zoom.png"><img alt="zoom" src="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/zoom.png" /></a>

Annotations are added to the queries list when zooming:

* The change in rank, based on % time consumed, of each query. Queries that jump significantly in rank may trigger a dramatic change in database performance.
* The % change across metrics in the zoom window vs. the larger timeframe. If the % change is not significant, the metric is faded.

#### Database Events

Scout highlights significant events in database performance in the sidebar. For example, if time spent in database queries increases dramatically, you'll find an insight here. Clicking on an insight jumps to the time window referenced by the insight.

### Database Query Details

After identifying an expensive query, you need to see where the query is called and the underlying SQL. Click on a query to reveal details:

<a href="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/detail.png"><img alt="detail" src="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/detail.png"/></a>

You'll see the raw SQL and a list of individual query execution times that appeared in transaction traces. Scout collects backtraces on queries consuming more than 500 ms. If we've collected a backtrace for the query, you'll see an icon next to the timing information. Click on one of the traces to reveal that trace in a new window:

<a href="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/trace.png"><img alt="trace" src="https://s3-us-west-1.amazonaws.com/scout-blog/db_monitoring/trace.png"/></a>

The source of that trace is immediately displayed.

### Slow Query Insights

When the database monitoring addon is enabled, a new "Slow Query" insight is activated on your app dashboard:

![slow query insights](slow_query_insights.png)

This insight analyzes your queries in three dimensions, helping you focus on database optimizations that will most improve your app:

1. __Which queries are most impacting app performance?__ This is based on the total time consumed of each query, where time consumed is the average query latency multiplied by the query throughput.
2. __Which queries are significant bottlenecks inside web endpoints and background jobs?__ A single query that is responsible for a large percentage of the time spent in a transaction is a great place to investigate for a performance win.
3. __Which queries are consistently slow?__ These are queries that have a high average latency.



### Pricing

Database Monitoring is available as an addon. See your billing page for pricing information.

### Database Addon Installation

[Update](#updating-to-the-newest-version) - or install - the `scout_apm` gem in your application. There's no special libraries to install on your database servers.

### Database Monitoring Library Support

Scout currently monitors queries executed via ActiveRecord, which includes most relational databases (PostgreSQL, MySQL, etc).

### What does SQL#other mean?

Some queries may be identified by a generic `SQL#other` label. This indicates our agent was unable to generate a friendly label from the raw SQL query. Ensure you are running version 2.3.3 of the `scout_apm` gem or higher as this release includes more advanced query labeling logic.

## Memory Bloat Detection

If a user triggers a request to your Rails application that results in a large number of object allocations (example: loading a large number of ActiveRecord objects), your app may require additional memory. The additional memory required to load the objects in memory is released back very slowly. Therefore, a single memory-hungry request will have a long-term impact on your Rails app's memory usage.

There are 3 specific features of Scout to aid in fixing memory bloat.

### Memory Bloat Insights

The Insights area of the dashboard identifies controller-actions and background jobs that have triggered significant memory increases. An overview of the object allocation breakdown by tier (ActiveRecord, ActionView, etc) is displayed on the dashboard.

![memory insights](memory_insights.png)

### Memory Traces

When inspecting a [transaction trace](#transaction-traces), you'll see a "Memory Allocation Breakdown" section:

![memory trace](memory_trace.png)

For perspective, we display how this trace's allocations compare to the norm.

## Alerting

![alerts_chart](alerts_chart.png)

Alerting keeps your team updated if your app's performance degrades. Alerts can be configured on the app as a whole and on individual endpoints. Metrics include:

* mean response time
* 95th percentile response time
* Apdex
* error rate
* throughput

### Alert conditions

Configure alert conditions via the "Alerts" pill in the UI:

![alert_conditions](alert_conditions.png)

### Notification groups

Alerts are sent to a notification group, which is composed of notification channels. You can configure these under your org's settings menu:

![alert notification groups](alert_notification_groups.png)

## Deploy Tracking

![deploy tracking](deploy_tracking.png)

Correlate deploys with your app's performance: Scout's GitHub-enhanced deploy tracking makes it easy to identify the Git branch or tag running now and which team members contributed to every deploy.

Scout tracks your deploys without additional configuration if you are running Capistrano. If you aren't using Capistrano or deploying your app to Heroku, see our [deploy tracking configuration docs](#ruby-deploy-tracking-config).

### Sorting

You can sort by memory allocations throughout the UI: from the list of endpoints, to our pulldowns, to transaction traces.

![memory sort](memory_sort.png)

## Context

Context lets you see the forest from the trees. For example, you can add custom context to answer critical questions like:

* How many users are impacted by slow requests?
* How many trial customers are impacted by slow requests?
* How much of an impact are slow requests having on our highest paying customers?

Adding custom context is easy - learn how via [Ruby](#ruby-custom-context), [Elixir](#elixir-custom-context), or [Python](#python-custom-context).

Context information is displayed in two areas:

* When viewing a [transaction trace](#transaction-traces) - click the "Context" section to see the context Scout has collected.
* When using [Trace Explorer](#trace-explorer) - filter traces by context.

## Endpoints Performance

### Endpoints Overview

The endpoints area within Scout provides a sortable view of your app's overall performance aggregated by endpoint name. Click on an endpoint to view details.

![endpoints overview](endpoints_annotated.png)

## Time Comparisons

You can easily compare the performance of your application between different time periods via the time selection on the top right corner of the UI.

![time compare](time_compare_annotated.png)

## Digest Email

At a frequency of your choice (daily or weekly), Scout crunches the numbers on your app's performance (both web endpoints and background jobs). Performance is compared to the previous week, and highlights are mentioned in the email.

![digest](digest_screenshot.png)

The email identifies performance trends, slow outliers, and attempts to narrow down issues to a specific cause (like slow HTTP requests to another service).

## DevTrace

DevTrace is our development profiler: it's included with our Ruby and Elixir libraries. DevTrace can be used for free without signup. Enabling DevTrace adds a speed badge when navigating your app in development. Clicking the speed badge reveals a shareable transaction trace of the request.

![devtrace](devtrace.png)

View our [Ruby](#ruby-devtrace) and [Elixir](#elixir-devtrace) instructions.

## Request Queuing

Scout's PHP, Python, and Ruby integrations can measure the time it takes a request to reach your application from farther upstream (a load balancer or web server). This appears in Scout as "Request Queuing" and provides an indication of your application's capacity. Large request queuing time is an indication that your app needs more capacity.

<img src="images/request_queue_annotated.png" alt="request queuing" />

To see this metric within Scout, you need to configure your upstream software, adding an HTTP header that our agent reads. This is typically a one-line change.

### HTTP Header

The Scout agent depends on an HTTP request header set by an upstream load balancer (ex: HAProxy) or web server (ex: Apache, Ngnix).

__Protip:__ We suggest adding the header as early as possible in your infrastructure. This ensures you won't miss performance issues that appear before the header is set.

The agent will read any of the following headers as the start time of the request:

```ruby
%w(X-Queue-Start X-Request-Start X-QUEUE-START X-REQUEST-START x-queue-start x-request-start)
```

Include a value in the format `t=MICROSECONDS_SINCE_EPOCH` where `MICROSECONDS_SINCE_EPOCH` is an integer value of the number of microseconds that have elapsed since the beginning of Unix epoch.

__Nearly any front-end HTTP server or load balancer can be configured to add this header.__ Some examples are below.

### AWS

The Python integration also parses the `X-Amzn-Trace-Id` header set by AWS ELB's, if a queue start or request start header is not present.

### Heroku

Time in queue is automatically collected for apps deployed on Heroku. This measures the time from when a request hits the Heroku router and when your app begins processing the request.

### Apache

Apache's __mod_headers__ module includes a `%t` variable that is formatted for Scout usage. To enable request queue reporting, add this code to your Apache config:

````
RequestHeader set X-Request-Start "%t"
````

#### Apache Request Queuing and File Uploads

If you are using Apache, you may observe a spike in queue time within Scout for actions that process large file uploads. Apache adds the `X-Request-Start` header as soon as the request hits Apache. So, all of the time spent uploading a file will be reported as queue time.

This is different from Nginx, which will first buffer the file to a tmp file on disk, then once the upload is complete, add headers to the request.

### HAProxy

HAProxy 1.5+ supports timestamped headers and can be set in the frontend or backend section. We suggest putting this in the frontend to get a more accurate number:

````
http-request set-header X-Request-Start t=%Ts
````

### Nginx

Nginx 1.2.6+ supports the use of the `#{msec}` variable. This makes adding the request queuing header straightforward.

General Nginx usage:

````
proxy_set_header X-Request-Start "t=${msec}";
````

Passenger 5+:

````
passenger_set_header X-Request-Start "t=${msec}";
````

Older Passsenger versions:

````
passenger_set_cgi_param X-REQUEST-START "t=${msec}";
````

Note: The Nginx option is local to the <a href="https://www.phusionpassenger.com/library/config/nginx/reference/#this-configuration-option-is-not-inherited-across-contexts">location block</a>, and isn't inherited.


## Chart Embeds

You can embed an app's overview chart inside another web page (ex: an internal key metrics dashboard):

1. Access the application dashboard within the Scout UI.
2. Adjust the timeframe and metrics to those you'd like to include in the embedded chart.
3. Click the embed icon and copy the relevant code.

![chart_embed](chart_embed.png)

Note that you'll need to update the provided iframe url with a Scout API key.

When clicking on an embedded chart, you'll be redirected to the relevant application.

## Data Retention

Scout stores 30 days of metrics and seven days of transaction traces.
