## Forward

Thank you for taking the time to read through 
this interactive document; this being the first of 3 parts.

I hope these hands-on, interactive lessons can reduce the startup 
cost of learning and eventually mastering [Ansible](newtab+https://www.ansible.com/).

## The Web Terminal

If you want to take advantage of the interactive, hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up 
yourself.

Instructions for that can be found [here](newtab+https://github.com/berttejeda/bert.bill#webterminal).

## Lesson 01

Here's what I will cover in this segment of my Ansible tutorial series:

- What is ansible?
- How to install Ansible on Windows/Linux/MacOS
- How to prepare a test environment for Ansible using Docker

Let's begin.

## What is Ansible?

As defined in [https://www.techtarget.com](https://www.techtarget.com)

> Ansible is a configuration management tool from Red Hat that automates the process of configuring multiple servers and deploying applications.

It speeds up installing software, configuring servers, and most importantly reduces manual, error-prone methods for managing modern infrastructure components.

It is also a great alternative to [Puppet](newtab+https://puppet.com/) and [Chef](newtab+https://www.chef.io/configuration-management/). 

Both are similar tools to Ansible, but in my opinion Ansible is much easier to learn and master.

In a nutshell, [Ansible](newtab+https://www.ansible.com/):
  
- Is like a higher-level, [idempotent](newtab+https://en.wikipedia.org/wiki/Idempotence#Computer_science_meaning) version of traditional shell scripts
- Is much, much easier to rapidly develop and manage, since its automation is (mostly) defined using [yaml](newtab+https://yaml.org/)
- Lends itself to [self-documenting development](newtab+https://en.wikipedia.org/wiki/Self-documenting_code)

### Terminology

Throughout the sections ahead, I'll make reference to the following ansible terms:

- [inventory](newtab+https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) - This is how ansible is made aware of the machines it is to manage
- [playbooks](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html) - This is the ansible version of a **bash** script
- [tasks](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#tasks-list) - Think of this as you would a neatly commented step in a **bash** script, only far more superior in structure and clarity
- [variables](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html) - Just like **bash** variables, ansible stores repeatable information in these named constructs
- [facts](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html) - Very similar to variables, but think more of these as values that <br />
  are automatically [derived](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#information-discovered-from-systems-facts) from a machine<br />
  or from a little bit of ansible [magic](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#magic-variables-and-how-to-access-information-about-other-hosts)

For more information on ansible terms, consult the [Ansible Glossary](newtab+https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html)

Let's go over installing Ansible

### Installing Ansible

#### Debian Systems

Installation on *Ubuntu* *20.04 LTS*:

<pre class='clickable-code'>
sudo apt-get update
sudo apt-get install -y curl software-properties-common || sudo apt-get install -y python-software-properties
sudo apt-get -y autoremove
sudo apt-get install -y --allow-unauthenticated python-setuptools python-dev libffi-dev libssl-dev git sshpass tree
sudo apt-get -y install python-pip
sudo pip install ansible cryptography
</pre>

#### RHEL Systems

Installation on *CentOS 8.x*, *Oracle Enterprise Linux 8.x*

<pre class='clickable-code'>
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum install -y ansible
</pre>

In the next sections, we'll cover writing and launching ansible playbooks.

My editor of choice is [Sublime 3 Text Editor](newtab+https://www.sublimetext.com/3), 
but we'll be using `vi` throughout this lab.

## Writing ansible playbooks

As defined in [https://www.techtarget.com](https://www.techtarget.com):

> An Ansible playbook is an organized unit of scripts that 
> defines the tasks involved in managing a system configuration using the automation tool Ansible. 

Read more from the official [documentation](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)

Let's create our first playbook:

- Create a folder for your playbook:<br />
  `mkdir -p sandbox`
- Create a playbook under this path named **hello.yaml**<br />
  `touch sandbox/hello.yaml`
- Add the playbook definition with a single debug task:<br />

  <pre class='clickable-code'>
  echo -e """
  - hosts: localhost
    connection: local
    tasks:
      - name: debug | Say Hello!
        debug:
          msg: |
            Hello from the imported playbook!
  """ >> sandbox/hello.yaml 
  </pre>

- Run the playbook locally:<br />
  `ansible-playbook -i 'localhost ansible_connection=local,' sandbox/hello.yaml`

That's it! You've executed your first ansible playbook!

## Wrap Up

This concludes lesson-01. 

In lesson-02, we'll be converting a complicated bash shell script into an Ansible Playbook.

Lesson-02 will cover:

- Playbooks and Tasks
- Templates and Handlers
- Variables & Facts
- Task Blocks