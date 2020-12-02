# Ruby Agent

<h2 id="ruby-requirements">Requirements</h2>

Our Ruby agent supports Ruby on Rails 2.2+ and Ruby 1.8.7+. See a [list of libraries we auto-instrument](#ruby-instrumented-libs).

[Memory Bloat detection](#memory-bloat-detection) and [ScoutProf](#scoutprof) require Ruby 2.1+.

Scout APM 4.0.0+ require Ruby 2.1+. If you're using a Ruby version lower than 2.1, you can still use Scout APM 2.6.10.

<h2 id="ruby_install">Installation</h2>

Tailored instructions are provided within our user interface. General instructions:

<table class="help install install_ruby">
  <tbody>
	  <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td>
			  <p>Your Gemfile:</p>
<pre>
gem 'scout_apm'
</pre>

        <p><strong>Shell:</strong></p>

<pre>
bundle install
</pre>
      </td>
    </tr>
    <tr>
     	<td><span class="step">2</span></td>
     	<td><p>Download your customized config file*, placing it at <code>config/scout_apm.yml</code>.</p>
        <p class="smaller">Your customized config file is available within your Scout account.</p>
      </td>
    </tr>
    <tr>
     	<td><span class="step">3</span></td>
     	<td><p>Deploy.</p></td>
    </tr>
 	</tbody>
</table>

<p>
* - If you've installed Scout via the Heroku Addon, the provisioning process automatically sets the required settings via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a> and a configuration file isn't required.
</p>

<h2 id="ruby-troubleshooting">Troubleshooting</h2>

### No Data

Not seeing any data?

<aside class="notice">Using Heroku? View our <a href="https://devcenter.heroku.com/articles/scout#troubleshooting">Heroku-specific troubleshooting instructions.</a></aside>


<table class="help">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td>
        <p>Is there a <code>log/scout_apm.log</code> file?</p>
        <p><strong style="color:gray">Yes:</strong></p>
        <p>Examine the log file for error messages:</p>
<pre>
tail -n1000 log/scout_apm.log | grep "Starting monitoring" -A20
</pre>
        <p>
          See something noteworthy? Proceed to <a href="#step7">to the last step</a>. Otherwise, continue to step 2.
        </p>
        <p><strong style="color:gray">No:</strong></p>
        <p>
          The gem was never initialized by the application.</p>
        <p>
          Ensure that the <code>scout_apm</code> gem is not restricted to a specific <code>group</code> in your <code>Gemfile</code>. For example, the configuration below would prevent <code>scout_apm</code> from loading in a <code>staging</code> environment:
        </p>
<pre>
group :production do
  gem 'unicorn'
  gem 'scout_apm'
end
</pre>
        <p><a href="#step7">Jump to the last step</a> if <code>scout_apm</code> is correctly configured in your <code>Gemfile</code>.</p>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td>
        <p>Was the <code><strong>scout_apm</strong></code> gem deployed with your application?</p>
<pre>
bundle list scout_apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">3</span>
      </td>
      <td>
        <p>Did you download the config file, placing it in <code><strong>config/scout_apm.yml</strong></code>?</p>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">4</span>
      </td>
      <td>
        <p>
          Did you restart the app and let it run for a while?
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">5</span>
      </td>
      <td>
        <a name="step5"></a>
        <p>Are you sure the application has processed any requests?</p>
<pre>
tail -n1000 log/production.log | grep "Processing"
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">6</span>
      </td>
      <td>
        <p>
          Using Unicorn?
        </p>
        <p>Add the <code>preload_app true</code> directive to your Unicorn config file. <a href="https://unicorn.bogomips.org/Unicorn/Configurator.html#method-i-preload_app">Read more</a> in the Unicorn docs.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <a name="step7"></a>
        <span class="step">7</span>
      </td>
      <td>
        <p>
          Oops! Still not seeing any data? Check out the <a href="https://github.com/scoutapp/scout_apm_ruby/issues">GitHub issues</a> and <a href="mailto:support@scoutapm.com">send us an email</a> with the following:
        </p>
        <ul>
          <li>The last 1000 lines of your <code>log/scout_apm.log</code> file, if the file exists:<br/><code>tail -n1000 log/scout_apm.log</code>.
          </li>
          <li>Your application's gems <code>bundle list</code>.
          </li>
          <li>
            Rails version
          </li>
          <li>
            Application Server (examples: Passenger, Thin, etc.)
          </li>
          <li>
            Web Server (examples: Apache, Nginx, etc.)
          </li>
        </ul>
        <p>
          We typically respond within a couple of hours during the business day.
        </p>
      </td>
    </tr>
  </tbody>
</table>

### Significant time spent in "Controller" or "Job"

When viewing a transaction trace, you may see time spent in the "controller" or "job" layers. This is time that falls outside of Scout's default instrumentation. There are two options for gathering additional instrumentation:

1. [Custom Instrumentation](#ruby-custom-instrumentation) - use our API to instrument pieces of code that are potential bottlenecks.
2. [ScoutProf](#scoutprof) - install our BETA agent which adds ScoutProf. ScoutProf breaks down time spent within the controller layer. Note that ScoutProf does not instrument background jobs.

### Missing memory metrics

Memory allocation metrics require the following:

* Ruby version 2.1+
* `scout_apm` version 2.0+

If the above requirements are not met, Scout continues to function but does not report allocation-related metrics.


## Updating to the Newest Version

The latest version of `scout_apm` is <code><span id="latest-gem-version">SEE CHANGELOG</span></code>.

<table class="help install">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td>
        <p>Ensure your Gemfile entry for Scout is: <code>gem 'scout_apm'</code> </p>
      </td>
    </tr>
    <tr>
      <td><span class="step">2</span></td>
      <td><p>Run <code> bundle update scout_apm</code></p></td>
    </tr>
      <tr>
      <td><span class="step">3</span></td>
      <td><p>Re-deploy your application.</p></td>
    </tr>
  </tbody>
</table>

The gem version changelog is [available here](https://github.com/scoutapp/scout_apm_ruby/blob/master/CHANGELOG.markdown).  
<h2 id="ruby-configuration-options">Configuration Options</h2>

The Ruby agent can be configured via the `config/scout_apm.yml` Yaml file and/or environment variables. A config file with your organization key is available for download as part of the install instructions.

### ERB evaluation

ERB is evaluated when loading the config file. For example, you can set the app name based on the hostname:

```yaml
common: &defaults
  name: <%= "ProjectPlanner.io (#{Rails.env})" %>
```

<h3 id="ruby-configuration-reference">Configuration Reference</h3>

The following configuration settings are available:

<table class="lookup">
  <thead>
    <tr>
      <th>
        Setting&nbsp;Name
      </th>
      <th>
        Description
      </th>
      <th>
        Default
      </th>
      <th>
        Required
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>
        name
      </th>
      <td>
        Name of the application (ex: 'Photos App').
      </td>
      <td>
        <code>Rails.application.class.to_s.
           sub(/::Application$/, '')</code>
      </td>
      <td>
        Yes
      </td>
    </tr>
    <tr>
      <th>
        key
      </th>
      <td>
        The organization API key.
      </td>
      <td></td>
      <td>
        Yes
      </td>
    </tr>
    <tr>
      <th>
        monitor
      </th>
      <td>
        Whether monitoring should be enabled.
      </td>
      <td>
        <code>false</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        errors_enabled
      </th>
      <td>
        Whether <a href="#ruby-error-monitoring">Error Monitoring</a> should be enabled.
      </td>
      <td>
        <code>false</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        log_level
      </th>
      <td>
        The logging level of the agent.
      </td>
      <td>
        <code>INFO</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        log_file_path
      </th>
      <td>The path to the <code>scout_apm.log</code> log file directory. Use <code>stdout</code> to log to STDOUT.
      </td>
      <td>
        <code>Environment#root+log/</code>&nbsp;or <code>STDOUT</code> if running on Heroku.
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        hostname
      </th>
      <td>
        The hostname the metrics should be aggregrated under.
      </td>
      <td>
        <code>Socket.gethostname</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        proxy
      </th>
      <td>Specify the proxy URL (ex: <code>https://proxy</code>) if a proxy is required.
      </td>
      <td></td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        host
      </th>
      <td>
        The protocol + domain where the agent should report.
      </td>
      <td>
        <code>https://scoutapm.com</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        uri_reporting
      </th>
      <td>
        By default Scout reports the URL and filtered query parameters with transaction traces. Sensitive parameters in the URL will be redacted. To exclude query params entirely, use
        <code>path</code>.
      </td>
      <td>
        <code>filtered_params</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        disabled_instruments
      </th>
      <td>
        An Array of instruments that Scout should not install. Each Array element should should be a string-ified, case-sensitive class name (ex: <code>['Elasticsearch','HttpClient']</code>). The default installed instruments can be viewed in the <a href="https://github.com/scoutapp/scout_apm_ruby/tree/master/lib/scout_apm/instruments" target="_blank">agent source</a>.
      </td>
      <td>
        <code>[]</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        ignore
      </th>
      <td>
        An Array of web endpoints that Scout should not instrument. Routes that match the prefixed path (ex: <code>['/health', '/status']</code>) will be ignored by the agent.
      </td>
      <td>
        <code>[]</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        enable_background_jobs
      </th>
      <td>
        Indicates if background jobs should be monitored.
      </td>
      <td>
        <code>true</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>dev_trace</th>
      <td>
        Indicates if DevTrace, the Scout development profiler, should be enabled. Note this setting only applies
        to the development environment.
      </td>
      <td>
        <code>false</code>
      </td>
      <td>No</td>
    </tr>
    <tr>
      <th>profile</th>
      <td>
        Indicates if ScoutProf, the Scout code profiler, should be enabled.
      </td>
      <td>
        <code>true</code>
      </td>
      <td>No</td>
    </tr>
    <tr>
      <th>revision_sha</th>
      <td>
        The Git SHA that corresponds to the version of the app being deployed.
      </td>
      <td>
        <a href="#ruby-deploy-tracking-config">See docs</a>
      </td>
      <td>No</td>
    </tr>
    <tr>
      <th>detailed_middleware</th>
      <td>
        When true, the time spent in each middleware is visible in transaction traces vs. an aggregrate across all middlewares. This
        adds additional overhead and is disabled by default as middleware is an uncommon bottleneck.
      </td>
      <td>
        <code>false</code>
      </td>
      <td>No</td>
    </tr>
    <tr>
      <th>collect_remote_ip</th>
      <td>
        Automatically capture end user IP addresses as part of each trace's context.
      </td>
       <td>
         <code>true</code>
       </td>
      <td>No</td>
    </tr>
    <tr>
      <th>timeline_traces</th>
      <td>
        Send traces in both the summary and <a href="#timeline-transaction-trace">timeline</a> formats.
      </td>
       <td>
         <code>true</code>
       </td>
      <td>No</td>
    </tr>
    <tr>
      <th id="auto_instruments_config">auto_instruments</th>
      <td>
        Instrument custom code with <a href="#autoinstruments">AutoInstruments</a>.
      </td>
       <td>
         <code>false</code>
       </td>
      <td>No</td>
    </tr>
    <tr>
      <th id="auto_instruments_ignore_config">auto_instruments_ignore</th>
      <td>
        Excludes the listed files names from being autoinstrumented. Ex: <code>['application_controller']</code>.
      </td>
       <td>
         <code>[]</code>
       </td>
      <td>No</td>
    </tr>
    <tr>
      <th>errors_ignored_exceptions</th>
      <td>
        Excludes certain exceptions from being reported
      </td>
       <td>
         <code>[ActiveRecord::RecordNotFound, ActionController::RoutingError]</code>
       </td>
      <td>No</td>
    </tr>
    <tr>
      <th>errors_filtered_params</th>
      <td>
        Filtered parameters in exceptions
      </td>
       <td>
         <code>[password, s3-key]</code>
       </td>
      <td>No</td>
    </tr>
  </tbody>
</table>

<h3 id="ruby-env-vars">Environment Variables</h3>

You can also configure Scout APM via environment variables. _Environment variables override settings provided in_ `scout_apm.yml`.

To configure Scout via enviroment variables, uppercase the config key and prefix it with `SCOUT`. For example, to set the key via environment variables:

```ruby
export SCOUT_KEY=YOURKEY
```
<h2 id="ruby-deploy-tracking-config">Deploy Tracking Config</h2>

Scout can [track deploys](#deploy-tracking), making it easier to correlate changes in your app to performance. To enable deploy tracking, first ensure you are on the latest version of `scout_apm`. See our [upgrade instructions](#updating-to-the-newest-version).

Scout identifies deploys via the following:

1. If you are using Capistrano, no extra configuration is required. Scout reads the contents of the `REVISION` and/or `revisions.log` file and parses out the SHA of the most recent release.
2. If you are using Heroku, enable [Dyno Metadata](https://devcenter.heroku.com/articles/dyno-metadata). This adds a `HEROKU_SLUG_COMMIT` environment variable to your dynos, which Scout then associates with deploys.
3. If you are deploying via a custom approach, set a `SCOUT_REVISION_SHA` environment variable equal to the SHA of your latest release.
4. If the app resides in a Git repo, Scout parses the output of `git rev-parse --short HEAD` to determine the revision SHA.

<h2 id="ruby-error-monitoring">Enabling Error Monitoring</h2>
**Only available for Ruby version 2.1+**

To enable our [Error Monitoring](#error-monitoring) service:

1. Update your Scout APM gem to 4.0.0+
2. Set [errors_enabled](#errors_enabled) to `true`
3. Deploy
4. Reach out to <a href="mailto:support@scoutapm.com">support@scoutapm.com</a> to have us enable the service

<h2 id="ruby-devtrace">Enabling DevTrace</h2>

To enable [DevTrace](#devtrace), our in-browser profiler:

<table class="help install">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td>
        <p>Ensure you are on the latest version of <code>scout_apm</code>.
          See our <a href="#updating-to-the-newest-version">upgrade instructions</a>.
        </p>
      </td>
    </tr>
    <tr>
      <td><span class="step">2</span></td>
      <td>
        <p style="line-height: 170%">
          Add <code>dev_trace: true</code> to the <code>development</code> section of your <code>scout_apm.yml</code> config file or start your local Rails server with:
          <code>SCOUT_DEV_TRACE=true rails server</code>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">3</span>
      </td>
      <td>
        <p>Refresh your browser window and look for the speed badge.</p>
      </td>
    </tr>
  </tbody>
</table>

<h2 id="ruby-server-timing">Server Timing</h2>

View performance metrics (time spent in ActiveRecord, Redis, etc) for each of your app's requests in Chrome’s Developer tools with the [server_timing](https://github.com/scoutapp/ruby_server_timing) gem. Production-safe.

![server timing](https://s3-us-west-1.amazonaws.com/scout-blog/ruby_server_timing.png)

For install instructions and configuration options, see [server_timing](https://github.com/scoutapp/ruby_server_timing) on GitHub.

## ActionController::Metal

Prior to agent version 2.1.26, an extra step was required to instrument `ActionController::Metal`
and <span style="white-space: nowrap;">`ActionController::Api`</span> controllers. After 2.1.26, this is automatic.

The previous instructions which had an explicit `include` are no longer
needed, but if that code is still in your controller, it will not harm
anything. It will be ignored by the agent and have no effect.



## Rack

Rack instrumentation is more explicit than Rails instrumentation, since Rack applications can take
nearly any form. After [installing our agent](#ruby_install), instrumenting Rack is a three step process:

1. Configuring the agent
2. Starting the agent
3. Wrapping endpoints in tracing

<h3 id="rack-config">Configuration</h3>

Rack apps are configured using the same approach as a Rails app: either via a `config/scout_apm.yml` config file or environment variables.

* __configuration file__: create a `config/scout_apm.yml` file under your application root directory. The file structure is outlined [here](#ruby-configuration-options).
* __environment variables__: see our docs on configuring the agent via [environment variables](#ruby-env-vars).

### Starting the Agent

Add the `ScoutApm::Rack.install!` startup call as close to the spot you
`run` your Rack application as possible.  <span style="white-space: nowrap;">`install!`</span>
should be called after you require other gems (ActiveRecord, Mongo, etc)
to install instrumentation for those libraries.

```ruby
# config.ru

require 'scout_apm'
ScoutApm::Rack.install!

run MyApp
```

### Adding endpoints

Wrap each endpoint in a call to `ScoutApm::Rack#transaction(name, env)`.

* `name` - an unchanging string argument for what the endpoint is. Example: `"API User Listing"`
* `env` - the rack environment hash

This may be fairly application specific in details.

Example:

```ruby
app = Proc.new do |env|
  ScoutApm::Rack.transaction("API User Listing", env) do
    User.all.to_json
    ['200', {'Content-Type' => 'application/json'}, [users]]
  end
end
```

If you run into any issues, or want advice on naming or wrapping endpoints, contact us at
support@scoutapm.com for additional help.

## Sinatra

Instrumenting a Sinatra application is similar to instrumenting a generic [Rack application](#rack).

<h3 id="sinatra-configuration">Configuration</h3>

The agent configuration (API key, app name, etc) follows the same process as the [Rack application config](#rack-config).

<h3 id="sinatra-starting-agent">Starting the agent</h3>

Add the `ScoutApm::Rack.install!` startup call as close to the spot you
`run` your Sinatra application as possible.  <span style="white-space: nowrap;">`install!`</span>
should be called _after_ you require other gems (ActiveRecord, Mongo, etc).

```ruby
require './main'

require 'scout_apm'
ScoutApm::Rack.install!

run Sinatra::Application
```

<h3 id="sinatra-transactions">Adding endpoints</h3>

Wrap each endpoint in a call to `ScoutApm::Rack#transaction(name, env)`. For example:

```ruby
get '/' do
  ScoutApm::Rack.transaction("get /", request.env) do
    ActiveRecord::Base.connection.execute("SELECT * FROM pg_catalog.pg_tables")
    "Hello!"
  end
end
```

See our [Rack docs for adding an endpoint](#adding-endpoints) for more details.

<h2 id="ruby-custom-context">Custom Context</h2>

[Context](#context) lets you see the forest from the trees. For example, you can add custom context to answer critical questions like:

* How many users are impacted by slow requests?
* How many trial customers are impacted by slow requests?
* How much of an impact are slow requests having on our highest paying customers?

It's simple to add [custom context](#context) to your app. There are two types of context:

### User Context

For context used to identify users (ex: email, name):

```ruby
ScoutApm::Context.add_user({})
```

Examples:

```ruby
ScoutApm::Context.add_user(email: @user.email)
ScoutApm::Context.add_user(email: @user.email, location: @user.location.to_s)
```

### General Context

```ruby
ScoutApm::Context.add({})
```

Examples:

```ruby
ScoutApm::Context.add(account: @account.name)
ScoutApm::Context.add(database_shard: @db.shard_id, monthly_spend: @account.monthly_spend)
```

### Default Context

Scout reports the Request URI and the user's remote IP Address by default.

### Context Types

Context values can be any of the following types:

* Numeric
* String
* Boolean
* Time
* Date

### Context Field Name Restrictions

Custom context names may contain alphanumeric characters, dashes, and underscores. Spaces are not allowed.

Attempts to add invalid context will be ignored.

### Example: adding the current user's email as context

Add the following to your `ApplicationController` class:

```ruby
before_filter :set_scout_context
```

Create the following method:

```ruby
def set_scout_context
  ScoutApm::Context.add_user(email: current_user.email) if current_user.is_a?(User)
end
```

### Example: adding the monthly spend as context

Add the following line to the `ApplicationController#set_scout_context` method defined above:

```ruby
ScoutApm::Context.add(monthly_spend: current_org.monthly_spend) if current_org
```

<h2 id="ruby-custom-instrumentation">Custom Instrumentation</h2>

Traces that allocate significant amount of time to `Controller` or `Job` are good candidates to add custom instrumentation. This indicates a significant amount of time is falling outside our default instrumentation.

### Limits

We limit the number of metrics that can be instrumented. Tracking too many unique metrics can impact the performance of our UI. Do not dynamically generate metric types in your instrumentation (ie `self.class.instrument("user_#{user.id}", "generate") { ... })` as this can quickly exceed our rate limits.

### Instrumenting method calls

To instrument a method call, add the following to the class containing the method:

```ruby
  class User
    include ScoutApm::Tracer

    def export_activity
      # Do export work
    end
    instrument_method :export_activity
  end
```

The call to `instrument_method` should be after the method definition.

#### Naming methods instrumented via `instrument_method`

In the example above, the metric will appear in traces as `User#export_activity`. On timeseries charts, the time will be allocated to a `Custom` type.

__To modify the type__:

```ruby
instrument_method :export_activity, type: 'Exporting'
```

A new `Exporting` metric will now appear on charts. The trace item will be displayed as `Exporting/User/export_activity`.

__To modify the name__:

```ruby
instrument_method :export_activity, type: 'Exporting', name: 'user_activity'
```

The trace item will now be displayed as `Exporting/user_activity`.

### Instrumenting blocks of code

To instrument a block of code, add the following:

```ruby
  class User
    include ScoutApm::Tracer

    def generate_profile_pic
      self.class.instrument("User", "generate_profile_pic") do
        # Do work
      end
    end
  end
```

#### Naming methods instrumented via `instrument(type, name)`

In the example above, the metric appear in traces as `User/generate_profile_pic`. On timeseries charts, the time will be allocated to a `User` type. To modify the type or simply, simply change the `instrument` corresponding method arguments.

<h3 id="ruby-renaming-transactions">Renaming transactions</h3>

There may be cases where you require more control over how Scout names transactions. For example, if you have a controller-action that renders both JSON and HTML formats and the rendering time varies significantly between the two, it may make sense to define a unique transaction name for each.

Use `ScoutApm::Transaction#rename`:

```ruby
class PostsController < ApplicationController
  def index                              
    ScoutApm::Transaction.rename("posts/foobar")                                   
    @posts = Post.all                    
  end
end
```

In the example above, the default name for the transaction is `posts/index`, which appears as `PostsController#index` in the Scout UI. Renaming the transaction to `posts/foobar` identifies the transaction as `PostsController#foobar` in the Scout UI.  

Do not generate highly cardinality transaction names (ex: `ScoutApm::Transaction.rename("posts/foobar_#{current_user.id}")`) as we limit the number of transactions that can be tracked. High-cardinality transaction names can quickly surpass this limit.

<h3 id="ruby-testing-instrumentation">Testing instrumentation</h3>

Improper instrumentation can break your application. It's important to test before deploying to production. The easiest way to validate your instrumentation is by running [DevTrace](#devtrace) and ensuring the new metric appears as desired.

After restarting your dev server with DevTrace enabled, refresh the browser page and view the trace output. The new metric should appear in the trace:

![custom devtrace](custom_devtrace.png)

## Rake + Rails Runner

Scout doesn't have a dedicated API for instrumenting `rake` tasks or transactions called via `rails runner`. Instead, we suggest creating basic wrapper tasks that spawn a background job in a [framework we support](#ruby-instrumented-libs). These jobs are automatically monitored by Scout and appear in the Scout UI under "background jobs".

For example, the following is a CronJob that triggers the execution of an `IntercomSync` background job:

```
10 * * * * cd /home/deploy/your_app/current && rails runner 'IntercomSync.perform_later'
```

## Sneakers

Scout doesn't instrument [Sneakers](https://github.com/jondot/sneakers) (a background processing framework for Ruby and RabbitMQ) automatically. To add Sneakers instrumentation:

* [Download the contents of this gist](https://gist.github.com/itsderek23/685c7485a3bd020b6cdd9b1d61cb847f). Place the file inside your application's `/lib` folder or similar.
* In `config/boot.rb`, add: `require File.expand_path('lib/scout_sneakers.rb', __FILE__)`
* In your `Worker` class, immediately following the `work` method, add<br/>`include ScoutApm::BackgroundJobIntegrations::Sneakers::Instruments`.

This treats calls to the `work` method as distinct transactions, named with the worker class.

Example usage:

```ruby
class BaseWorker
  include Sneakers::Worker

  def work(attributes)
    # Do work
  end
  # This MUST be included AFTER the work method is defined.
  include ScoutApm::BackgroundJobIntegrations::Sneakers::Instruments
end
```

## Docker <img src="images/docker.png" style="float:right;width: 150px" />

Scout runs within Docker containers without any special configuration.

It's common to configure Docker containers with environment variables. Scout can use [environment variables](#environment-variables) instead of the `scout_apm.yml` config file.

## Heroku <img src="images/heroku.png" style="float:right;width: 150px" />

Scout runs on Heroku without any special configuration. When Scout detects that an app is being served via Heroku:

* Logging is set to `STDOUT` vs. logging to a file. Log messages are prefixed with `[Scout]` for easy filtering.
* The dyno name (ex: `web.1`) is reported vs. the dyno hostname. Dyno hostnames are dynamically generated and don't have any meaningful information.

<h3 id="heroku-configuration">Configuration</h3>

Scout can be configured via environment variables. This means you can use `heroku config:set` to configure the agent. For example, you can set the application name that appears in the Scout UI with:

```bash
heroku config:set SCOUT_NAME='My Heroku App'
```

See the configuration section for more information on the available config settings and environment variable functionality.

### Using the Scout Heroku Add-on

Scout is also available as a [Heroku Add-on](https://elements.heroku.com/addons/scout). The add-on automates setting the proper Heroku config variables during the provisioning process.

## Cloud Foundry <img src="images/cf_logo.png" style="float:right;width: 150px" />

Scout runs on Cloud Foundry without any special configuration.

We suggest a few configuration changes in the `scout_apm.yml` file to best take advantage of Cloud Foundry:

1. Set `log_file_path: STDOUT` to send your the Scout APM log contents to the Loggregator.
2. Use the application name configured via Cloud Foundry to identify the app.
3. Override the hostname reported to Scout. Cloud Foundry hostnames are dynamically generated and don't have any meaningful information. We suggest using a combination of the application name and the instance index.

A sample config for Cloud Foundry that implements the above suggestions:

```yaml
common: &defaults
  key: YOUR_KEY
  monitor: true
  # use the configured application name to identify the app.
  name: <%= ENV['VCAP_APPLICATION'] ? JSON.parse(ENV['VCAP_APPLICATION'])['application_name'] : "YOUR APP NAME (#{Rails.env})" %>
  # make logs available to the Loggregator
  log_file_path: STDOUT
  # reports w/a more identifiable instance name using the application name and instance index. ex: rails-sample.0
  hostname: <%= ENV['VCAP_APPLICATION'] ? "#{JSON.parse(ENV['VCAP_APPLICATION'])['application_name']}.#{ENV['CF_INSTANCE_INDEX']}"  : Socket.gethostname %>

production:
  <<: *defaults

development:
  <<: *defaults
  monitor: false

test:
  <<: *defaults
  monitor: false

staging:
  <<: *defaults
```

## GraphQL <img src="images/graphql_logo.png" style="float:right;width: 110px;margin-bottom: 10px" />
If you have a GraphQL endpoint which serves any number of queries, you likely want to have each of those types of queries show up in the Scout UI as different endpoints. You can accomplish this by renaming the transaction during the request like so:

```ruby
scout_transaction_name = "GraphQL/" + operation_name
ScoutApm::Transaction.rename(scout_transaction_name)
```

Where `operation_name` is determined dynamically based on the GraphQL query. E.g. `get_profile`, `find_user`, etc.

Do not generate highly cardinality transaction names, like `ScoutApm::Transaction.rename("GraphQL/foobar_#{current_user.id}")`, as we limit the number of transactions that can be tracked. High-cardinality transaction names can quickly surpass this limit.

<h2 id="ruby-instrumented-libs">Instrumented Libraries</h2>

The following libraries are currently instrumented:

* Datastores
  * ActiveRecord
  * ElasticSearch
  * Mongoid
  * Moped
  * Redis
* Rack frameworks
  * Rails
  * Sinatra
  * Grape
  * Middleware
* Rails libraries
  * ActionView
  * ActionController
* External HTTP calls
  * HTTPClient
  * Net::HTTP
* Background Job Processing
  * Sidekiq
  * DelayedJob
  * Resque
  * Sneakers
  * Shoryuken

Additionally, [Scout can also instrument request queuing time](#request-queuing).

You can instrument your own code or other libraries via [custom instrumentation](#ruby-custom-instrumentation).

<h2 id="ruby-environments">Environments</h2>

It typically makes sense to treat each environment (production, staging, etc) as a separate application within Scout and ignore the development and test environments. Configure a unique app name for each environment as Scout aggregates data by the app name.

There are 2 approaches:

### 1. Modifying your scout_apm.yml config file

Here's an example `scout_apm.yml` configuration to achieve this:

```yaml
common: &defaults
  name: <%= "YOUR_APP_NAME (#{Rails.env})" %>
  key: YOUR_KEY
  log_level: info
  monitor: true

production:
  <<: *defaults

development:
  <<: *defaults
  monitor: false

test:
  <<: *defaults
  monitor: false

staging:
  <<: *defaults
```

### 2. Setting the SCOUT_NAME environment variable

Setting the `SCOUT_NAME` and `SCOUT_MONITOR` environment variables will override settings settings your `scout_apm.yml` config file.

To isolate data for a staging environment: `SCOUT_NAME="YOUR_APP_NAME (Staging)"`.

To disable monitoring: `SCOUT_MONITOR=false`.

See the full list of [configuration options](#ruby-configuration-options).

## Disabling a Node

To disable Scout APM on any node in your environment, just set `monitor: false` in your `scout_apm.yml` configuration file on that server, and restart your app server. Example:

```yaml
common: &defaults
  name: <%= "YOUR_APP_NAME (#{Rails.env})" %>
  key: YOUR_KEY
  log_level: info
  monitor: false

production:
  <<: *defaults
```

Since the YAML config file allows ERB evaluation, you can even programatically enable/disable nodes based on host name. This example enables Scout APM on web1 through web5:

```yaml
common: &defaults
  name: <%= "YOUR_APP_NAME (#{Rails.env})" %>
  key: YOUR_KEY
  log_level: info
  monitor: <%= Socket.gethostname.match(/web[1..5]/) %>

production:
  <<: *defaults
```

Aft you've disabled a node in your configuration file and restarted your app server, the node show up as inactive in the UI after 10 minutes.


## Overhead Considerations

Scout is built for production monitoring and is engineered to add minimal overhead. We test against several open-source benchmarks on significant releases to prevent releasing performance regressions.

There are a couple of scenarios worth mentioning where more overhead than expected may be observed.

### Enabling the detailed_middleware option

By default, Scout aggregates all middleware timings together into a single "Middleware" category. Scout can provide a detailed breakdown of middleware timings by setting `detailed_middleware: true` in the configuration settings.

This is `false` by default as instrumenting each piece of middleware adds additional overhead. It's common for Rails apps to use more than a dozen pieces of middleware. Typically, time spent in middleware is very small and isn't worth instrumenting. Additionally, most of these middleware pieces are maintained by third-parties and are thus more difficult to optimize.

### Resque Instrumentation

Since Resque works by forking a child process to run each job and exiting immediately when the job is finished, our instrumentation needs a way to aggregate the timing results and traces into a central store before reporting the information to our service. To support Resque, the Resque child process sends a simple payload to the parent which is listening via WEBRick on localhost. As long as there is one WEBRick instance listening on the configured port, then any Resque children will be able to send results back to it.

The overhead is usually small, but it is more significant than instrumenting background job frameworks like Sidekiq and DelayedJob that do not use forking. The lighter the jobs are, more overhead is incurred in the serialization and reporting to WEBRick. In our testing, for jobs that took ~18 ms each, we found that the overhead is about ~8%. If your jobs take longer than that, on average, the overhead will be lower.
