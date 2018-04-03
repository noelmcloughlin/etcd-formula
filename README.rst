.. image:: https://travis-ci.org/RobertFach/etcd-formula.svg?branch=master
    :target: https://travis-ci.org/RobertFach/etcd-formula

etcd
====

Formula to install and configure etcd.

.. note::

Available states
================

.. contents::
    :local:

``etcd``
----------

Install etcd and startup the service in cluster mode by using a static node configuration. The following pillar
data is an example for a static node configuration. Have also a look at `pillar.example`.

Example Pillar:

.. code:: yaml

  etcd:
    cluster:
      peers:
        node-1:
          ip: 192.168.1.10
        node-2:
          ip: 192.168.1.11
        node-3:
          ip: 192.168.1.12

``proxy``
---------

Install etcd and startup the service in proxy mode by using a static node configuration. Have a look at
`pillar.example` to see howto define static nodes.

``salt-client-proxy``
---------------------

Installs an etcd.conf under /etc/salt/master.d which creates a Salt etcd profile `etcd_config` that can be used
by Salt etcd module. It also calls `proxy` state to make sure a proxy listening on 127.0.0.1 exists on this node.

``salt-client``
---------------

I do not recommend to use this state because it's less flexible and fault-tolerant then the `salt-client-proxy` state.

Installs an etcd.conf under /etc/salt/master.d which creates a Salt etcd profile `etcd_config` that can be used
by Salt etcd module. The etcd.host entry points to the first node in the peer list (Salts etcd module doesn't allow to specify multiple hosts).


Testing
=======

Right now, some basic testing is done on Travis CI.
