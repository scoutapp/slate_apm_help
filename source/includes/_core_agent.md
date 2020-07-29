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
        <p>Create a directory which your app has permissions to read, write and execute into (for our example we will use: /var/www)</p>
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
./core-agent start --daemonize true
</pre>
<p style='margin-top:50px'><strong>Note:</strong> this will not persist past a reboot. We suggest adding the core agent to upstart, systemd, or any other processes manager you may be using.<p>
<p style='margin-top:20px'>For additional startup flags, check the in-executable help with <code>./core-agent start --help</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <span class="step">4</span>
      </td>
      <td>
        <p>Check to see that core agent socket is running:</p>
<pre style='width:500px'>
 ./core-agent probe
</pre>
        <p style='margin-top:50px'>If you are using one of the supported languages (PHP, Python, Elixir, and Node.js), you will have to set the following configuration variables to point to the correct socket (as well as disabling the agent from re-downloading and launching the core agent again):<p>
        <ul>
            <li><code>SCOUT_CORE_AGENT_SOCKET_PATH=/var/www/scout_apm_core/scout-agent.sock</code></li>
            <li><code>SCOUT_CORE_AGENT_DOWNLOAD=false</code></li>
            <li><code>SCOUT_CORE_AGENT_LAUNCH=false</code></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

## Downloading the core agent to another directory
By default, the core agent will be downloaded into the /tmp directory. However due to /tmp being as mounted as not executable, or SELinux configuration, or your umask permissions, you may not be able to execute the core-agent in that directory. 

To change the directory that Scout downloads to, use the configuration SCOUT_CORE_AGENT_DIR. Your app must have read, write, and execute permissions for this directory. 

Read your language's agent configuration reference for more detail.

## Troubleshooting

### Checking if the core agent is executable

In some cases, the core agent won't be able to execute. You may be presented with an error message that looks similar to:

<code style='width: 500px; white-space: normal'>
[Scout] Failed to launch core agent - exception core-agent exited with non-zero status. 
Output: sh: 1: /tmp/scout_apm_core/scout_apm_core-v1.2.9-x86_64-unknown-linux-musl/core-agent: Permission denied
</code>

Try following [Downloading the core agent to another directory](#downloading-the-core-agent-to-another-directory) above to see if you are able to execute the core agent in another directory to determine if there is a permissions issue with the default location.

If you continue having issues, please reach out to us at [support@scoutapm.com](mailto:support@scoutapm.com).

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