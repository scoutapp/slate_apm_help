# Python Agent

Scout's Python agent supports many popular libraries to instrument SQL queries, template rendering, HTTP requests and more.
The package is called `scout-apm` [on PyPI](https://pypi.org/project/scout-apm).
Source code and issues can be found on our [scout_apm_python](https://github.com/scoutapp/scout_apm_python) GitHub repository.

<h2 id="python-requirements">Requirements</h2>

`scout-apm` requires :

* Python 2.7 or 3.4+
* A POSIX operating system, such as Linux or macOS ([Request Windows support](https://github.com/scoutapp/scout_apm_python/issues/101)).

<h2 id="python-instrumented-libraries">Instrumented Libraries</h2>

Scout provides instrument for most of the popular Python libraries. Instrumentation may require some configuration (`Django`) or is automatically applied (`Requests`) by our agent.

### Some configuration required

The libraries below require a small number of configuration updates. Click on the respective library for instructions.

* [Bottle](#bottle)
* [CherryPy](#cherrypy)
* [Celery](#celery)
* [Dash](#dash)
* [Django](#django)
* [Dramatiq](#dramatiq)
* [Falcon](#falcon)
* [Flask](#flask)
* [Flask SQLAlchemy](#flask-sqlalchemy)
* [Huey](#huey)
* [Hug](#hug)
* [Nameko](#nameko)
* [Pyramid](#pyramid)
* [RQ](#rq)
* [SQLAlchemy](#sqlalchemy)

Additionally, [Scout can also instrument request queuing time](#request-queuing).

### Automatically applied

The libraries below are automatically detected by the agent during the startup process and do not require explicit configuration to add instrumentation.

* ElasticSearch
* Jinja2
* PyMongo
* Redis
* UrlLib3 (used by the popular Requests)

You can instrument your own code or other libraries via [custom instrumentation](#python-custom-instrumentation). You can suggest additional libraries you'd like Scout to instrument [on GitHub](https://github.com/scoutapp/scout_apm_python/issues).

## Bottle

General instructions for a Bottle app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Add Scout to your Bottle config:</p>

<pre style="width:initial">
from scout_apm.bottle import ScoutPlugin

app = bottle.default_app()
app.config.update({
    "scout.name": "YOUR_APP_NAME",
    "scout.key": "YOUR_KEY",
    "scout.monitor": True,
})

scout = ScoutPlugin()
bottle.install(scout)
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the call to <code>app.config.update</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## CherryPy

Scout supports CherryPy 18.0.0+.

General instructions for a CherryPy app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Attach the Scout plugin to your app:</p>

<pre class="terminal" style="width: initial">
import cherrypy

<span>from scout_apm.api import Config
from scout_apm.cherrypy import ScoutPlugin</span>

class Views(object):
    @cherrypy.expose
    def index(self):
        return "Hi"

app = cherrypy.Application(Views(), "/")

<span>Config.set(
    key="[AVAILABLE IN THE SCOUT UI]",
    monitor=True,
    name="A FRIENDLY NAME FOR YOUR APP",
)
scout_plugin = ScoutPlugin(cherrypy.engine)
scout_plugin.subscribe()</span>
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the call to <code>Config.set</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Celery

Scout supports Celery 3.1+.

Add the following to instrument Celery workers:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Configure Scout in your Celery application file:</p>

<pre class="terminal" style="width: initial">
<span>import scout_apm.celery</span>
<span>from scout_apm.api import Config</span>
from celery import Celery

app = Celery('tasks', backend='redis://localhost', broker='redis://localhost')

<span>
# If you are using app.config_from_object() to point to your Django settings
# and have configured Scout there, this is not necessary:
Config.set(
    key="[AVAILABLE IN THE SCOUT UI]",
    name="Same as Web App Name",
    monitor=True,
)
</span>
<span>scout_apm.celery.install(app)</span>
</pre>

The `app` argument is optional and was added in version 2.12.0, but you should provide it for complete instrumentation.

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> instead of calling <code>Config.set</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
        <p>Tasks will appear in the "Background Jobs" area of the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Dash

[Plotly Dash](https://dash.plot.ly/) is built on top of Flask. Therefore you should use the Scout Flask integration with the underlying Flask application object. For example:

<pre style="width:500px">
import dash
from scout_apm.flask import ScoutApm

app = dash.Dash("myapp")
app.config.suppress_callback_exceptions = True
flask_app = app.server

# Setup as per Flask integration
ScoutApm(flask_app)
flask_app.config["SCOUT_NAME"] = "A FRIENDLY NAME FOR YOUR APP"
</pre>

For full instructions, see [the Flask integration](#flask).

## Django

Scout supports Django 1.8+.

General instructions for a Django app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Configure Scout in your <code>settings.py</code> file:</p>
<pre style="width:500px">
# settings.py
INSTALLED_APPS = [
    "scout_apm.django",  # should be listed first
    # ... other apps ...
]

# Scout settings
SCOUT_MONITOR = True
SCOUT_KEY = "[AVAILABLE IN THE SCOUT UI]"
SCOUT_NAME = "A FRIENDLY NAME FOR YOUR APP"
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> instead of providing these settings in <code>settings.py</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

### Middleware

Scout automatically inserts its middleware into your settings on Django startup in its [`AppConfig.ready()`](https://docs.djangoproject.com/en/dev/ref/applications/#django.apps.AppConfig.ready).
It adds one at the very start of the middleware stack, and one at the end, allowing it to profile your middleware and views.

This normally works just fine.
However, if you need to customize the middleware order or prevent your settings being changed, you can include the Scout middleware classes in your settings yourself.
Scout will detect this and not automatically insert its middleware.

If you do customize, your metrics will be affected.
Anything included before the first *middleware timing* middleware will not be profiled by Scout at all (unless you add custom instrumentation).
Anything included after the *view* middleware will be profiled as part of your view, rather than as middleware.

To add the middleware if you're using new-style Django middleware in the [`MIDDLEWARE` setting](https://docs.djangoproject.com/en/dev/ref/settings/#std:setting-MIDDLEWARE), which was added in Django 1.10:

<pre style="width:500px">
# settings.py
MIDDLEWARE = [
    # ... any middleware to run first ...
    "scout_apm.django.middleware.MiddlewareTimingMiddleware",
    # ... your normal middleware stack ...
    "scout_apm.django.middleware.ViewTimingMiddleware",
    # ... any middleware to run last ...
]
</pre>

To add the middleware if you're using old-style Django middleware in the [`MIDDLEWARE_SETTINGS` setting](https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-MIDDLEWARE_CLASSES), which was removed in Django 2.0:

<pre style="width:500px">
# settings.py
MIDDLEWARE_CLASSES = [
    # ... any middleware to run first ...
    "scout_apm.django.middleware.OldStyleMiddlewareTimingMiddleware",
    # ... your normal middleware stack ...
    "scout_apm.django.middleware.OldStyleViewMiddleware",
    # ... any middleware to run last ...
]
</pre>

## Dramatiq

Scout supports Dramatiq 1.0+.

Add the following to instrument Dramatiq workers:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Add Scout to your Dramatiq broker:</p>
<pre class="terminal" style="width: initial">
import dramatiq
from dramatiq.brokers.rabbitmq import RabbitmqBroker
<span>from scout_apm.dramatiq import ScoutMiddleware</span>
<span>from scout_apm.api import Config</span>

broker = RabbitmqBroker()
<span>broker.add_middleware(ScoutMiddleware(), before=broker.middleware[0].__class__)</span>

<span>
Config.set(
    key="[AVAILABLE IN THE SCOUT UI]",
    name="Same as Web App Name",
    monitor=True,
)
</span>
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> instead of calling <code>Config.set</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
        <p>Tasks will appear in the "Background Jobs" area of the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Falcon

Scout supports Falcon 2.0+.

General instructions for a Falcon app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Attach the Scout middleware to your Falcon app:</p>

<pre style="width:initial">
import falcon
from scout_apm.falcon import ScoutMiddleware

scout_middleware = ScoutMiddleware(config={
    "key": "[AVAILABLE IN THE SCOUT UI]",
    "monitor": True,
    "name": "A FRIENDLY NAME FOR YOUR APP",
})
api = falcon.API(middleware=[ScoutMiddleware()])
# Required for accessing extra per-request information
scout_middleware.set_api(api)
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and pass an empty dictionary to <code>config</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Flask

Scout supports Flask 0.10+.

General instructions for a Flask app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Configure Scout inside your Flask app:</p>

<pre style="width:initial">
from scout_apm.flask import ScoutApm

# Setup a flask 'app' as normal

# Attach ScoutApm to the Flask App
ScoutApm(app)

# Scout settings
app.config["SCOUT_MONITOR"] = True
app.config["SCOUT_KEY"] = "[AVAILABLE IN THE SCOUT UI]"
app.config["SCOUT_NAME"] = "A FRIENDLY NAME FOR YOUR APP"
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the calls to <code>app.config</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

If your app uses `flask-sqlalchemy`, [see below](#flask-sqlalchemy) for additional instrumentation instructions.

## Flask SQLAlchemy

Instrument [`flask-sqlalchemy`](https://flask-sqlalchemy.palletsprojects.com/) queries by calling `instrument_sqlalchemy()` on your `SQLAlchemy` instance:

```py
from flask_sqlalchemy import SQLAlchemy
from scout_apm.flask.sqlalchemy import instrument_sqlalchemy

app = ...  # Your Flask app

db = SQLAlchemy(app)

instrument_sqlalchemy(db)
```

## Huey

Scout supports Huey 2.0+.

Add the following to instrument your Huey application:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>If you are using <a href="https://huey.readthedocs.io/en/latest/django.html">Huey's Django integration</a>, you only need to set up the <a href="#django">Django integration. Your Huey instance will be automatically instrumented.</p>

        <p>If you're using Huey outside of the Django integration, add Scout to your Huey instance:</p>
<pre class="terminal" style="width: initial">
from huey import SqliteHuey
<span>from scout_apm.api import Config</span>
<span>from scout_apm.huey import attach_scout</span>

broker = SqliteHuey()

<span>
Config.set(
    monitor=True,
    name="A FRIENDLY NAME FOR YOUR APP",
    key="[AVAILABLE IN THE SCOUT UI]",
)</span>
<span>attach_scout(huey)</span>
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> instead of calling <code>Config.set()</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
        <p>Tasks will appear in the "Background Jobs" area of the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Hug

Scout supports Hug 2.5.1+. Hug is based on Falcon so a Falcon version supported by [our integration](#falcon) is also needed.

General instructions for a Hug app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Configure Scout inside your Hug app:</p>

<pre class="terminal" style="width: initial">
from scout_apm.hug import integrate_scout

# Setup your Hug endpoints as usual


@hug.get("/")
def home():
    return "Welcome home."


<span># Integrate scout with the Hug application for this module
integrate_scout(
    __name__,
    config={
        "key": "[AVAILABLE IN THE SCOUT UI]",
        "monitor": True,
        "name": "A FRIENDLY NAME FOR YOUR APP",
    },
)
</span></pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the entries in <code>config</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Nameko

General instructions for a Nameko app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Configure scout once in the root of your app, and add a `ScoutReporter` to each Nameko service:</p>

<pre style="width:initial">
from scout_apm.api import Config
from scout_apm.nameko import ScoutReporter


Config.set(
    key="[AVAILABLE IN THE SCOUT UI]",
    name="A FRIENDLY NAME FOR YOUR APP",
    monitor=True,
)

class Service(object):
    name = "myservice"

    scout = ScoutReporter()

    @http("GET", "/")
    def home(self, request):
        return "Welcome home."
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the call to <code>Config.set</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## Pyramid

General instructions for a Pyramid app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Add Scout to your Pyramid config:</p>

<pre style="width:initial">
import scout_apm.pyramid

if __name__ == "__main__":
    with Configurator() as config:
        config.add_settings(
            SCOUT_KEY="[AVAILABLE IN THE SCOUT UI]",
            SCOUT_MONITOR=True,
            SCOUT_NAME="A FRIENDLY NAME FOR YOUR APP"
        )
        config.include("scout_apm.pyramid")

        # Rest of your config...
</pre>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the call to <code>config.add_settings</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## RQ

Scout supports RQ 1.0+.

Do the following to instrument your RQ jobs:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
<p>Use the Scout RQ worker class.</p>

<p>If you're using RQ directly, you can pass the <code>--worker-class</code> argument the worker command:</p>
<pre class="terminal" style="width: initial">
rq worker <span>--job-class scout_apm.rq.Worker</span> myqueue
</pre>

<p>If you're using the <a href="https://python-rq.org/patterns/">RQ Heroku pattern</a>, you can change your code to use the <code>scout_apm.rq.HerokuWorker</code> class:</p>
<pre class="terminal" style="width: initial">
from scout_apm.rq import HerokuWorker as Worker
</pre>

<p>If you're using Django-RQ, instead use the <a href="https://github.com/rq/django-rq#custom-job-and-worker-classes">custom worker setting</a> to point to our custom Worker class:</p>
<pre class="terminal" style="width: initial">
RQ = {
    "WORKER_CLASS": "scout_apm.rq.Worker",
}
</pre>

<p>If you're using your own <code>Worker</code> sub class already, you can subclass our <code>Worker</code> class:</p>

<pre class="terminal" style="width: initial">
<span>from scout_apm.rq import Worker</span>

class MyWorker(Worker):
    # your custom behaviour here
    pass
</pre>

<p>Or if you're combining one or more other <code>Worker</code> classes, you can add our mixin class <code>scout_apm.rq.WorkerMixin</code>:</p>

<pre class="terminal" style="width: initial">
from some.other.rq.extension import CustomWorker
<span>from scout_apm.rq import WorkerMixin</span>

class MyWorker(WorkerMixin, CustomWorker):
    pass
</pre>

  </td>
</tr>

<tr>
  <td><span class="step">3</span></td>
  <td style="padding-top: 15px">
<p>Configure Scout.</p>

<p>If you're using Django-RQ, ensure you have the <a href="#django">Django integration</a> installed, and this is handled for you.</p>

<p>If you're using RQ directly, create a <a href="https://python-rq.org/docs/workers/#using-a-config-file">config file</a> for it that runs the Scout API's <code>Config.set()</code>:</p>

<pre class="terminal" style="width: initial">
from scout_apm.api import Config
  
Config.set(
    key="YOUR_SCOUT_KEY",
    name="Same as Web App Name",
    monitor=True,
)
</pre>

<p>Pass the config file to <code>-c</code> argument to the worker command, as per <a href="https://python-rq.org/docs/workers/#using-a-config-file">the documentation</a>.</p>

<p>If you wish to configure Scout via environment variables, you don't need a config file. Set <code>SCOUT_KEY</code>, <code>SCOUT_NAME</code> and <code>SCOUT_MONITOR</code> instead.</p>

<p>
  If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
    
  </td>
</tr>

    <tr>
      <td><span class="step">4</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
        <p>Tasks will appear in the "Background Jobs" area of the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

## SQLAlchemy

Instrument SQLAlchemy queries:

```py
from scout_apm.sqlalchemy import instrument_sqlalchemy

# Assuming something like engine = create_engine('sqlite:///:memory:', echo=True)
instrument_sqlalchemy(engine)
```

## Starlette

Scout supports Starlette 0.12+.

General instructions for a Starlette app:

<table class="help install install_ruby">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td style="padding-top: 15px">
        <p>Install the <code>scout-apm</code> package:</p>
<pre style="width:500px">
pip install scout-apm
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td style="padding-top: 15px">
        <p>Configure Scout and attach its middleware to your Starlette app:</p>

<pre class="terminal" style="width: initial">
<span>from scout_apm.api import Config</span>
<span>from scout_apm.async_.starlette import ScoutMiddleware</span>
from starlette.applications import Starlette
from starlette.middleware import Middleware

<span>Config.set(
    key="[AVAILABLE IN THE SCOUT UI]",
    name="A FRIENDLY NAME FOR YOUR APP",
    monitor=True,
)</span>

middleware = [
<span>    # Should be *first* in your stack, so it's the outermost and can</span>
<span>    track all requests</span>
<span>    Middleware(ScoutMiddleware),</span>
]

app = Starlette(middleware=middleware)
</pre>

<p>If you're using Starlette <0.13, which <a href="https://github.com/encode/starlette/pull/704">refactored the middleware API</a>, instead use <code>app.add_middleware(ScoutMiddleware)</code>. Make sure it's the last call to <code>add_middleware()</code> so that Scout is the outermost middleware.</p>

<p>If you wish to configure Scout via environment variables, use <code>SCOUT_MONITOR</code>, <code>SCOUT_NAME</code> and <code>SCOUT_KEY</code> and remove the call to <code>Config.set</code>.</p>

<p>
If you've installed Scout via the Heroku Addon, the provisioning process automatically sets <code>SCOUT_MONITOR</code> and <code>SCOUT_KEY</code> via <a href="https://devcenter.heroku.com/articles/config-vars">config vars</a>. Only <code>SCOUT_NAME</code> is required.
</p>
      </td>
    </tr>
    <tr>
      <td><span class="step">3</span></td>
      <td style="padding-top: 15px">
        <p>Deploy.</p>
        <p>It takes approximatively five minutes for your data to first appear within the Scout UI.</p>
      </td>
    </tr>
  </tbody>
</table>

<h2 id="python-troubleshooting">Troubleshooting</h2>

Not seeing data? Email support@scoutapm.com with:

* A link to your app within Scout (if applicable)
* Your Python version
* The name of the framework and version you are trying to instrument, e.g. Flask 0.10.

We typically respond within a couple of hours during the business day.

<h2 id="python-configuration">Configuration Reference</h2>

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
        key
      </th>
      <td>
        The organization API key.
      </td>
      <td>
      </td>
      <td>
        Yes
      </td>
    </tr>
    <tr>
      <th>
        name
      </th>
      <td>
        Name of the application (ex: 'Photos App').
      </td>
      <td>
      </td>
      <td>
        Yes
      </td>
    </tr>
    <tr>
      <th>
        monitor
      </th>
      <td>
        Whether monitoring data should be reported.
      </td>
      <td>
        <code>false</code>
      </td>
      <td>
        Yes
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
        <code>hostname</code>
      </td>
      <td>
        Yes
      </td>
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
      <th>
        ignore
      </th>
      <td>
        A list of (relative) URL path prefixes to avoid collecting metrics for.
        If specified as an environment variable, it should be a comma-separated
        list. See <a href="#python-ignoring-transactions">Ignoring
        Transactions</h4>.
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
        revision_sha
      </th>
      <td>
        The Git SHA associated with this release.
      </td>
      <td>
        <a href="#python-deploy-tracking-config">See docs</a>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        shutdown_timeout_seconds
      </th>
      <td>
        Maximum amount of time, in seconds, to spend at flushing outstanding events to the core agent at shutdown.
        Set to 0 to disable.
      </td>
      <td>
        2.0
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        scm_subdirectory
      </th>
      <td>
        The relative path from the base of your Git repo to the directory which contains your application code.
      </td>
      <td>
      </td>
      <td>
        No
      </td>
    </tr>
  </tbody>
</table>

There are also some configuration options that affect how the core agent process is run.
Typically you don't need to change these:

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
        core_agent_dir
      </th>
      <td>
        Path to create the directory which will store the <a href="#core-agent">Core Agent</a>.
      </td>
      <td>
        <code>/tmp/scout_apm_core</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_config_file
      </th>
      <td>
        Point to a configuration file for the <a href="#core-agent">Core Agent</a>.
        This may be useful for debugging your setup with files provided by Scout APM staff.
        <br>
        <br>
        Prior to version 2.13.0, this was called <strong>config_file</strong>. That name now works as an alias, and takes precedence to allow old configuration to continue to work.
      </td>
      <td>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_download
      </th>
      <td>
        Whether to download the <a href="#core-agent">Core Agent</a> automatically, if needed.
      </td>
      <td>
        <code>True</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_launch
      </th>
      <td>
        Whether to start the <a href="#core-agent">Core Agent</a> automatically, if needed.
      </td>
      <td>
        <code>True</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_log_file
      </th>
      <td>
        The log file for the <a href="#core-agent">Core Agent</a> to write its logs to.
        If not set, it won't be written.
        <br>
        <br>
        This does not affect the logging configuration of the Python library.
        To change that, directly configure the python <code>logging</code> module as per <a href="#python-logging">the below documentation</a>.
        <br>
        <br>
        Prior to version 2.13.0, this was called <strong>log_file</strong>. That name now works as an alias, and takes precedence to allow old configuration to continue to work.
      </td>
      <td>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_log_level
      </th>
      <td>
        The log level of the <a href="#core-agent">Core Agent</a>.
        This should be one of: <code>"trace"</code>, <code>"debug"</code>, <code>"info"</code>, <code>"warn"</code>, <code>"error"</code>.
        <br>
        <br>
        This does not affect the log level of the Python library.
        To change that, directly configure the python <code>logging</code> module as per <a href="#python-logging">the below documentation</a>.
        <br>
        <br>
        Prior to version 2.6.0, this was called <strong>log_level</strong>. That name now works as an alias, and takes precedence to allow old configuration to continue to work.
      </td>
      <td>
        <code>"info"</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_permissions
      </th>
      <td>
        The permission bits to set when creating the directory of the <a href="#core-agent">Core Agent</a>.
      </td>
      <td>
        <code>700</code>
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_socket_path
      </th>
      <td>
        The path to the socket to connect to the <a href="#core-agent">Core Agent</a>, passed to it when launching.
        This does not normally need to be set, as it can be automatically derived to live in the same directoy as the core agent.
        <br>
        <br>
        Prior to version 2.13.0, this was called <strong>socket_path</strong>. That name now works as an alias, and takes precedence to allow old configuration to continue to work.
      </td>
      <td>
        Auto detected
      </td>
      <td>
        No
      </td>
    </tr>
    <tr>
      <th>
        core_agent_triple
      </th>
      <td>
        If you are running a MUSL based Linux (such as ArchLinux), you may need to explicitly specify the platform triple. E.g. <code>x86_64-unknown-linux-musl</code>
      </td>
      <td>
        Auto detected
      </td>
      <td>
        No
      </td>
    </tr>
  </tbody>
</table>

<h3 id="python-env-vars">Environment Variables</h3>

You can also configure Scout APM via environment variables. _Environment variables override settings provided from within Python._

To configure Scout via environment variables, uppercase the config key and prefix it with `SCOUT`. For example, to set the key via environment variables:

```
export SCOUT_KEY=YOURKEY
```

<h2 id="python-environments">Environments</h2>

It typically makes sense to treat each environment (production, staging, etc) as a separate application within Scout and ignore the development and test environments. Configure a unique app name for each environment as Scout aggregates data by the app name.

A common approach is to set a `SCOUT_NAME` environment variable that includes the app environment:

```
export SCOUT_NAME="YOUR_APP_NAME (Staging)"
```

This will override the `SCOUT_NAME` value provided in your `settings.py` file.


<h2 id="python-logging">Logging</h2>

Scout logs via the built-in Python logger, which means you can add a handler to the `scout_apm` package. If you don't setup logging, use the examples below as a starting point.

### Log Levels

The following log levels are available:

* CRITICAL
* ERROR
* WARNING
* INFO
* DEBUG

### Django Logging

To log Scout agent output in your Django application, copy the following into your `settings.py` file:

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'stdout': {
            'format': '%(asctime)s %(levelname)s %(message)s',
            'datefmt': '%Y-%m-%dT%H:%M:%S%z',
        },
    },
    'handlers': {
        'stdout': {
            'class': 'logging.StreamHandler',
            'formatter': 'stdout',
        },
        'scout_apm': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': 'scout_apm_debug.log',
        },
    },
    'root': {
        'handlers': ['stdout'],
        'level': os.environ.get('LOG_LEVEL', 'DEBUG'),
    },
    'loggers': {
        'scout_apm': {
            'handlers': ['scout_apm'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}
```

### Flask Logging

Add the following your Flask app:

```python
dictConfig({
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'stdout': {
            'format': '%(asctime)s %(levelname)s %(message)s',
            'datefmt': '%Y-%m-%dT%H:%M:%S%z',
        },
    },
    'handlers': {
        'stdout': {
            'class': 'logging.StreamHandler',
            'formatter': 'stdout',
        },
        'scout_apm': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': 'scout_apm_debug.log',
        },
    },
    'root': {
        'handlers': ['stdout'],
        'level': os.environ.get('LOG_LEVEL', 'DEBUG'),
    },
    'loggers': {
        'scout_apm': {
            'handlers': ['scout_apm'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
})
```

If `LOGGING` is already defined, merge the above into the existing Dictionary.

### Celery Logging

Add the following to our default Celery configuration:

```
import logging
logging.basicConfig(level='DEBUG')
```

### Custom Instrumentation logging

If you've [custom Scout instrumentation](#python-custom-instrumentation), add the following to record the agent logs:

```
import logging
logging.basicConfig(level='DEBUG')
```

<h2 id="python-custom-instrumentation">Custom Instrumentation</h2>

You can extend Scout to trace transactions outside our officially supported frameworks (e.g. Cron jobs and micro web frameworks) and time the execution of code that falls outside our auto instrumentation.

### Transactions & Timing

Scout’s instrumentation is divided into 2 areas:

1. __Transactions__: these wrap around a flow of work, like a web request or Cron job. The UI groups data under transactions. Use the `@scout_apm.api.WebTransaction()` decorator or wrap blocks of code via the `with scout_apm.api.WebTransaction('')` context manager.
2. __Timing__: these measure individual pieces of work, like an HTTP request to an outside service and display timing information within a transaction trace. Use the `@scout_apm.api.instrument()` decorator or the `with scout_apm.api.instrument() as instrument` context manager.

### Instrumenting transactions

A transaction groups a sequence of work under in the Scout UI. These are used to generate transaction traces. For example, you may create a transaction that wraps around the entire execution of a Python script that is ran as a Cron Job.

<h4 id="python-transaction-limits">Limits</h4>

We limit the number of unique transactions that can be instrumented. Tracking too many unique transactions can impact the performance of our UI. Do not dynamically generate transaction names in your instrumentation (i.e. `with scout_apm.api.WebTransaction('update_user_"+user.id')`) as this can quickly exceed our rate limits. Use [context](#python-custom-context) to add high-dimensionality information instead.

#### Getting Started

Import the API module and configure Scout:

```python
import scout_apm.api

# A dict containing the configuration for APM.
# See our Python help docs for all configuration options.
config = {
    "name": "My App Name",
    "key": "APM_Key",
    "monitor": True,
}

# The `install()` method must be called early on within your app code in order
# to install the APM agent code and instrumentation.
scout_apm.api.install(config=config)
```

<h4 id="python-web-or-background">Web or Background transactions?</h4>

Scout distinguishes between two types of transactions:

* `WebTransaction`: For transactions that impact the user-facing experience. Time spent in these transactions will appear on your app overboard dashboard and appear in the "Web" area of the UI.
* `BackgroundTransaction`: For transactions that don't have an impact on the user-facing experience (example: cron jobs). These will be available in the "Background Jobs" area of the UI.

<h4 id="python-transaction-explicit">Explicit</h4>

```py
scout_apm.api.WebTransaction.start("Foo")  # or BackgroundTransaction.start()
# do some app work
scout_apm.api.WebTransaction.stop()
```

<h4 id="python-transaction-context-manager">As a context manager</h4>

```py
with scout_apm.api.WebTransaction("Foo"):  # or BackgroundTransaction()
    # do some app work
```

<h4 id="python-transaction-decorator">As a decorator</h4>

```py
@scout_apm.api.WebTransaction("Foo")  # or BackgroundTransaction()
def my_foo_action(path):
    # do some app work
```

#### Cron Job Example

```python
#!/usr/bin/env python

import requests
import scout_apm.api

# A dict containing the configuration for APM.
# See our Python help docs for all configuration options.
config = {
    "name": "My App Name",
    "key": "YOUR_SCOUT_KEY",
    "monitor": True,
}

# The `install()` method must be called early on within your app code in order
# to install the APM agent code and instrumentation.
scout_apm.api.install(config=config)

# Will appear under Background jobs in the Scout UI
with scout_apm.api.BackgroundTransaction("Foo"):
    response = requests.get("https://httpbin.org/status/418")
    print(response.text)
```

### Timing functions and blocks of code

Traces that allocate significant amount of time to `View`, `Job`, or `Template` are good candidates to add custom instrumentation. This indicates a significant amount of time is falling outside our default instrumentation.

<h4 id="python-span-limits">Limits</h4>

We limit the number of metrics that can be instrumented. Tracking too many unique metrics can impact the performance of our UI. Do not dynamically generate metric types in your instrumentation (ie `with scout_apm.api.instrument("Computation_for_user_" + user.email)`) as this can quickly exceed our rate limits.

For high-cardinality details, use tags: `with scout_apm.api.instrument("Computation", tags={"user": user.email})`.

<h4 id="python-span-getting-started">Getting Started</h4>

Import the API module:

```python
import scout_apm.api

# or to not use the whole prefix on each call:
from scout_apm.api import instrument
```

```python
scout_apm.api.instrument(name, tags={}, kind="Custom")
```

* `name` - A semi-detailed version of what the section of code is. It should be static between different invocations of the method. Individual details like a user ID, or counts or other data points can be added as tags. Names like `retreive_from_api` or `GET` are good names.
* `kind` - A high level area of the application. This defaults to `Custom`. Your whole application should have a very low number of unique strings here. In our built-in instruments, this is things like `Template` and `SQL`. For custom instrumentation, it can be strings like `MongoDB` or `HTTP` or similar. This should not change based on input or state of the application.
* `tags` - A dictionary of key/value pairs. Key should be a string, but value can be any json-able structure. High-cardinality fields like a user ID are permitted.

<h4 id="python-span-context-manager">As a context manager</h4>

Wrap a section of code in a unique "span" of work.

The yielded object can be used to add additional tags individually.

```python
def foo():
    with scout_apm.api.instrument("Computation 1") as instrument:
        instrument.tag("record_count", 100)
        # Work

    with scout_apm.api.instrument("Computation 2", tags={"filtered_record_count": 50}) as instrument:
        # Work
```

<h4 id="python-span-decorator">As a decorator</h4>

Wraps a whole function, timing the execution of specified function within a transaction trace. This uses the same API as the ContextManager style.

```python
@scout_apm.api.instrument("Computation")
def bar():
    # Work
```
## Instrumenting Async Code

If you need to instrument an asynchronous function, or a function that returns an awaitable,
you can use the `async_` decorator to decorate your function:

```python
@scout_apm.api.WebTransaction.async_("Foo")
async def foo():
    # app work

@scout_apm.api.BackgroundTransaction.async_("Bar")
async def bar():
    # app work

@scout_apm.api.instrument.async_("Spam")
async def spam():
    # app work

# Use async_ even though this function doesn't use async def
# because it returns an awaitable.
@scout_apm.api.instrument.async_("Returns Awaitable")
def returns_awaitable():
    return spam()
```

<aside class="notice">
  If you use the <code>.async_</code> decorator on a synchronous function that does not return an awaitable,
  a <code>RuntimeWarning</code> will be logged indicating that an awaitable was not awaited.
</aside>

<h2 id="python-ignoring-transactions">Ignoring Transactions</h2>

If you don't want to track the current transaction, at any point you can call `ignore_transaction()` to ignore it:

```python
import scout_apm.api

if is_health_check():
    scout_apm.api.ignore_transaction()
```

You can use this whether the transaction was started from a built-in integration or custom instrumentation.

You can also ignore a set of URL path prefixes by configuring the `ignore` setting:

```python
Config.set(
    ignore=["/health-check/", "/admin/"],
)
```

When specifying this as an environment variable, it should be a comma-separated list:

```bash
export SCOUT_IGNORE='/health-check/,/admin/'
```

<h3 id="python-renaming-transactions">Renaming Transactions</h3>

If you want to rename the current transaction, call `rename_transaction()` with the new name:

```python
import scout_apm.api

scout_apm.api.rename_transaction("Controller/" + derive_graphql_name())
```

You can use this whether the transaction was started from a built-in integration or custom instrumentation.

<h2 id="python-custom-context">Custom Context</h2>

[Context](#context) lets you see the forest from the trees. For example, you can add custom context to answer critical questions like:

* How many users are impacted by slow requests?
* How many trial customers are impacted by slow requests?
* How much of an impact are slow requests having on our highest paying customers?

It's simple to add [custom context](#context) to your app:

```python
import scout_apm.api
# scout_apm.api.Context.add(key, value)
scout_apm.api.Context.add("user_email", request.user.email)
```

### Context Key Restrictions

The Context `key` must be a `String` with only printable characters. Custom context keys may contain alphanumeric characters, dashes, and underscores. Spaces are not allowed.

Attempts to add invalid context will be ignored.

### Context Value Types

Context values can be any json-serializable type. Examples:

* `"1.1.1.1"`
* `"free"`
* `100`

<h2 id="python-upgrade">Updating to the Newest Version</h2>

```sh
pip install scout-apm --upgrade
```

The package changelog is [available here](https://github.com/scoutapp/scout_apm_python/blob/master/CHANGELOG.md).

<h2 id="python-deploy-tracking-config">Deploy Tracking Config</h2>

Scout can [track deploys](#deploy-tracking), making it easier to correlate specific deploys to changes in performance.

Scout identifies deploys via the following approaches:

* Setting the `revision_sha` configuration value:

```python
from scout_apm.api import Config
Config.set(revision_sha=os.popen("git rev-parse HEAD").read().strip())  # if the app directory is a git repo
```

* Setting a `SCOUT_REVISION_SHA` environment variable equal to the SHA of your latest release.
* If you are using Heroku, enable [Dyno Metadata](https://devcenter.heroku.com/articles/dyno-metadata). This adds a `HEROKU_SLUG_COMMIT` environment variable to your dynos, which Scout then associates with deploys.

## Ignoring Transactions

You can ignore transactions two ways:

The `ignore` configuration option. This is a list of URI paths that will be ignored if they match the path seen in Django, Flask, Bottle, Pyramid.
By calling `scout_apm.api.ignore_transaction()` from within your own code.
from `scout_apm.api` import Config
Config.set(ignore=["/healthcheck"])

`settings.py`:
```python
SCOUT_IGNORE = ["/healthcheck"]
```

`urls.py`:
```python
def healthcheck(request):
        return HttpResponse()

urlpatterns = [
    url(r'^healthcheck/?$', healthcheck),
    ...
]
```


