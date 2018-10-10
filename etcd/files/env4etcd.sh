#ignore --param bools in environ
{% for key,value in etcd.service.items() if value not in (True, False) -%}
export ETCD_{{ key|string|upper }}={{ value or "" }}
{% endfor %}

#ignore --param bools in environ
{% for key,value in etcd.etcdctl.items() if value not in (True, False) -%}
export ETCDCTL_{{ key|string|upper }} {{ value or "" }}
{% endfor %}

export ETCD_HOME={{ etcd.realhome }}
export PATH=${PATH}:${ETCD_HOME}
