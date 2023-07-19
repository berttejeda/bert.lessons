# Forward

Thank you for taking the time to read through 
this interactive document.

I hope these hands-on, interactive lessons can reduce the startup 
cost of learning and eventually mastering [ARA](https://ara.readthedocs.io/).

# The Web Terminal

If you want to take advantage of the interactive, hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up 
yourself.

Instructions for that can be found [here](https://github.com/berttejeda/bert.dashboard#webterminal).

# ARA Records Ansible (ARA)

It's another recursive acronym and features simplicity as a core principle.

<img src="https://raw.githubusercontent.com/ansible-community/ara/master/doc/source/_static/ara-with-icon.png?raw=true" alt="ARA Logo" width="200"/>

# ARA Records Ansible (ARA)

[ARA](https://ara.readthedocs.io) is a tool that provides Ansible reporting by recording ``ansible`` and ``ansible-playbook`` commands wherever and however they are run:

- from a terminal, by hand or from a script
- from a laptop, desktop, server, VM or container
- for development, CI or production
- from most Linux distributions and even on Mac OS (as long as ``python >= 3.6`` is available)
- from tools that run playbooks such as AWX & Automation Controller (Tower), ansible-(pull|test|runner|navigator) and Molecule
- from CI/CD platforms such as Jenkins, GitHub Actions, GitLab CI, Rundeck and Zuul

# ARA Records Ansible (ARA)

As such, ARA:

- facilitates understanding and troubleshooting of your ansible runs
- provides a detailed audit trail for ansible executions

In addition to the built-in CLI, the data is made available through an included reporting interface as well as a REST API.

# How it works

ARA records results to SQLite, MySQL, and/or PostgreSQL databases with a standard [Ansible callback plugin](https://docs.ansible.com/ansible/latest/plugins/callback.html).

The callback plugin leverages built-in python API clients to send data to a REST API server:

<img src="https://raw.githubusercontent.com/ansible-community/ara/master/doc/source/_static/graphs/recording-workflow.png?raw=true" alt="Sequence Diagram" width="600"/>

# Requirements

- Any recent Linux distribution or Mac OS with python >=3.6 available
- The ara package (containing the Ansible plugins) must be installed for the same python interpreter as Ansible itself

# Getting started

Running the API server is **not** required to get started, 
as it is capable of recording data to a local sqlite database.

For production use, it is strongly encouraged to:

- [Enable authentication for the web interface and API](https://ara.readthedocs.io/en/latest/api-security.html#authentication) to avoid unintentionally leaking passwords, tokens, secrets or otherwise sensitive information that ara might come across and record
- [Configure the callback plugin to ignore sensitive files, host facts and CLI arguments (such as extra vars)](https://ara.readthedocs.io/en/latest/ansible-plugins-and-use-cases.html#ansible-plugins)
- Learn about the [best practices to improve playbook recording performance](https://ara.readthedocs.io/en/latest/troubleshooting.html#improving-playbook-recording-performance)

# Recording playbooks without an API server

- Install ansible (or ansible-core) with ara (including API server dependencies)<br />
`python3 -m pip install --user ansible "ara[server]"`
- View the path to the ara callback plugin<br />
`python3 -m ara.setup.callback_plugins`
- Use the previous command output to activate the ara callback plugin<br />
`export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"`

# Recording playbooks without an API server

-  Create our hello-world playbook<br />

<pre class='clickable-code'>
echo -e """
---
- hosts: localhost
  gather_facts: true
  become: true
  tasks:

    - name: Hello
      debug:
        msg: |-
          Hello World!
""" > hello-world.yaml
</pre>   

# Recording playbooks without an API server

- Execute the Ansible playbook<br />
`ansible-playbook -i 'localhost ansible_connection=local,' hello-world.yaml`<br />
- Use the CLI to see recorded playbooks<br />
`ara playbook list`
- In a separate terminal instance, start the local ARA development server<br />
`ARA_ALLOWED_HOSTS="['*']" ara-manage runserver 0.0.0.0:8000`
- Navigate to the reporting interface at http://127.0.0.1:8000 and review the playbook reports

# Recording playbooks without an API server

-  Create our hello-world-diff playbook<br />

<pre class='clickable-code'>
echo -e """

---
- hosts: localhost
  gather_facts: true
  become: true
  tasks:

    - name: Create a text file
      copy:
        dest: '{{ playbook_dir }}/date.txt'
        content: |-
          The current date & time is: {{ [ansible_date_time.year, ansible_date_time.month, ansible_date_time.day, ansible_date_time.hour, ansible_date_time.minute, ansible_date_time.second] | join('') }}
""" > hello-world-diff.yaml
</pre>   

# Recording playbooks without an API server

- Execute the Ansible playbook in diff mode<br />
`ansible-playbook -i 'localhost ansible_connection=local,' --diff hello-world-diff.yaml`<br />
- Navigate to the reporting interface at http://127.0.0.1:8000 and review the playbook reports
- Once finished, exit the local server instance with CTRL+C

# Recording playbooks with an API server

You can install the API server by using the [ara_api ansible role](https://github.com/ansible-community/ara-collection/blob/master/roles/ara_api/README.md), but 
the easiest way to roll it out is via docker.

- First, create a directory to store the API server settings and its sqlite database<br />
  `mkdir -p ./.ara/server`

# Recording playbooks with an API server

- Create your docker-compose document:<br />

<pre class='clickable-code'>
echo -e """
---
version: \"3.1\"
services:
  ansible-ara:
    image: "recordsansible/ara-api:latest"
    container_name: 'ansible-ara'
    restart: always
    ports:
      - "8000:8000"
    volumes:
      - ./.ara/server:/opt/ara
    environment:
      ARA_ALLOWED_HOSTS: \"['*']\"
""" > docker-compose.yml
</pre>

# Recording playbooks with an API server

Below are several ways to start the containerized api server:

- Via `docker-compose`<br />
  `docker-compose up -d`
- Via `docker run`<br />
  `docker run --name api-server --detach --tty
  --volume ~/.ara/server:/opt/ara -p 8000:8000
docker.io/recordsansible/ara-api:latest`
- Via `podman`<br />
  `podman run --name api-server --detach --tty
  --volume ~/.ara/server:/opt/ara -p 8000:8000
  quay.io/recordsansible/ara-api:latest`

# Recording playbooks with an API server

Once the server is running, ara's Ansible 
callback plugin must be installed and 
configured accordingly.

# Recording playbooks with an API server

- As before, configure Ansible to use the ara callback plugin<br />
  `export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"`
- Set up the ara callback to know where the API server is located<br />
  `export ARA_API_CLIENT="http"`<br />
  `export ARA_API_SERVER="http://127.0.0.1:8000"`

# Recording playbooks with an API server

- Execute the two Ansible playbooks from before:<br />
  `ansible-playbook -i 'localhost ansible_connection=local,' hello-world.yaml`<br />
  `ansible-playbook -i 'localhost ansible_connection=local,' --diff hello-world-diff.yaml`
- Use the CLI to see recorded playbooks<br />
  `ara playbook list`
- Lastly, navigate to the reporting interface at http://127.0.0.1:8000 and review the playbook reports as you did before

Data will be available on the API server in real time during playbook execution.

# Live demo

A live demo, deployed with the ara Ansible collection from [Ansible Galaxy](https://galaxy.ansible.com/recordsansible/ara),
is available at https://demo.recordsansible.org.

# Documentation and changelog

Documentation for installing, configuring, running, and using ara is available on [ara.readthedocs.io](https://ara.readthedocs.io).

Common issues may be resolved by reading the [troubleshooting guide](https://ara.readthedocs.io/en/latest/troubleshooting.html).

Changelog and release notes are available within the repository's [git tags](https://github.com/ansible-community/ara/tags) as well as the [documentation](https://ara.readthedocs.io/en/latest/changelog-release-notes.html).

# Community and getting help

- ARA [container images](https://ara.readthedocs.io/en/latest/container-images.html)
- Bugs, issues and enhancements: https://github.com/ansible-community/ara/issues
- IRC: #ara on [Libera.chat](https://web.libera.chat/?channels=#ara)
- Matrix: Bridged from IRC via [#ara:libera.chat](https://matrix.to/#/#ara:libera.chat)
- Slack: Bridged from IRC via [https://arecordsansible.slack.com](https://join.slack.com/t/arecordsansible/shared_invite/enQtMjMxNzI4ODAxMDQxLTU2NTU3YjMwYzRlYmRkZTVjZTFiOWIxNjE5NGRhMDQ3ZTgzZmQyZTY2NzY5YmZmNDA5ZWY4YTY1Y2Y1ODBmNzc>)
- Website and blog: https://ara.recordsansible.org
- ~~Twitter: https://twitter.com/recordsansible~~
- Mastodon: https://fosstodon.org/@ara