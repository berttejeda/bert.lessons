<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](newtab+https://github.com/thlorenz/doctoc)*

- [Forward](#forward)
- [The Web Terminal](#the-web-terminal)
- [What This Lab Covers](#what-this-lab-covers)
- [What is Ansible?](#what-is-ansible)
  - [Terminology](#terminology)
- [Installing Ansible](#installing-ansible)
  - [Debian Systems](#debian-systems)
  - [RHEL Systems](#rhel-systems)
- [Writing ansible playbooks](#writing-ansible-playbooks)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<a name="forward"></a>
## Forward

Thank you for taking the time to read through 
this interactive document, this being the first of 3 parts.

I hope these hands-on, interactive lessons can reduce the startup 
cost of learning and eventually mastering Ansible.

<a name="the-web-terminal"></a>
## The Web Terminal

If you want to take advantage of the interactive and hands-on nature of these labs,
you'll need to either already have a web terminal connection available or fire one up 
yourself.

Instructions for that can be found in this repo's [README](newtab+../README.md).

From here on, I will make the assumption that your web terminal 
connection is ready and accepting connections from your computer.

<a name="what-this-lab-covers"></a>
## What This Lab Covers

Here's what I will cover for Lab 1 of this Ansible tutorial series:

- What is ansible?
- How to install Ansible on Windows/Linux/MacOS
- How to prepare a test environment for Ansible using Docker

Let's begin.

<a name="what-is-ansible"></a>
## What is Ansible?

Ansible is a simple yet powerful tool for configuration management and orchestration of your infrastructure. 

It speeds up installing software, configuring servers, and most importantly reduces manual, error-prone methods for managing modern infrastructure components.

It is also a great alternative to [Puppet](newtab+https://puppet.com/) and [Chef](newtab+https://www.chef.io/configuration-management/). 

Both are similar tools to Ansible, but in my opinion Ansible is much easier to learn and master.

In a nutshell, [Ansible](newtab+https://www.ansible.com/):
  
- Is like a higher-level, [idempotent](newtab+https://en.wikipedia.org/wiki/Idempotence#Computer_science_meaning) version of traditional shell scripts
- Is much, much easier to rapidly develop and manage, since its automation is (mostly) defined using [yaml](newtab+https://yaml.org/)
- Lends itself to [self-documenting development](newtab+https://en.wikipedia.org/wiki/Self-documenting_code)

<a name="terminology"></a>
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

[Back to Top](#top)
<a name="installing-ansible"></a>
## Installing Ansible

### Alpine Systems

### Debian Systems

Installation on *Ubuntu* *20.04 LTS*:

<pre class='clickable-code'>
sudo apt-get update
sudo apt-get install -y curl software-properties-common || sudo apt-get install -y python-software-properties
sudo apt-get -y autoremove
sudo apt-get install -y --allow-unauthenticated python-setuptools python-dev libffi-dev libssl-dev git sshpass tree
sudo apt-get -y install python-pip
sudo pip install ansible cryptography
</pre>

<a name="rhel-systems"></a>
### RHEL Systems

Installation on *CentOS 8.x*, *Oracle Enterprise Linux 8.x*

<pre class='clickable-code'>
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
yum install -y ansible
</pre>

In the next sections, we'll cover writing and launching ansible playbooks.

My editor of choice is [Sublime 3 Text Editor](newtab+https://www.sublimetext.com/3), 
but we'll be using `vi` throughout this lab.

[Back to Top](#top)
<a name="writing-ansible-playbooks"></a>
## Writing ansible playbooks

The fun starts when you learn your way around ansible [playbooks](newtab+https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)!

Let's create some of these, as Follows:

- Create a folder for your playbook:<br />
  `mkdir -p sandbox`
- Create a playbook under this path named **hello.yaml**
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

- Run the playbook, specifying your inventory as 'localhost':<br />
  `ansible-playbook -i localhost, sandbox/hello.yaml`

This concludes lab1. 

In lesson-02, we'll be converting a complicated bash shell script into an Ansible Playbook.

Lesson-02 will cover:

- Playbooks and Tasks
- Templates and Handlers
- Variables & Facts
- Task Blocks

[Back to Top](#top)