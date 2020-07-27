# Core Agent

Some of the languages instrumented by Scout depend on a standalone binary for collecting and reporting data. We call this binary the Core Agent.

If the Core Agent is required for your language, the Scout agent library for that language will handle downloading, configuring, and launching the Core Agent automatically. However, you may manually manage the Core Agent through configuration options.

## Launching Core Agent manually

<table class="help">
  <tbody>
    <tr>
      <td>
        <span class="step">1</span>
      </td>
      <td>
        <p>Create a directory which your app has access to (for example: /var/www)</p>
<pre style='width:500px'>
cd /var/www
mkdir scout_apm_core
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">2</span>
      </td>
      <td>
        <p>Download and test the core agent:</p>
<pre style='width:500px'>
# 1. cd into the scout_apm_core directory
cd ./scout_apm-core

# 2. Download the core agent tarball
curl https://s3-us-west-1.amazonaws.com/scout-public-downloads/apm_core_agent/release/scout_apm_core-latest-x86_64-unknown-linux-gnu.tgz --output core-agent-download.tgz

# 3. Unzip the core-agent
tar -xvzf core-agent-download.tgz

# 4. Test that core agent is executable
./core-agent
</pre>
    <p style='margin-top:60px;margin-bottom:10px'>
    If everything has run successfully, you should see something similar to the following output:
    </p>
    <img src="images/core_agent_info.png" alt="core agent startup info/output"/>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">3</span>
      </td>
      <td>
        <p>Start the core agent:</p>
<pre style='width:500px'>
./core-agent start --socket ./core-agent.sock --daemonize true
</pre>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">4</span>
      </td>
      <td>
        <p>Check to see that core agent socket is running:</p>
<pre style='width:500px'>
 ./core-agent probe --socket  ./core-agent.sock
</pre>
        <p style='margin-top:50px'>If you are using one of the supported languages (PHP, Python, Elixir, and Node.js), you will have to set the following configuration variables to point to the correct socket (as well as disabling the agent from re-downloading and launching the core agent again):<p>
        <ul>
            <li><code>SCOUT_CORE_AGENT_SOCKET_PATH=/var/www/scout_apm_core</code></li>
            <li><code>SCOUT_CORE_AGENT_DOWNLOAD=false</code></li>
            <li><code>SCOUT_CORE_AGENT_LAUNCH=false</code></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

## Troubleshooting

### Unable to launch Core Agent in tmp directory

This could be due to a few issues, including the tmp directory being mounted as non executable, SELinux configuration, or your umask permissions.

To verify that this is your issue, please follow steps 1 and 2 in [Launching Core Agent manually](#launching-core-agent-manually) in a folder that your app has permissions to access (for ex: `/var/www/scout_apm_core`).

If you are able to launch the core agent manually, you will need to change your configuration file (where your Scout API key is located), and have `SCOUT_CORE_AGENT_DIR` point to the directory where you were able to manually launch the core agent (ex: `SCOUT_CORE_AGENT_DIR=/var/www/scout_apm_core`). See your language's agent configuration docs for more detail.


## Available platforms and architectures

Builds of the Core Agent are available for these platforms and architectures:

* Linux i686 (glibc)
* Linux x86-64 (glibc)
* Linux i686 (musl)
* Linux x86-64 (musl)
* OSX/Darwin x86-64



# Other languages

<aside class="notice">The Core Agent API is in our tech preview program.</aside>

Want to add tracing but Scout doesn't support your app's language? You can instrument just about anything (assuming you can communicate via a Unix Domain Socket) with Scout's [Core Agent API](https://github.com/scoutapp/core-agent-api). For information, view the [Core Agent API on GitHub](https://github.com/scoutapp/core-agent-api).